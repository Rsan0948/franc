#!/usr/bin/env python3
"""FrancOS v1 single-disk, real-QEMU end-to-end release journey.

All operations after boot are native FrancOS keyboard/UI or restricted REPL
diagnostics. A trusted host changes only the two predeclared upload slots
*while the VM is powered off* to simulate the local offline package shelf.
The same BIOS disk preserves IDE files, package banks and system identity
through all reboots. QEMU HMP captures real VGA output, not render mocks.
"""
from pathlib import Path
import os
import re
import selectors
import shutil
import socket
import subprocess
import sys
import tempfile
import time

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO))
from franctxt.packages import manifest_for, plan_install

SEED = Path(sys.argv[1] if len(sys.argv) > 1 else REPO / "stage4/native_seed.img").resolve()
QEMU = shutil.which("qemu-system-x86_64")
assert QEMU and SEED.exists(), "QEMU x86-64 and verified FrancOS seed required"
CAPTURE = Path(os.environ.get("FRANC_CAPTURE_DIR", REPO / "stage4/v1-screens")).resolve()
CAPTURE.mkdir(parents=True, exist_ok=True)
FS_DIRECTORY = 129 * 512
UPLOAD = ((10, "upload.franctxt"), (11, "upload.frac"))


def stage_offline(disk, package, source):
    """Trusted offline input, only while the guest is off; no kernel bypass."""
    raw = bytearray(disk.read_bytes())
    assert raw[128 * 512:128 * 512 + 8] == b"FRANCFS1"
    for (slot, name), data in zip(UPLOAD, (package.manifest, source)):
        assert 0 < len(data) <= 2047 and len(name) <= 23
        entry = FS_DIRECTORY + slot * 32
        old = raw[entry:entry + 24].split(b"\0", 1)[0]
        assert not old or old == name.encode("ascii"), (slot, old)
        raw[entry:entry + 32] = (name.encode("ascii").ljust(24, b"\0")
                                  + len(data).to_bytes(2, "little") + b"\0" * 6)
        sector = (136 + slot * 4) * 512
        raw[sector:sector + 2048] = data.ljust(2048, b"\0")
    disk.write_bytes(raw)


