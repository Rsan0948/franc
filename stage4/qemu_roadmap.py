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
        text = expect(marker or b"Frac> ", pos, timeout)
        if b"stage2: unsupported token" in text:
            raise AssertionError(f"Compiler rejected {command}: {text[-1200:]!r}")
        return text

    try:
        expect(b"Franc> ", timeout=180)
        loaded = key(b"l", b"APPS READY", timeout=300)
        match = re.search(rb"APPS LOADED (\d+)", loaded)
        assert match and int(match.group(1)) >= 130, loaded[-1800:]
        key(b"r", b"Frac> ")
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
    finally:
        guest.kill()
        guest.wait()
