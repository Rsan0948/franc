#!/usr/bin/env python3
"""Actual guest Ethernet TX DMA gate with QEMU filter-dump PCAP verification."""
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
         "-device", "rtl8139,netdev=net0,mac=52:54:00:12:34:56",
         "-object", f"filter-dump,id=pcap0,netdev=net0,file={Path(tmp) / 'tx.pcap'}"],
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
        loaded = key(b"l", b"APPS READY", timeout=360)
        assert b"stage2: unsupported token" not in loaded, loaded[-1800:]
        key(b"r", b"Frac> ")
        line("pci-rtl8139-slot pci-id pci-rtl8139? .", b"1\nFrac> ")
        line("net-send-demo .", b"1\nFrac> ", timeout=150)
        print("PASS: Franc RTL8139 DMA transmit completed in guest", flush=True)
    finally:
        guest.kill()
        guest.wait()
    capture = (Path(tmp) / "tx.pcap").read_bytes()
    ethernet_header = bytes.fromhex("ffffffffffff52540012345688b5")
    assert ethernet_header in capture, (
        f"Missing expected Ethernet frame in QEMU PCAP ({len(capture)} bytes)"
    )
    assert b"FRANCOS-ETHER-TEST" in capture
    print("PASS: QEMU PCAP records Franc-emitted raw Ethernet frame", flush=True)