class Guest:
    def __init__(self, disk, tmp, name):
        self.disk = disk
        self.out = bytearray()
        self.monitor_path = tmp / (name + ".sock")
        self.capture_path = tmp / (name + ".pcap")
        self.process = subprocess.Popen(
            [QEMU, "-m", "128M", "-accel", "tcg", "-display", "none",
             "-no-reboot", "-monitor",
             f"unix:{self.monitor_path},server=on,wait=off",
             "-serial", "stdio", "-device", "e1000,netdev=n0",
             "-netdev", "user,id=n0", "-object",
             f"filter-dump,id=dump0,netdev=n0,file={self.capture_path}",
             "-drive", f"file={disk},format=raw,if=ide"],
            stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, bufsize=0
        )
        self.selector = selectors.DefaultSelector()
        self.selector.register(self.process.stdout, selectors.EVENT_READ)
        self.monitor = None

    def expect(self, marker, start=0, timeout=180):
        if isinstance(marker, str):
            marker = marker.encode("ascii")
        until = time.monotonic() + timeout
        while time.monotonic() < until:
            if marker in self.out[start:]:
                return bytes(self.out[start:])
            if self.process.poll() is not None:
                break
            if self.selector.select(.15):
                chunk = os.read(self.process.stdout.fileno(), 65536)
                if not chunk:
                    break
                self.out.extend(chunk)
        raise AssertionError(
            f"Guest missing {marker!r} ({self.process.poll()}), "
            f"tail={bytes(self.out[-2000:])!r}")

    def key(self, key, marker, timeout=180):
        start = len(self.out)
        time.sleep(.35)
        os.write(self.process.stdin.fileno(), key if isinstance(key, bytes)
                 else key.encode("ascii"))
        return self.expect(marker, start, timeout)

    def line(self, value, marker, timeout=180):
        start = len(self.out)
        for ch in value.encode("ascii"):
            at = len(self.out)
            os.write(self.process.stdin.fileno(), bytes((ch,)))
            self.expect(bytes((ch,)), at, 18)
            time.sleep(.11)
        os.write(self.process.stdin.fileno(), b"\n")
        data = self.expect(marker, start, timeout)
        assert b"stage2: unsupported token" not in data, (
            value, data[-1700:])
        return data

    def value(self, source):
        data = self.line(source, b"Frac> ")
        matches = re.findall(rb"\n(-?[0-9]+)\r?\nFrac> ", data)
        assert matches, (source, data[-1600:])
        return int(matches[-1])

    def hmp(self, command):
        if self.monitor is None:
            limit = time.monotonic() + 25
            while not self.monitor_path.exists() and time.monotonic() < limit:
                time.sleep(.1)
            self.monitor = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            self.monitor.settimeout(25)
            self.monitor.connect(str(self.monitor_path))
            self.monitor.recv(8192)
        self.monitor.sendall((command + "\n").encode("ascii"))
        data = b""
        until = time.monotonic() + 25
        while b"(qemu)" not in data and time.monotonic() < until:
            data += self.monitor.recv(8192)
        assert b"(qemu)" in data and b"Error" not in data, data
        return data

    def screenshot(self, tag):
        time.sleep(.8)
        output = CAPTURE / (tag + ".ppm")
        self.hmp("screendump " + str(output))
        limit = time.monotonic() + 20
        while not output.exists() and time.monotonic() < limit:
            time.sleep(.1)
        raw = output.read_bytes()
        header = re.match(rb"P6\s+(\d+)\s+(\d+)\s+255\s", raw)
        assert header, raw[:100]
        width, height = (int(x) for x in header.groups())
        assert (width, height) in ((320, 200), (640, 400))
        pixels = raw[header.end():]
        assert len(pixels) == width * height * 3
        step = max(3, len(pixels) // 3500 // 3 * 3)
        assert len({pixels[i:i+3] for i in range(0, len(pixels), step)}) > 1, (
            "Blank VGA screenshot", tag)
        print(f"PASS: actual VGA frame {tag} ({width}x{height})", flush=True)

    def ready(self):
        self.expect(b"FrancOS HOME | single user", timeout=200)
        self.expect(b"Franc> ", timeout=90)

    def apps(self):
        result = self.key(b"l", b"APPS READY", timeout=340)
        assert b"stage2: unsupported token" not in result, result[-1500:]
        self.expect(b"Franc> ", len(self.out) - 800, timeout=80)

    def packages(self):
        result = self.key(b"m", b"pkg> ", timeout=210)
        assert b"FrancOS PACKAGES | verified" in result, result[-1500:]
        assert b"i Install/update" in result and b"n Network status" in result
        return result

    def install(self, pkg_id):
        self.key(b"i", b"Manifest staging filename> ")
        self.line("upload.franctxt", b"Source staging filename> ")
        self.line("upload.frac", b"Package id (app/base)> ")
        result = self.line(pkg_id, b"pkg> ", timeout=230)
        assert b"Installed, SHA256 verified" in result, result[-1500:]

    def pkg_action(self, action, package_id, prompt, success):
        self.key(action, prompt)
        result = self.line(package_id, b"pkg> ", timeout=210)
        assert success in result, result[-1500:]

    def show_packages(self):
        result = self.key(b"l", b"pkg> ", timeout=170)
        assert b"version" in result or b"not installed" in result, result
        return result

    def enter_repl(self):
        self.key(b"r", b"Frac> ", timeout=120)

    def leave_repl(self):
        self.key(b"\x1b", b"Franc> ", timeout=120)

    def close(self):
        if self.monitor:
            self.monitor.close()
        self.process.kill()
        self.process.wait()


base_source = b"def main 2 count again ;"
app_source = b"def main 100 count fault ;"
app_update_source = b"def main 200 count fault ;"
base = manifest_for("base", "1.0.0", {"pkg-base0.frac": base_source},
                    generation=1, entry="pkg-base0.frac")
app = manifest_for("app", "1.0.0", {"pkg-app0.frac": app_source},
                   dependencies=(("base", "1.0.0"),), generation=1,
                   entry="pkg-app0.frac")
update = manifest_for("app", "1.1.0",
                      {"pkg-app1.frac": app_update_source},
                      dependencies=(("base", "1.0.0"),), generation=2,
                      entry="pkg-app1.frac")
ordered = plan_install({base.key: (base, {"pkg-base0.frac": base_source}),
                        app.key: (app, {"pkg-app0.frac": app_source})},
                       {}, app.key).ordered
assert ordered == (base.key, app.key)

with tempfile.TemporaryDirectory(prefix="franc-v1-journey-") as dirname:
    tmp = Path(dirname)
    disk = tmp / "v1-disk.img"
    shutil.copyfile(SEED, disk)
    stage_offline(disk, base, base_source)

    # Boot 1: Home -> calculator -> drawing -> IDE typing/cursor edit/save ->
    # Files -> Packages install pinned dependency from offline shelf.
    g = Guest(disk, tmp, "boot1")
    try:
        g.ready()
        g.screenshot("v1-01-home")
        g.key(b"1", b"FracCalc | Enter:", timeout=290)
        g.line("1/3 1/6 +", b"ans: 1/2", timeout=160)
        g.key(b"\x1b", b"Franc> ", timeout=120)
        print("PASS: normal calculator route returns to Home", flush=True)
        g.enter_repl()
        for word in ("user-compile", "user-code-stage", "ide-run-user",
                     "ide-main", "pkg-ui", "pkg-run-pair", "ui-frame",
                     "svc-net-info", "svc-dns-request"):
            assert g.value(f'"{word}" s2-find if0 0 else 1 then .') == 1, word
        print("PASS: every required JIT UI/ABI entrypoint resolved after full native app bundle load", flush=True)
        g.line("20 fordland", b"Frac> ", timeout=170)
        g.screenshot("v1-02-graphics")
        g.leave_repl()
        g.key(b"9", b"ide> ", timeout=230)
        g.key(b"n", b"new file> ")
        g.line("v1-demo.frac", b"NEW BUFFER")
        g.key(b"e", b"FrancOS IDE | ", timeout=130)
        g.screenshot("v1-03-ide-empty")
        # Type genuine two-line Franc source into the on-screen editor.
        source = b"def main\n200 count fault ;"
        entered = bytearray()
        for ch in source:
            offset = len(g.out)
            os.write(g.process.stdin.fileno(), bytes((ch,)))
            entered.append(ch)
            g.expect(bytes(entered) + b"|", offset, timeout=50)
            time.sleep(.11)
        # Move PS/2 left into the middle of the second line.
        last_line = b"200 count fault ;"
        for n in range(1, 15):
            offset = len(g.out)
            g.hmp("sendkey left")
            cursor = len(last_line) - n
            g.expect(last_line[:cursor] + b"|" + last_line[cursor:],
                     offset, timeout=55)
        # Replace 200 with 100 using real Backspace and input, not REPL.
        for remaining in (b"20", b"2", b""):
            offset = len(g.out)
            os.write(g.process.stdin.fileno(), b"\x08")
            g.expect(b"def main\n" + remaining + b"| count fault ;",
                     offset, timeout=60)
        for prefix in (b"1", b"10", b"100"):
            offset = len(g.out)
            os.write(g.process.stdin.fileno(), prefix[-1:])
            g.expect(b"def main\n" + prefix + b"| count fault ;",
                     offset, timeout=60)
        g.screenshot("v1-04-ide-middle-edit")
        g.key(b"\t", b"SAVED |", timeout=120)
        g.screenshot("v1-05-ide-saved")
        g.key(b"\x1b", b"ide> ")
        g.key(b"q", b"Franc> ")
        g.key(b"z", b"files> ")
        assert b"v1-demo.frac" in bytes(g.out[-6000:])
        g.screenshot("v1-06-files")
        g.key(b"\x1b", b"Franc> ")
        g.packages()
        refused = g.key(b"x", b"pkg> ", timeout=80)
        assert b"User launch refused" in refused, refused
        g.screenshot("v1-07-error-no-package")
        g.install("base")
        status = g.show_packages()
        assert b"base version 1.0.0" in status, status
        g.screenshot("v1-08-installed-base")
        g.key(b"\x1b", b"Franc> ")
        print("PASS: Home, calculator, drawing, real two-line cursor IDE, persisted source and native base install", flush=True)
    finally:
        g.close()

    stage_offline(disk, app, app_source)
    # Boot 2: browse/reopen saved IDE source, execute it in genuine CPL3,
    # verify fault isolation + re-launch, install dependent app from GUI.
    g = Guest(disk, tmp, "boot2")
    try:
        g.ready()
        g.key(b"z", b"files> ")
        assert b"v1-demo.frac" in bytes(g.out[-7000:])
        g.key(b"\x1b", b"Franc> ")
        g.key(b"9", b"ide> ", timeout=240)
        g.key(b"o", b"open file> ")
        g.line("v1-demo.frac", b"OPENED")
        g.key(b"e", b"FrancOS IDE | ", timeout=150)
        g.expect(b"100 count fault ;", len(g.out)-1800, timeout=70)
        g.screenshot("v1-09-ide-cold-reopen")
        g.key(b"\x1b", b"ide> ")
        result = g.key(b"y", b"ide> ", timeout=290)
        assert b"A fault isolated | B survived" in result, result[-1800:]
        assert b"New CPL3 process generation" in result, result[-1800:]
        g.screenshot("v1-10-isolated-user-status")
        g.key(b"q", b"Franc> ")
        g.packages()
        g.install("app")
        result = g.key(b"x", b"pkg> ", timeout=310)
        assert b"Isolated program completed" in result, result[-1600:]
        g.screenshot("v1-11-package-executed")
        refused = g.key(b"u", b"Uninstall app/base> ")
        denied = g.line("base", b"pkg> ")
        assert b"Dependent application installed" in denied, denied[-1200:]
        g.screenshot("v1-12-dependency-refused")
        g.key(b"\x1b", b"Franc> ")
        g.enter_repl()
        assert g.value("user-preempt-a-steps .") == 100
        assert g.value("user-preempt-a-state .") == 4
        assert g.value("user-preempt-b-state .") == 3
        assert g.value("user-preempt-reclaimed .") == 14
        assert g.value("page-free-count .") == 2048
        assert g.value("2 3 + .") == 5
        g.leave_repl()
        print("PASS: rebooted IDE source ran inside CPL3, A fault isolated, B survived, new task launched and installed app ran", flush=True)
    finally:
        g.close()

    stage_offline(disk, update, app_update_source)
    # Boot 3: update, run new version, rollback, run original version.
    g = Guest(disk, tmp, "boot3")
    try:
        g.ready()
        g.packages()
        status = g.show_packages()
        assert b"app version 1.0.0" in status, status[-1400:]
        g.install("app")
        status = g.show_packages()
        assert b"app version 1.1.0" in status, status[-1400:]
        g.screenshot("v1-13-updated")
        result = g.key(b"x", b"pkg> ", timeout=320)
        assert b"Isolated program completed" in result
        g.key(b"\x1b", b"Franc> ")
        g.enter_repl()
        assert g.value("user-preempt-a-steps .") == 200
        assert g.value("page-free-count .") == 2048
        g.leave_repl()
        g.packages()
        g.pkg_action(b"b", "app", b"Rollback app/base> ",
                     b"Previous version restored")
        status = g.show_packages()
        assert b"app version 1.0.0" in status
        g.screenshot("v1-14-rollback")
        result = g.key(b"x", b"pkg> ", timeout=320)
        assert b"Isolated program completed" in result
        g.key(b"\x1b", b"Franc> ")
        g.enter_repl()
        assert g.value("user-preempt-a-steps .") == 100
        assert g.value("page-free-count .") == 2048
        g.leave_repl()
        g.packages()
        g.pkg_action(b"u", "app", b"Uninstall app/base> ", b"Package removed")
        g.pkg_action(b"u", "base", b"Uninstall app/base> ", b"Package removed")
        state = g.show_packages()
        assert b"app not installed" in state and b"base not installed" in state
        g.screenshot("v1-15-uninstalled")
        g.key(b"\x1b", b"Franc> ")
        print("PASS: UI update/rollback/uninstall with real CPL3 execution at each version", flush=True)
    finally:
        g.close()

    # Boot 4: cold persistence, deliberate network failure statuses, actual
    # PCAP-backed DNS exchange via reusable bounded service; inspect UI.
    g = Guest(disk, tmp, "boot4")
    try:
        g.ready()
        g.packages()
        status = g.show_packages()
        assert b"app not installed" in status and b"base not installed" in status
        network = g.key(b"n", b"pkg> ")
        assert b"NIC not initialized" in network, network[-1500:]
        g.screenshot("v1-16-network-error")
        g.key(b"\x1b", b"Franc> ")
        g.enter_repl()
        assert g.value("svc-net-ready .") == -1
        assert g.value("0 svc-dns-poll .") == -4
        assert g.value("2049 svc-dns-poll .") == -4
        assert g.value("svc-net-open .") == 1
        assert g.value("svc-net-ready .") == -2
        assert g.value("net-arp-request .") == 1
        time.sleep(1.4)
        assert g.value("net-rx-ready? .") == 1
        assert g.value("net-arp-learn .") == 1
        assert g.value("net-rx-consume .") == 1
        assert g.value("net-dns-arp .") == 1
        time.sleep(1.4)
        assert g.value("net-rx-ready? .") == 1
        assert g.value("net-dns-learn .") == 1
        assert g.value("net-rx-consume .") == 1
        assert g.value("svc-net-ready .") == 1
        result = g.value("1024 svc-dns-request .")
        for attempt in range(4):
            if result == 1:
                break
            assert result == -4, f"Unexpected bounded network service result: {result}"
            time.sleep(1.5)
            result = g.value("1024 svc-dns-poll .")
        assert result == 1, "Real bounded DNS receive never completed"
        assert g.value("page-free-count .") == 2048
        g.leave_repl()
        g.packages()
        status = g.key(b"n", b"pkg> ")
        assert b"DNS peer ready" in status, status[-1400:]
        g.screenshot("v1-17-network-ready")
        g.key(b"\x1b", b"Franc> ")
        print("PASS: one persistent v1 disk retains IDE, removes packages and completes bounded DNS plus failed-network UI diagnostics", flush=True)
    finally:
        g.close()
    packet_capture = tmp / "boot4.pcap"
    raw = packet_capture.read_bytes()
    # Independent PCAP evidence: actual QEMU e1000 UDP DNS query, not
    # only a Franc integer return.
    assert len(raw) > 40 and raw[:4] in (b"\xd4\xc3\xb2\xa1",
                                         b"\xa1\xb2\xc3\xd4"), raw[:40]
    import struct
    endian = "<" if raw[:4] == b"\xd4\xc3\xb2\xa1" else ">"
    pos = 24
    found = False
    while pos + 16 <= len(raw):
        _, _, captured, _ = struct.unpack_from(endian + "IIII", raw, pos)
        pos += 16
        frame = raw[pos:pos + captured]
        pos += captured
        if (len(frame) >= 71 and frame[12:14] == b"\x08\x00"
                and frame[23] == 17 and frame[26:30] == b"\x0a\x00\x02\x0f"
                and frame[30:34] == b"\x0a\x00\x02\x03"
                and frame[34:38] == b"\xcf\x08\x00\x35"):
            found = True
            break
    assert found, "Missing real guest UDP/DNS query from unified v1 disk in QEMU PCAP"
    print("PASS: independent PCAP confirms real e1000 IPv4/UDP DNS network path", flush=True)

assert len(tuple(CAPTURE.glob("v1-*.ppm"))) >= 17, "Not all requested UI frames were captured"
print("PASS: all seven FrancOS v1 journey stages on the SAME PERSISTENT QEMU DISK", flush=True)
