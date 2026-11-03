#!/usr/bin/env python3
"""FrancOS Wave 1 UX acceptance in a real BIOS QEMU guest.

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


with tempfile.TemporaryDirectory(prefix="franc-wave1-") as temp:
    work = Path(temp)
    disk = work / "wave1.img"
    shutil.copyfile(IMAGE, disk)
    g = Guest(disk, work, "first")
    try:
        g.expect(b"FrancOS HOME | single user", timeout=180)
        g.expect(b"Franc> ", timeout=30)
        g.screenshot("home")

        # HMP sendkey creates real PS/2 arrow events, not serial escape
        # sequences that the single-byte COM1 adapter might misdecode.
        start = len(g.out)
        g.hmp("sendkey down")
        g.expect(b"> 2  Notes", start, 35)
        # UART emits before VGA glyph rasterization; finish full redraw.
        g.expect(b"Franc> ", start, 65)
        g.screenshot("home-selection")
        print("PASS: PS/2 Down changes native Home focus", flush=True)

        # Direct number selection must lazily load the original apps without
        # forcing the user to memorize a REPL word or separate load command.
        g.key(b"1", b"FracCalc | Enter:", timeout=260)
        g.line("1/3 1/6 +", b"ans: 1/2", timeout=110)
        g.key(b"\x1b", b"Franc> ", timeout=110)
        print("PASS: fresh guest launched and returned from FracCalc", flush=True)

        g.key(b"z", b"files> ")
        g.screenshot("files")
        g.key(b"n", b"New filename> ")
        g.line("homefile.frac", b"Source line> ")
        g.line("def homesum 7 8 + ;", b"CREATED", timeout=110)
        g.expect(b"homefile.frac", len(g.out)-2000, 40)
        g.key(b"r", b"Rename old> ")
        g.line("homefile.frac", b"Rename new> ")
        g.line("renamed.frac", b"RENAMED", timeout=110)
        g.key(b"o", b"Open name> ")
        g.line("renamed.frac", b"def homesum 7 8 + ;", timeout=110)
        g.key(b"\x1b", b"Franc> ")
        print("PASS: keyboard file create, rename and open from Home", flush=True)

        package_view = g.key(b"m", b"pkg> ", timeout=160)
        if os.getenv("FRANC_TEST_WAVE4") == "1":
            assert b"FrancOS | Packages | verified" in package_view, package_view[-1600:]
            assert b"i Install/update | b Rollback" in package_view
            print("PASS: shared FrancOS VGA/serial package typography and keyboard shortcuts", flush=True)
        g.screenshot("packages")
        g.key(b"\x1b", b"Franc> ")
        g.key(b"9", b"ide> ", timeout=130)
        g.key(b"e", b"FrancOS IDE", timeout=60)
        g.screenshot("ide")
        g.key(b"\x1b", b"ide> ", timeout=60)
        g.key(b"q", b"Franc> ", timeout=60)
        print("PASS: accessible native Packages and IDE with normal return paths", flush=True)
    finally:
        g.close()

    # Reboot the same persisted disk, not a fresh copy of the seed image.
    g = Guest(disk, work, "second")
    try:
        g.expect(b"Franc> ", timeout=180)
        g.key(b"z", b"files> ")
        start = len(g.out) - 2000
        assert b"renamed.frac" in g.out[start:], bytes(g.out[start:])
        g.key(b"o", b"Open name> ")
        g.line("renamed.frac", b"def homesum 7 8 + ;")
        g.key(b"d", b"Delete name> ")
        g.line("renamed.frac", b"DELETED")
        g.key(b"\x1b", b"Franc> ")
        print("PASS: file survived a cold reboot and was then removed", flush=True)
    finally:
        g.close()

    # Verify directory deletion persists across a second cold reboot.
    g = Guest(disk, work, "third")
    try:
        g.expect(b"Franc> ", timeout=180)
        g.key(b"z", b"files> ")
        start = len(g.out)
        g.key(b"o", b"Open name> ")
        g.line("renamed.frac", b"FILE NOT FOUND")
        g.key(b"\x1b", b"Franc> ")
        print("PASS: deleted source does not reappear after cold reboot", flush=True)
    finally:
        g.close()

print("PASS: FrancOS Wave 1 contiguous Home/files/apps QEMU acceptance", flush=True)
