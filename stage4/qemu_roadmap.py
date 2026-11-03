#!/usr/bin/env python3
"""Roadmap feature gate. Tests real Franc JIT execution inside C-free QEMU guest."""
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
assert qemu and image.exists(), "QEMU and assembled native image required"

with tempfile.TemporaryDirectory(prefix="franc-roadmap-") as tmp:
    disk = Path(tmp) / "roadmap.img"
    shutil.copyfile(image, disk)
    guest = subprocess.Popen(
        [qemu, "-m", "128M", "-accel", "tcg", "-display", "none",
         "-monitor", "none", "-no-reboot", "-serial", "stdio",
         "-device", "e1000,netdev=n0", "-netdev", "user,id=n0",
         "-drive", f"file={disk},format=raw,if=ide"],
        stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, bufsize=0,
    )
    out = bytearray()
    selector = selectors.DefaultSelector()
    selector.register(guest.stdout, selectors.EVENT_READ)

    def expect(marker: bytes, start=0, timeout=150):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            found = out.find(marker, start)
            if found >= 0:
                return bytes(out[start:])
            if guest.poll() is not None:
                break
            if selector.select(0.2):
                packet = os.read(guest.stdout.fileno(), 65536)
                if not packet:
                    break
                out.extend(packet)
        raise AssertionError(f"Missing {marker!r}; tail={bytes(out[-1800:])!r}")

    def key(c, marker, timeout=180):
        pos = len(out)
        time.sleep(0.3)
        os.write(guest.stdin.fileno(), c)
        return expect(marker, pos, timeout)

    def line(command, marker=None, timeout=120, allow_compiler_error=False):
        pos = len(out)
        for c in command.encode("ascii"):
            before = len(out)
            os.write(guest.stdin.fileno(), bytes([c]))
            expect(bytes([c]), before, 12)
            time.sleep(0.11)
        os.write(guest.stdin.fileno(), b"\n")
        text = expect(b"Frac> ", pos, timeout)
        if b"stage2: unsupported token" in text and not allow_compiler_error:
            raise AssertionError(f"Compiler rejected {command}: {text[-1200:]!r}")
        if marker is not None and marker not in text:
            raise AssertionError(f"Unexpected result for {command}: {text[-1200:]!r}")
        return text

    try:
        expect(b"Franc> ", timeout=180)
        loaded = key(b"l", b"APPS READY", timeout=300)
        match = re.search(rb"APPS LOADED (\d+)", loaded)
        assert match and int(match.group(1)) >= 130, loaded[-1800:]
        key(b"r", b"Frac> ")
        line("heap-free .", b"4194304\nFrac> ")
        line("16 alloc dup 77 b! b@ .", b"77\nFrac> ")
        line("heap-free .", b"4194288\nFrac> ")
        line("0 alloc .", b"0\nFrac> ")
        line("4194305 alloc .", b"0\nFrac> ")
        line("7 3 shl .", b"56\nFrac> ")
        line("-8 2 shr .", b"-2\nFrac> ")
        line("7 3 << .", b"56\nFrac> ")
        line("56 3 >> .", b"7\nFrac> ")
        line("1 62 shl .", b"4611686018427387904\nFrac> ")
        print("PASS: native bounded heap and signed bit shifts", flush=True)
        line("page-free-count .", b"2048\nFrac> ")
        line("page-alloc dup 67 b! dup b@ . page-free .", b"67\n1\nFrac> ")
        line("page-free-count .", b"2048\nFrac> ")
        line("0 page-free .", b"0\nFrac> ")
        line("page-alloc dup b@ . page-free .", b"0\n1\nFrac> ")
        line("page-alloc :fib-a fib-a page-free . fib-a page-free .", b"1\n0\nFrac> ")
        line("page-free-count .", b"2048\nFrac> ")
        print("PASS: physical page bitmap rejects double-free and preserves accounting", flush=True)
        print("PASS: zeroed 4KiB physical pages, free-list bitmap and invalid-free rejection", flush=True)
        # Wave 1 F1: real tagged frames, rejection of stale/foreign tokens and
        # freeing an owner with live pages. This is a trusted-kernel ABI only.
        line("0 proc-lease-begin .", b"0\nFrac> ")
        line("1 proc-lease-begin .", b"1\nFrac> ")
        line("1 proc-lease-begin .", b"0\nFrac> ")
        line("2 proc-lease-begin .", b"1\nFrac> ")
        line("1 1 proc-lease-alloc :fib-a fib-a b@ .", b"0\nFrac> ")
        line("page-free-count .", b"2047\nFrac> ")
        line("fib-a page-free .", b"0\nFrac> ")
        line("2 1 fib-a proc-lease-free .", b"0\nFrac> ")
        line("1 0 fib-a proc-lease-free .", b"0\nFrac> ")
        line("1 1 fib-a proc-lease-free .", b"1\nFrac> ")
        line("page-free-count .", b"2048\nFrac> ")
        line("1 1 proc-lease-alloc :fib-a fib-a b@ .", b"0\nFrac> ")
        line("1 1 proc-lease-end .", b"1\nFrac> ")
        line("1 1 proc-lease-alloc .", b"0\nFrac> ")
        line("1 proc-lease-begin .", b"2\nFrac> ")
        line("1 1 proc-lease-end .", b"0\nFrac> ")
        line("1 2 proc-lease-end .", b"0\nFrac> ")
        line("2 1 proc-lease-end .", b"0\nFrac> ")
        line("page-free-count .", b"2048\nFrac> ")
        print("PASS: owner leases reject stale/foreign frees and reclaim scrubbed frames", flush=True)
        line("0 :fib-a 0 :fib-b", b"Frac> ")
        line("'fib-carry-a fiber-spawn .", b"1\nFrac> ")
        line("'fib-carry-b fiber-spawn .", b"1\nFrac> ")
        line("4 fib-run . fib-a . fib-b . fiber-active .",
             b"4\n101\n202\n0\nFrac> ")
        line("def fib-many 1 fiber-yield 2 + fiber-yield 3 + :fib-a ;")
        line("0 :fib-a 'fib-many fiber-spawn .", b"1\nFrac> ")
        line("fiber-step . fiber-active .", b"1\n1\nFrac> ")
        line("fiber-step . fiber-active .", b"1\n1\nFrac> ")
        line("fiber-step . fiber-active . fib-a .", b"1\n0\n6\nFrac> ")
        print("PASS: multi-yield fiber maintains its independent Franc data stack", flush=True)
        print("PASS: two resumable Franc fibers preserve independent CPU/data stacks", flush=True)

        line("bn-init 1 bn-from 2 bn-from bn-add bn-print cr", b"3\nFrac> ")
        line("bn-init 1000 bn-from 1 bn-from bn-sub bn-print cr", b"999\nFrac> ")
        line("bn-init 2 bn-from 80 bn-pow bn-print cr", b"1208925819614629174706176\nFrac> ")
        line("bn-init 1000000000000000000 bn-from 1000000000000000000 bn-from bn-mul bn-print cr",
             b"1000000000000000000000000000000000000\nFrac> ")
        line("$6600006 248 b! $6600007 63 b! $6600000 f64-class .", b"1\nFrac> ")
        line("$6600000 f64-to-rat .", b"3/2\nFrac> ")
        line('"2 + 3 * (4 + 5)" lite-compile type cr', b"2 3 4 5 + * + \nFrac> ")
        line('"2 + 3 * (4 + 5)" lite-run .', b"29\nFrac> ")
        line('"8/(2+2)" lite-run .', b"2\nFrac> ")
        line('"x.frac" "def xnum 37 ;" pkg-install .', b"1\nFrac> ")
        line('"x.frac" pkg-load .', b"1\nFrac> ")
        line("xnum .", b"37\nFrac> ")
        print("PASS: QEMU native bignum, f64 decode, FrancLite and offline packages", flush=True)
        line('ide-start "def nine 9 ;" ide-add-line .', b"1\nFrac> ")
        line('"def forty 40 ;" ide-add-line .', b"1\nFrac> ")
        line("ide-save .", b"1\nFrac> ")
        line('ide-reset "project.frac" ide-load .', b"1\nFrac> ")
        line("ide-compile .", b"2\nFrac> ")
        line("nine forty + .", b"49\nFrac> ")
        line('ide-reset "abc" ide-append .', b"1\nFrac> ")
        line("1 1 ide-delete .", b"1\nFrac> ")
        line("ide-buffer type cr", b"ac\nFrac> ")
        line('1 "b" ide-insert .', b"1\nFrac> ")
        line("ide-buffer type cr", b"abc\nFrac> ")

        print("PASS: native multiline IDE source, persistence and JIT compile", flush=True)
        line('ide-start "def main 18 . ;" ide-add-line .', b"1\nFrac> ")
        positive = line("ide-run", b"18\nRUN COMPLETE\nFrac> ")\n        assert b"COMPILE OK | lines " in positive, positive
        line('ide-start "def main 7 bad-token . ;" ide-add-line .', b"1\nFrac> ")
        failed = line("ide-run", b"COMPILE FAILED | line 1\n", allow_compiler_error=True)
        assert b"RUN COMPLETE" not in failed, failed
        line('ide-start "def helper 9 ;" ide-add-line .', b"1\nFrac> ")
        no_main = line("ide-run", b"NO def main ENTRYPOINT\nFrac> ")
        assert b"COMPILE OK" in no_main and b"RUN COMPLETE" not in no_main, no_main
        print("PASS: Wave 2 IDE reports failing source line and refuses stale main", flush=True)
        line('ide-start "abc" ide-append .', b"1\nFrac> ")
        line("1 :ide-cursor ide-line-home ide-cursor .", b"0\nFrac> ")
        line("ide-line-last ide-cursor .", b"3\nFrac> ")
        line("1 :ide-cursor ide-delete-next ide-buffer type cr", b"ac\nFrac> ")
        line("ide-reset 2047 :ide-length 2047 :ide-cursor 88 ide-type-char ide-buffer 2051 + b@ .",
             b"1\nFrac> ")
        line("ide-reset ide-buffer 2051 + b@ .", b"0\nFrac> ")
        print("PASS: Wave 2 IDE fresh-main execution, cursor home/end, delete-forward and explicit full-buffer status", flush=True)
        line('ide-start "abcdef" ide-append .', b"1\nFrac> ")
        line("3 :ide-cursor ide-left ide-cursor .", b"2\nFrac> ")
        line("ide-right ide-cursor .", b"3\nFrac> ")
        line("88 ide-type-char ide-buffer type cr", b"abcXdef\nFrac> ")
        line("ide-backspace ide-buffer type cr", b"abcdef\nFrac> ")
        line('"wave1.frac" ide-set-name .', b"1\nFrac> ")
        line("ide-save .", b"1\nFrac> ")
        line("ide-buffer 2050 + b@ .", b"0\nFrac> ")
        line('ide-reset "wave1.frac" ide-load .', b"1\nFrac> ")
        line("ide-buffer type cr", b"abcdef\nFrac> ")
        line("ide-files", b"wave1.frac\nFrac> ")
        print("PASS: IDE cursor insertion/backspace, on-screen file list and persisted reload", flush=True)
        line('pci-find-network 0 - if "PCI MISSING" type cr else "PCI NETWORK PRESENT" type cr then',
             b"PCI NETWORK PRESENT\nFrac> ")
        line('pci-find-e1000 0 - if "E1000 MISSING" type cr else "E1000 PRESENT" type cr then',
             b"E1000 PRESENT\nFrac> ")
        print("PASS: real QEMU PCI e1000 enumerated with Franc port I/O", flush=True)
        line("task-reset 'task-counter-a task-spawn . 'task-counter-b task-spawn .", b"1\n2\nFrac> ")
        line("8 task-run-for . task-a . task-b .", b"8\n4\n4\nFrac> ")
        print("PASS: Franc cooperative callback scheduler interleaves two tasks", flush=True)
        key(b"\x1b", b"Franc> ")
        key(b"9", b"ide> ")
        key(b"q", b"Franc> ")
        print("PASS: native IDE launched through new menu key 9", flush=True)

    finally:
        guest.kill()
        guest.wait()
