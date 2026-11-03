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

    def line(command, marker=None, timeout=120):
        pos = len(out)
        for c in command.encode("ascii"):
            before = len(out)
            os.write(guest.stdin.fileno(), bytes([c]))
            expect(bytes([c]), before, 12)
            time.sleep(0.11)
        os.write(guest.stdin.fileno(), b"\n")
        text = expect(b"Frac> ", pos, timeout)
        if b"stage2: unsupported token" in text:
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
        print("PASS: native bounded heap and signed bit shifts", flush=True)
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
