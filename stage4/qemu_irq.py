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
        if os.getenv("FRANC_TEST_PREEMPT") == "1":
            assert number(line("preempt-asm-demo .")) == 0, "Preempt demo without IRQ must fail closed"
        line("irq-start .", b"1\nFrac> ")
        time.sleep(0.6)
        first = number(line("irq-ticks ."))
        time.sleep(0.5)
        second = number(line("irq-ticks ."))
        assert 2 <= first < second, (
            f"Hardware timer did not interrupt the Franc JIT: {first}, {second}"
        )
        if os.getenv("FRANC_TEST_PREEMPT") == "1":
            prior_tick = number(line("irq-ticks ."))
            success = number(line("preempt-asm-demo ."))
            assert success == 1, f"Timer-driven context switch failed: {success}"
            a = number(line("preempt-a ."))
            b = number(line("preempt-b ."))
            assert a > 100 and b > 100, (a, b)
            post_tick = number(line("irq-ticks ."))
            assert post_tick - prior_tick >= 120, (prior_tick, post_tick)
            print(f"PASS: independent, never-yielding assembly workers were preempted and resumed ({a}, {b} iterations)", flush=True)
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
