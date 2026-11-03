#!/usr/bin/env python3
"""QEMU/SLIRP proof for native Franc e1000 DMA descriptors and Ethernet I/O.

Host observes the actual Ethernet frame through QEMU's filter-dump; a
positive Franc TX return alone is insufficient evidence of transmission.
"""
from pathlib import Path
import os
import selectors
import shutil
import struct
import subprocess
import sys
import tempfile
import time

root = Path(__file__).resolve().parent
image = Path(sys.argv[1] if len(sys.argv) > 1 else root / "native_seed.img")
qemu = shutil.which("qemu-system-x86_64")
assert qemu and image.exists(), "QEMU and native seed image required"

with tempfile.TemporaryDirectory(prefix="franc-net-") as tmp:
    tmp = Path(tmp)
    disk = tmp / "net.img"
    cap = tmp / "net.pcap"
    shutil.copyfile(image, disk)
    guest = subprocess.Popen([
        qemu, "-m", "128M", "-accel", "tcg", "-display", "none",
        "-monitor", "none", "-no-reboot", "-serial", "stdio",
        "-device", "e1000,netdev=n0",
        "-netdev", "user,id=n0",
        "-object", f"filter-dump,id=dump0,netdev=n0,file={cap}",
        "-drive", f"file={disk},format=raw,if=ide",
    ], stdin=subprocess.PIPE, stdout=subprocess.PIPE,
       stderr=subprocess.STDOUT, bufsize=0)
    selector = selectors.DefaultSelector()
    selector.register(guest.stdout, selectors.EVENT_READ)
    out = bytearray()

    def until(marker, start=0, timeout=180):
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
            f"Missing {marker!r}; QEMU status={guest.poll()}, log={bytes(out[-1800:])!r}")

    def key(value, marker, timeout=200):
        start = len(out)
        time.sleep(0.2)
        os.write(guest.stdin.fileno(), value)
        return until(marker, start, timeout)

    def line(command, marker=None, timeout=100):
        start = len(out)
        for char in command.encode("ascii"):
            pos = len(out)
            os.write(guest.stdin.fileno(), bytes([char]))
            until(bytes([char]), pos, 15)
            time.sleep(0.10)
        os.write(guest.stdin.fileno(), b"\n")
        text = until(b"Frac> ", start, timeout)
        if b"stage2: unsupported token" in text:
            raise AssertionError(f"Native compiler rejected {command}: {text!r}")
        if marker is not None and marker not in text:
            raise AssertionError(f"Bad result for {command}: {text!r}")
        return text

    try:
        until(b"Franc> ", timeout=180)
        key(b"l", b"APPS READY", timeout=310)
        key(b"r", b"Frac> ")
        line("net-init .", b"1\nFrac> ")
        print("PASS: e1000 IO BAR and DMA descriptor initialization", flush=True)
        line("net-active .", b"1\nFrac> ")
        transmission = line("net-arp-request .")
        # Gather register and DMA evidence even when the TX command fails.
        # This separates descriptor problems from PCI BAR and link issues.
        diagnostics = {}
        for register in (
            "net-mmio .",
            "$400 net-reg@ .",
            "$3800 net-reg@ .",
            "$3808 net-reg@ .",
            "$3810 net-reg@ .",
            "$3818 net-reg@ .",
            "net-txdesc 8 + b@ .",
            "net-txdesc 11 + b@ .",
            "net-txdesc 12 + b@ .",
            "net-sent .",
        ):
            diagnostics[register] = line(register).decode("ascii", errors="replace").strip()
        print("e1000 TX result:", transmission, flush=True)
        print("e1000 native registers:", diagnostics, flush=True)
        if b"1\nFrac> " not in transmission:
            raise AssertionError("e1000 failed to complete TX; see register snapshot above")

        time.sleep(1.5)
        line("net-rx-ready? .", b"1\nFrac> ")
        line("net-rx-ethertype .", b"2054\nFrac> ")
        line("net-rx-size .")
        line("net-arp-learn .", b"1\nFrac> ")
        line("net-gw-ready .", b"1\nFrac> ")
        line("net-rx-consume .", b"1\nFrac> ")
        line("net-rx-ready? .", b"0\nFrac> ")
        line("net-arp-request .", b"1\nFrac> ")
        time.sleep(1.5)
        line("net-rx-ready? .", b"1\nFrac> ")
        line("net-arp-learn .", b"1\nFrac> ")
        line("net-rx-consume .", b"1\nFrac> ")
        line("net-sent .", b"2\nFrac> ")
        line("net-received .", b"2\nFrac> ")
        line("net-txnext .", b"2\nFrac> ")
        line("net-rxnext .", b"2\nFrac> ")
        print("PASS: two TX ring slots and two released/rearmed RX descriptors", flush=True)
        line("ip-ping .", b"1\nFrac> ")
        time.sleep(1.5)
        line("ip-rx-valid? .", b"1\nFrac> ")
        line("ip-icmp-reply? .", b"1\nFrac> ")
        line("net-rx-consume .", b"1\nFrac> ")
        line("net-sent .", b"3\nFrac> ")
        line("net-received .", b"3\nFrac> ")
        print("PASS: native IPv4 checksum and ICMP echo request/reply", flush=True)


        print("PASS: native e1000 completed DMA TX and received an ARP reply", flush=True)
    finally:
        guest.kill()
        guest.wait()

    raw = cap.read_bytes() if cap.is_file() else b""
    assert len(raw) >= 24, f"QEMU Ethernet capture not produced: {raw!r}"
    magic = raw[:4]
    if magic == b"\xd4\xc3\xb2\xa1":
        endian = "<"
    elif magic == b"\xa1\xb2\xc3\xd4":
        endian = ">"
    else:
        raise AssertionError(f"Unrecognized pcap magic: {magic!r}")
    offset = 24
    packets = []
    while offset + 16 <= len(raw):
        sec, usec, captured, actual = struct.unpack_from(endian + "IIII", raw, offset)
        offset += 16
        assert captured <= 65535 and offset + captured <= len(raw)
        packets.append(raw[offset:offset + captured])
        offset += captured
    arps = [
        packet for packet in packets
        if len(packet) >= 42
        and packet[:6] == b"\xff" * 6
        and packet[12:14] == b"\x08\x06"
        and packet[20:22] == b"\x00\x01"
        and packet[28:32] == b"\x0a\x00\x02\x0f"
        and packet[38:42] == b"\x0a\x00\x02\x02"
    ]
    assert len(arps) >= 2, "QEMU capture must contain two distinct TX ring ARP transmissions"
    print(f"PASS: QEMU PCAP captured {len(arps)} actual guest e1000 ARP request(s)", flush=True)
    icmp = [
        packet for packet in packets
        if len(packet) >= 50
        and packet[12:14] == b"\x08\x00"
        and packet[14] == 69
        and packet[23] == 1
        and packet[26:30] == b"\x0a\x00\x02\x0f"
        and packet[30:34] == b"\x0a\x00\x02\x02"
        and packet[34:36] == b"\x08\x00"
        and packet[38:42] == b"\x12\x34\x00\x01"
        and packet[42:50] == b"FRANCOS!"
    ]
    assert icmp, "QEMU capture contains no Franc-origin valid ICMP echo request"
    print("PASS: host packet capture proves a real IPv4 ICMP echo request", flush=True)

