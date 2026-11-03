#!/usr/bin/env python3
"""FrancOS Wave 2 complete keyboard IDE acceptance in a real BIOS QEMU guest.

Tests keyboard-only Home, lazy native apps, bounded file lifecycle, cold
reboot persistence and framebuffer evidence. Python orchestrates the host;
all guest UI/file/application logic runs in Franc + assembly. No green
marker is emitted without completing the entire guest journey.
"""
from pathlib import Path
import os
import selectors
import shutil
import socket
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parent
IMAGE = Path(sys.argv[1] if len(sys.argv)>1 else ROOT / "native_seed.img").resolve()
QEMU = shutil.which("qemu-system-x86_64")
assert QEMU and IMAGE.exists(), "QEMU and an assembled native image are required"
CAPTURE = Path(os.environ.get("FRANC_CAPTURE_DIR", ROOT / "screenshots"))
CAPTURE.mkdir(parents=True, exist_ok=True)


class Guest:
    def __init__(self, disk, work, name):
        self.out = bytearray()
        self.monitor_path = work / f"{name}.sock"
        self.process = subprocess.Popen([
            QEMU, "-m", "128M", "-accel", "tcg",
            "-display", "none", "-no-reboot",
            "-monitor", f"unix:{self.monitor_path},server=on,wait=off",
            "-serial", "stdio", "-drive", f"file={disk},format=raw,if=ide"
        ], stdin=subprocess.PIPE, stdout=subprocess.PIPE,
           stderr=subprocess.STDOUT, bufsize=0)
        self.selector = selectors.DefaultSelector()
        self.selector.register(self.process.stdout, selectors.EVENT_READ)
        self.monitor = None

    def expect(self, marker, start=0, timeout=150):
        if isinstance(marker, str):
            marker = marker.encode("ascii")
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            if marker in self.out[start:]:
                return bytes(self.out[start:])
            if self.process.poll() is not None:
                break
            if self.selector.select(0.15):
                chunk = os.read(self.process.stdout.fileno(), 65536)
                if not chunk:
                    break
                self.out.extend(chunk)
        raise AssertionError(
            f"Guest missing {marker!r}; output tail={bytes(self.out[-5000:])!r}"
        )

    def key(self, key, marker, timeout=150):
        start = len(self.out)
        time.sleep(0.35)
        os.write(self.process.stdin.fileno(),
                 key if isinstance(key, bytes) else key.encode("ascii"))
        return self.expect(marker, start, timeout)

    def line(self, value, marker, timeout=100):
        data = value.encode("ascii") + b"\n"
        start = len(self.out)
        for ch in data:
            pos = len(self.out)
            time.sleep(0.11)
            os.write(self.process.stdin.fileno(), bytes((ch,)))
            if ch != 10:
                self.expect(bytes((ch,)), pos, 15)
        return self.expect(marker, start, timeout)

    def hmp(self, command, timeout=20):
        if self.monitor is None:
            deadline = time.monotonic() + timeout
            while not self.monitor_path.exists() and time.monotonic() < deadline:
                time.sleep(0.1)
            self.monitor = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            self.monitor.settimeout(timeout)
            self.monitor.connect(str(self.monitor_path))
            self.monitor.recv(8192)
        self.monitor.sendall((command + "\n").encode("ascii"))
        result = b""
        deadline = time.monotonic() + timeout
        while b"(qemu)" not in result and time.monotonic() < deadline:
            result += self.monitor.recv(8192)
        assert b"(qemu)" in result, result
        assert b"Error" not in result and b"error" not in result, result
        return result

    def screenshot(self, name):
        # Allow the foreground Franc glyph raster to finish before taking
        # an HMP framebuffer snapshot (UART output precedes VGA drawing).
        time.sleep(0.7)
        target = CAPTURE / f"{name}.ppm"
        self.hmp(f"screendump {target}")
        deadline = time.monotonic() + 12
        while not target.exists() and time.monotonic() < deadline:
            time.sleep(0.1)
        content = target.read_bytes()
        import re
        header = re.match(rb"P6\s+(\d+)\s+(\d+)\s+255\s", content)
        assert header, (name, content[:100])
        width, height = map(int, header.groups())
        # QEMU screendump often doubles BIOS mode 13h to 640x400 while
        # guest pixel coordinates remain the real 320x200 framebuffer.
        assert (width, height) in ((320, 200), (640, 400)), (name, width, height)
        size = width * height * 3
        assert len(content) - header.end() == size, (name, len(content), size)
        pixels = content[-size:]
        stride = max(3, (size // 600) // 3 * 3)
        assert len({pixels[i:i+3] for i in range(0, len(pixels), stride)}) >= 2, (
            "Framebuffer was blank or uniform", name
        )
        if name == "home":
            # Inspect the actual first glyph, not just a nonblank screen:
            # a wrong Franc stack pop order formerly drew arbitrary glyphs
            # at ASCII-code Y coordinates despite a correct UART menu.
            import re
            font_lines = (ROOT / "font.S").read_text().splitlines()
            reference = next(
                line for line in font_lines if line.rstrip().endswith("/* 70 */")
            )
            shape = [int(h, 16) for h in re.findall(r"0x([0-9a-fA-F]{2})", reference)]
            assert len(shape) == 8, (reference, shape)
            scale = width // 320
            for y in range(8):
                for x in range(8):
                    pixel = ((y*scale)*width + (x*scale))*3
                    lit = any(pixels[pixel:pixel+3])
                    expected = bool(shape[y] & (1 << x))
                    assert lit == expected, (
                        "Home first glyph F mismatches actual Franc font",
                        x, y, lit, expected
                    )
            print("PASS: exact Home title glyph raster matches compiled 8x8 font", flush=True)
        print(f"PASS: captured nonblank mode-13h VGA {name} screenshot ({width}x{height})", flush=True)

    def close(self):
        if self.monitor:
            self.monitor.close()
        self.process.kill()
        self.process.wait()


with tempfile.TemporaryDirectory(prefix="franc-wave2-ide-") as temp:
    work = Path(temp)
    disk = work / "wave2.img"
    shutil.copyfile(IMAGE, disk)
    guest = Guest(disk, work, "edit-first")
    try:
        guest.expect(b"Franc> ", timeout=185)
        guest.key(b"9", b"ide> ", timeout=230)
        guest.key(b"n", b"new file> ")
        guest.line("wave2demo.frac", b"NEW BUFFER")
        guest.key(b"e", b"FrancOS IDE | ", timeout=90)
        guest.screenshot("wave2-new")

        # No REPL insertion: type actual source through the IDE keyboard.
        source = b"def helper 7 8 + ;\ndef main helper 2 + . ;"
        typed = bytearray()
        for c in source:
            offset = len(guest.out)
            time.sleep(0.11)
            os.write(guest.process.stdin.fileno(), bytes((c,)))
            typed.append(c)
            # The cursor marker follows the WHOLE edited source, not the
            # earlier Home/status vertical bars. Block on the complete
            # frame before sending the next COM1 byte.
            guest.expect(bytes(typed) + b"|", offset, timeout=40)
        guest.expect(b"def main helper 2 + . ;", len(guest.out)-1400, timeout=30)
        guest.screenshot("wave2-multiline")

        # Move the real PS/2 cursor left six times, backspace over '2'
        # and insert '1'. The source after editing must yield 16.
        last_line = b"def main helper 2 + . ;"
        for position in range(1, 7):
            offset = len(guest.out)
            guest.hmp("sendkey left")
            cursor = len(last_line) - position
            guest.expect(last_line[:cursor] + b"|" + last_line[cursor:],
                         offset, timeout=45)
        offset = len(guest.out)
        os.write(guest.process.stdin.fileno(), b"\x08")
        guest.expect(b"def main helper  + . ;", offset, timeout=45)
        offset = len(guest.out)
        os.write(guest.process.stdin.fileno(), b"1")
        guest.expect(b"def main helper 1 + . ;", offset, timeout=45)
        guest.screenshot("wave2-cursor-edit")

        guest.key(b"\t", b"SAVED |", timeout=80)
        guest.screenshot("wave2-saved")
        guest.key(b"\x1b", b"ide> ", timeout=80)
        guest.key(b"q", b"Franc> ", timeout=90)
        print("PASS: keyboard-only two-line edit, PS/2 mid-buffer repair and save", flush=True)
    finally:
        guest.close()

    guest = Guest(disk, work, "edit-reboot")
    try:
        guest.expect(b"Franc> ", timeout=185)
        guest.key(b"9", b"ide> ", timeout=230)
        guest.key(b"o", b"open file> ")
        guest.line("wave2demo.frac", b"OPENED")
        guest.key(b"e", b"FrancOS IDE | ", timeout=90)
        guest.expect(b"def main helper 1 + . ;", len(guest.out)-2000, timeout=40)
        guest.screenshot("wave2-reopened")
        guest.key(b"\x1b", b"ide> ")
        start = len(guest.out)
        run = guest.key(b"r", b"RUN COMPLETE", timeout=100)
        assert b"COMPILE OK | lines " in run
        assert b"16\n" in run, run[-1600:]
        assert b"RUNNING main (trusted source)" in run
        guest.key(b"q", b"Franc> ", timeout=90)
        print("PASS: IDE source cold-reboot persistence, real compiled main and output 16", flush=True)
    finally:
        guest.close()
print("PASS: FrancOS Wave 2 full editor/save/reboot/build/run integration", flush=True)
