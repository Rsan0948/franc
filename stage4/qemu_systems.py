#!/usr/bin/env python3
"""Hardware and OS service gate in a C-free FrancOS guest with QEMU RTL8139."""
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
         "-drive", f"file={disk},format=raw,if=ide",
         "-netdev", "user,id=net0",
         "-device", "rtl8139,netdev=net0,mac=52:54:00:12:34:56"],
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
        loaded = key(b"l", b"APPS READY", timeout=330)
        match = re.search(rb"APPS LOADED (\d+)", loaded)
        assert match and int(match.group(1)) >= 180, loaded[-1800:]
        assert b"stage2: unsupported token" not in loaded, loaded[-1800:]
        key(b"r", b"Frac> ")
        line("task-demo", b"3\n2\nFrac> ")
        line("task-reset 'task-a task-add .", b"1\nFrac> ")
        line("8 task-run task-a-n .", b"8\nFrac> ")
        print("PASS: Franc cooperative step scheduler in QEMU", flush=True)
        line("pci-rtl8139-slot pci-id pci-rtl8139? .", b"1\nFrac> ")
        line("pci-rtl8139-slot 0 pci-rtl8139-mac-byte .", b"82\nFrac> ")
        print("PASS: Franc PCI mechanism #1 discovers QEMU RTL8139 and MAC", flush=True)
        line('"t.frac" ide-open .', b"0\nFrac> ")
        line('"def alpha 17 ;" ide-settext .', b"1\nFrac> ")
        line('ide-lineend 10 ide-insert drop "def beta 25 ;" ide-paste', b"Frac> ")
        line("ide-save .", b"1\nFrac> ")
        line("ide-init ide-load .", b"1\nFrac> ")
        line("ide-buffer type cr", b"def alpha 17 ;\ndef beta 25 ;\nFrac> ")
        line("ide-compile .", b"2\nFrac> ")
        line("alpha beta + .", b"42\nFrac> ")
        line('"abcd" ide-settext drop ide-lineend ide-left drop 88 ide-insert drop ide-buffer type cr',
             b"abcXd\nFrac> ")
        line("ide-backspace drop ide-buffer type cr", b"abcd\nFrac> ")
        print("PASS: multiline Franc IDE editing, persistence and JIT compile", flush=True)
        key(b"\x1b", b"Franc> ")
        key(b"i", b"IDE READY", timeout=120)
        key(b"\x13", b"IDE SAVED", timeout=120)
        key(b"\x1b", b"Franc> ", timeout=120)
        print("PASS: native VGA IDE menu entry, Ctrl-S save and Escape exit", flush=True)
    finally:
        guest.kill()
        guest.wait()
