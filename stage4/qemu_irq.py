#!/usr/bin/env python3
"""QEMU proof of actual PIT IRQ0 delivery into the C-free FrancOS kernel.

This is a timer/counter test only. It does NOT prove preemption, fault
recovery, scheduling, or Ring 3 protection.
"""
from pathlib import Path
import os
import re
import selectors
import shutil
import subprocess
import sys
import tempfile
import time

root = Path(__file__).resolve().parent
image = Path(sys.argv[1] if len(sys.argv) > 1 else root / "native_seed.img")
qemu = shutil.which("qemu-system-x86_64")
assert qemu and image.exists(), "QEMU BIOS and a generated native kernel image required"

with tempfile.TemporaryDirectory(prefix="franc-timer-") as tmp:
    disk = Path(tmp) / "timer.img"
    shutil.copyfile(image, disk)
    guest = subprocess.Popen([
        qemu, "-m", "128M", "-accel", "tcg",
        "-display", "none", "-monitor", "none", "-no-reboot",
        "-serial", "stdio", "-drive", f"file={disk},format=raw,if=ide",
    ], stdin=subprocess.PIPE, stdout=subprocess.PIPE,
       stderr=subprocess.STDOUT, bufsize=0)
    selector = selectors.DefaultSelector()
    selector.register(guest.stdout, selectors.EVENT_READ)
    out = bytearray()

    def until(marker, start=0, timeout=130):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            if marker in out[start:]:
                return bytes(out[start:])
            if guest.poll() is not None:
                break
            if selector.select(0.15):
                chunk = os.read(guest.stdout.fileno(), 65536)
                if not chunk:
                    break
                out.extend(chunk)
        raise AssertionError(
            f"QEMU timer timeout: missing {marker!r} status={guest.poll()}; "
            f"log={bytes(out[-1800:])!r}"
        )

    def key(ch, marker):
        start = len(out)
        time.sleep(0.2)
        os.write(guest.stdin.fileno(), ch)
        return until(marker, start)

    def line(command, expected=None):
        start = len(out)
        for ch in command.encode("ascii"):
            before = len(out)
            os.write(guest.stdin.fileno(), bytes([ch]))
            until(bytes([ch]), before, 15)
            time.sleep(0.08)
        os.write(guest.stdin.fileno(), b"\n")
        result = until(b"Frac> ", start, 100)
        if b"stage2: unsupported token" in result:
            raise AssertionError(f"Kernel rejected {command!r}: {result!r}")
        if expected is not None and expected not in result:
            raise AssertionError(f"Incorrect {command!r}: {result!r}")
        return result

    def number(result):
        values = re.findall(rb"\n([0-9]+)\r?\nFrac> ", result)
        if not values:
            raise AssertionError(f"No numeric timer result: {result!r}")
        return int(values[-1])

    try:
        until(b"Franc> ", timeout=160)
        loaded = key(b"l", b"APPS READY")
        assert b"stage2: unsupported token" not in loaded, loaded[-1200:]
        key(b"r", b"Frac> ")
        assert number(line("irq-ticks .")) == 0
        if os.getenv("FRANC_TEST_RING3") == "1":
            assert number(line("ring3-probe .")) == 0, "Ring 3 must reject entry before protected IDT/TSS setup"
        if os.getenv("FRANC_TEST_PROC_ISO") == "1":
            assert number(line("process-fault-probe .")) == 0, (
                "Process probe must reject access before protected IDT/TSS setup"
            )
            assert number(line("space-probe .")) == 0, (
                "Independent CR3 root probe must reject setup without TSS/IRQ"
            )
        if os.getenv("FRANC_TEST_PREEMPT") == "1":
            assert number(line("preempt-asm-demo .")) == 0, "Preempt demo without IRQ must fail closed"
        if os.getenv("FRANC_TEST_JIT_PREEMPT") == "1":
            line("def task-one 17 99 begin 1 + 0 task-local@ 1 + 0 task-local! drop task-inc-a again ;")
            line("def task-two 23 199 begin 2 + 0 task-local@ 2 + 0 task-local! drop task-inc-b again ;")
            line("def task-short 1 task-inc-a ;")
            assert number(line("'task-one 'task-two task-preempt-run .")) == 0, (
                "Native JIT scheduling must reject launch before IRQ initialization"
            )
        line("irq-start .", b"1\nFrac> ")
        time.sleep(0.6)
        first = number(line("irq-ticks ."))
        time.sleep(0.5)
        second = number(line("irq-ticks ."))
        assert 2 <= first < second, (
            f"Hardware timer did not interrupt the Franc JIT: {first}, {second}"
        )
        if os.getenv("FRANC_TEST_PROC_ISO") == "1":
            count = number(line("e820-count ."))
            assert 2 <= count <= 48, f"Missing or unsafe BIOS E820 count: {count}"
            assert number(line("0 e820-base .")) == 0
            assert number(line("0 e820-type .")) == 1
            low_length = number(line("0 e820-length ."))
            assert 0x80000 <= low_length <= 0xA0000, low_length
            assert number(line("48 e820-type .")) == 0
            assert number(line("-1 e820-base .")) == 0
            assert number(line("page-arena-safe? .")) == 1, (
                "Allocator's fixed page arena was not affirmed by the BIOS E820 map"
            )
            print(f"PASS: BIOS E820 exposed {count} descriptors and authorized the 8 MiB page arena", flush=True)
            assert number(line("ring3-probe .")) == 1
            assert number(line("process-fault-probe .")) == 1
            assert number(line("process-a-state .")) == 4
            assert number(line("process-b-state .")) == 2
            assert number(line("process-b-steps .")) == 50000
            assert number(line("process-survived? .")) == 1
            assert number(line("ring3-fault-seen .")) == 1
            assert number(line("ring3-fault-address .")) == 65536
            assert number(line("process-fault-probe .")) == 0, "Process probe must be one-shot"
            assert number(line("2 3 + .")) == 5
            print("PASS: user process A faults in CPL3; isolated B page aliases execute 50000 steps, syscall and return", flush=True)
            # F1: both CPL3 users now have different E820-owned PML4 roots.
            assert number(line("page-free-count .")) == 2048
            assert number(line("space-probe .")) == 1, (
                "User A failed to fault across B's supervisor identity alias "
                "or user B failed to complete in an independent CR3"
            )
            root_a = number(line("space-root-a ."))
            root_b = number(line("space-root-b ."))
            assert root_a != root_b and 0x07000000 <= root_a < 0x07800000
            assert 0x07000000 <= root_b < 0x07800000
            assert number(line("space-state-a .")) == 4
            assert number(line("space-state-b .")) == 2
            bad_addr = number(line("space-fault-address ."))
            assert 0x07000000 <= bad_addr < 0x07800000
            assert number(line("space-reclaimed .")) == 12
            assert number(line("page-free-count .")) == 2048
            assert number(line("space-probe .")) == 0, "Space test must be one-shot"
            assert number(line("2 3 + .")) == 5
            print(f"PASS: independent CPL3 CR3 roots ({root_a:#x} != {root_b:#x}), cross-owner #PF and zeroed reclamation", flush=True)
        if os.getenv("FRANC_TEST_PREEMPT") == "1":
            prior_tick = number(line("irq-ticks ."))
            # Carry two host Rat values through 120 IRQ-driven switches;
            # workers independently exercise fr_push/fr_pop on private stacks.
            preserved = line("101 202 preempt-asm-demo . . .")
            assert b"1\n202\n101\nFrac> " in preserved, (
                f"Host rational stack was corrupted during CPU preemption: {preserved!r}"
            )
            a = number(line("preempt-a ."))
            b = number(line("preempt-b ."))
            assert a > 100 and b > 100, (a, b)
            post_tick = number(line("irq-ticks ."))
            assert post_tick - prior_tick >= 120, (prior_tick, post_tick)
            print(f"PASS: CPU and private Franc Rat stack pointers were preempted and restored ({a}, {b} verified push/pop iterations)", flush=True)
        if os.getenv("FRANC_TEST_JIT_PREEMPT") == "1":
            line("0 0 task-preempt-run .", b"0\nFrac> ")
            line("'task-one 'task-one task-preempt-run .", b"0\nFrac> ")
            start_tick = number(line("irq-ticks ."))
            # Both functions are compiled by the Franc Stage 2 JIT INSIDE QEMU,
            # perform arithmetic on distinct rational stacks, never yield and
            # increment independent native counters.
            result = line("101 202 'task-one 'task-two task-preempt-run . . .")
            assert b"1\n202\n101\nFrac> " in result, (
                f"Native Franc JIT preemption or host Rat stack preservation failed: {result!r}"
            )
            a = number(line("preempt-a ."))
            b = number(line("preempt-b ."))
            assert a > 100 and b > 100, (a, b)
            local_a = number(line("task-local-a0 ."))
            local_b = number(line("task-local-b0 ."))
            assert local_a > 100 and local_b > 200, (local_a, local_b)
            # Local slot zero belongs to each task separately, with
            # different increments despite identical numeric slot IDs.
            assert abs(local_a - a) <= 1 and abs(local_b - 2*b) <= 2, (
                (local_a, a), (local_b, b)
            )
            assert number(line("task-state-a .")) == 3
            assert number(line("task-state-b .")) == 3
            assert number(line("task-generation .")) == 1
            assert number(line("irq-ticks .")) - start_tick >= 120
            print(f"PASS: two never-yielding Franc JIT tasks with distinct rational stacks and task-local scalars ran under IRQ0 ({a}, {b} iterations)", flush=True)
            # A normally returning Franc JIT word must retire safely;
            # the other worker continues until the fixed timer budget expires.
            line("'task-short 'task-two task-preempt-run .", b"0\nFrac> ")
            assert number(line("task-state-a .")) == 2
            assert number(line("task-state-b .")) == 3
            assert number(line("task-generation .")) == 2
            assert number(line("task-local-a0 .")) == 0
            assert number(line("task-local-b0 .")) > 200
            line("9 task-local@ .", b"0\nFrac> ")
            assert number(line("2 3 + .")) == 5
            print("PASS: returned Franc JIT task retires without an invalid IRET; host REPL resumes", flush=True)
        if os.getenv("FRANC_TEST_RING3") == "1":
            value = number(line("ring3-probe ."))
            assert value == 1, f"Expected a valid user syscall and protected page fault, got {value}"
            assert number(line("ring3-user-cpl .")) == 3
            assert number(line("ring3-fault-seen .")) == 1
            assert number(line("ring3-fault-address .")) == 65536
            fault_code = number(line("ring3-fault-error ."))
            assert fault_code & 5 == 5, f"Expected supervisor protection error from CPL3: {fault_code}"
            assert number(line("ring3-probe .")) == 0, "One-shot TSS/IDT probe must reject repeated execution"
            assert number(line("2 3 + .")) == 5, "Kernel failed to resume native Franc REPL after user fault"
            print("PASS: genuine CPL3 INT80 return, user-mode kernel-memory #PF and Franc REPL recovery", flush=True)
        stopped = number(line("irq-stop ."))
        time.sleep(0.5)
        last = number(line("irq-ticks ."))
        assert stopped == last, (
            f"Ticks continued despite masking/CLI: {stopped} -> {last}"
        )
        print(
            f"PASS: x86-64 PIT IRQ0 hardware interrupt, IDT/IRET "
            f"and PIC EOI advanced Franc tick counter {first} -> {second}"
        )
        print("PASS: disabling PIC/CPU interrupts stopped hardware tick delivery")
    finally:
        guest.kill()
        guest.wait()
