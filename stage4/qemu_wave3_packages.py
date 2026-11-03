#!/usr/bin/env python3
"""Wave 3 U3 acceptance: real FrancOS offline package transactions in BIOS QEMU.

The host ONLY prepares trusted upload candidates in two staging FRANCFS1
slots while the VM is OFF. The guest must validate canonical manifest,
raw SHA256, pinned dependency, inactive bank and monotonic version before
it installs, updates, rolls back, uninstalls or launches the package in CPL3.
The SAME disk is cold-rebooted at each transition. No in-guest code is faked.
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
ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from franctxt.packages import manifest_for, plan_install
IMAGE = Path(sys.argv[1] if len(sys.argv) > 1 else ROOT / "stage4/native_seed.img").resolve()
QEMU = shutil.which("qemu-system-x86_64")
assert QEMU and IMAGE.exists(), "Native image and qemu-system-x86_64 required"
FS_DIR = 129 * 512


def stage_upload(disk, package, source, *, corrupt=False):
    """Add/replace two upload files, leave installed bank and system slots intact."""
    buffer = bytearray(disk.read_bytes())
    assert buffer[128 * 512:128 * 512 + 8] == b"FRANCFS1"
    manifest = package.manifest
    source = (source[:-1] + b"!") if corrupt else source
    for slot, name, data in ((2, "upload.franctxt", manifest),
                             (3, "upload.frac", source)):
        assert 0 < len(data) <= 2047
        record = FS_DIR + slot * 32
        old = buffer[record:record + 32]
        assert not old[:24].strip(b"\x00") or old[:24].split(b"\0")[0] == name.encode()
        entry = bytearray(32)
        entry[:len(name)] = name.encode("ascii")
        entry[24:26] = len(data).to_bytes(2, "little")
        buffer[record:record + 32] = entry
        start = (136 + slot * 4) * 512
        buffer[start:start + 2048] = data.ljust(2048, b"\x00")
    disk.write_bytes(buffer)


class Guest:
    def __init__(self, disk):
        self.p = subprocess.Popen(
            [QEMU, "-m", "128M", "-accel", "tcg", "-display", "none",
             "-no-reboot", "-monitor", "none", "-serial", "stdio",
             "-drive", f"file={disk},format=raw,if=ide"],
            stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, bufsize=0
        )
        self.output = bytearray()
        self.sel = selectors.DefaultSelector()
        self.sel.register(self.p.stdout, selectors.EVENT_READ)

    def until(self, marker, start=0, timeout=210):
        marker = marker.encode("ascii") if isinstance(marker, str) else marker
        end = time.monotonic() + timeout
        while time.monotonic() < end:
            if marker in self.output[start:]:
                return bytes(self.output[start:])
            if self.p.poll() is not None:
                break
            if self.sel.select(.15):
                chunk = os.read(self.p.stdout.fileno(), 65536)
                if not chunk:
                    break
                self.output.extend(chunk)
        raise AssertionError(f"Missing {marker!r}; QEMU exit={self.p.poll()}, tail={bytes(self.output[-1800:])!r}")

    def key(self, value, marker, timeout=300):
        pos = len(self.output)
        time.sleep(.25)
        os.write(self.p.stdin.fileno(), value)
        return self.until(marker, pos, timeout)

    def line(self, source, timeout=180):
        start = len(self.output)
        for value in source.encode("ascii"):
            offset = len(self.output)
            os.write(self.p.stdin.fileno(), bytes([value]))
            self.until(bytes([value]), offset, 20)
            time.sleep(.07)
        os.write(self.p.stdin.fileno(), b"\n")
        data = self.until(b"Frac> ", start, timeout)
        assert b"stage2: unsupported token" not in data, (source, data[-1500:])
        return data

    def value(self, source):
        data = self.line(source)
        matches = re.findall(rb"\n(-?[0-9]+)\r?\nFrac> ", data)
        assert matches, (source, data[-1500:])
        return int(matches[-1])

    def ready(self):
        self.until(b"Franc> ", timeout=200)
        loaded = self.key(b"l", b"APPS READY", timeout=330)
        assert b"stage2: unsupported token" not in loaded, loaded[-1500:]
        self.key(b"r", b"Frac> ", timeout=100)
        assert self.value("page-free-count .") == 2048

    def close(self):
        self.p.kill()
        self.p.wait()


def boot(disk, task):
    g = Guest(disk)
    try:
        g.ready()
        task(g)
    finally:
        g.close()


base_source = b"def main 2 count again ;"
app_v1_source = b"def main 100 count fault ;"
app_v2_source = b"def main 200 count fault ;"
base = manifest_for("base", "1.0.0", {"pkg-base0.frac": base_source},
                    generation=1, entry="pkg-base0.frac")
app = manifest_for("app", "1.0.0", {"pkg-app0.frac": app_v1_source},
                   (("base", "1.0.0"),), generation=1, entry="pkg-app0.frac")
app2 = manifest_for("app", "1.1.0", {"pkg-app1.frac": app_v2_source},
                    (("base", "1.0.0"),), generation=2, entry="pkg-app1.frac")
assert plan_install({base.key: (base, {"pkg-base0.frac": base_source}),
                     app.key: (app, {"pkg-app0.frac": app_v1_source})}, {},
                    app.key).ordered == (base.key, app.key)

with tempfile.TemporaryDirectory(prefix="franc-wave3-pkg-") as td:
    disk = Path(td) / "wave3.img"
    shutil.copyfile(IMAGE, disk)
    stage_upload(disk, base, base_source)
    def install_base(g):
        # Diagnose each native trust boundary, not only a zero result from
        # the all-or-nothing transaction word, when a future app bundle
        # reordering or package parser change introduces a regression.
        for command in (
            '"upload.franctxt" fs-source ft-header? .',
            '"upload.frac" fs-source .',
            '"upload.franctxt" fs-source pkg-cache-manifest "upload.frac" fs-source pkg-verify .',
            '"base" 0 pkg-names .',
            '"base" pkg-select .',
        ):
            print("PKG-PREFLIGHT", command, g.value(command), flush=True)
        assert g.value('"upload.franctxt" "upload.frac" "base" pkg-install-verified .') == 1
        assert g.value('"base" pkg-select .') == 1
        assert g.value("ftr-s .") == 1  # selected generation register
        assert g.value('"base" 0 pkg-bank-valid .') == 1
        assert g.value('"base" pkg-rollback .') == 0
        print("PASS: native install of pinned dependency base, rollback without prior bank refused", flush=True)
    boot(disk, install_base)

    stage_upload(disk, app, app_v1_source)
    def install_app(g):
        assert g.value('"upload.franctxt" "upload.frac" "app" pkg-install-verified .') == 1
        assert g.value('"app" pkg-select .') == 1
        assert g.value("ftr-s .") == 1
        assert g.value('"base" pkg-uninstall .') == 0, "required dependency uninstall must fail"
        assert g.value("irq-start .") == 1
        assert g.value("ring3-probe .") == 1
        assert g.value("pkg-run-pair .") == 1, "Installed Franc sources must actually run in separate Ring3 spaces"
        assert g.value("user-preempt-a-steps .") == 100
        assert g.value("user-preempt-b-state .") == 3
        assert g.value("user-preempt-reclaimed .") == 14
        assert g.value("page-free-count .") == 2048
        print("PASS: cold-reboot verified app+base installation, protected CPL3 execution and dependency refusal", flush=True)
    boot(disk, install_app)

    stage_upload(disk, app2, app_v2_source)
    def upgrade(g):
        assert g.value('"upload.franctxt" "upload.frac" "app" pkg-install-verified .') == 1
        assert g.value('"app" pkg-select .') == 1
        assert g.value("ftr-s .") == 2
        assert g.value('"app" 0 pkg-bank-valid .') == 1
        assert g.value('"app" 1 pkg-bank-valid .') == 2
        assert g.value("irq-start .") == 1
        assert g.value("ring3-probe .") == 1
        assert g.value("pkg-run-pair .") == 1
        assert g.value("user-preempt-a-steps .") == 200
        assert g.value("page-free-count .") == 2048
        print("PASS: SHA256 verified copy-on-write upgrade preserves prior bank and executes updated Franc code", flush=True)
    boot(disk, upgrade)

    def rollback(g):
        assert g.value('"app" pkg-rollback .') == 1
        assert g.value('"app" pkg-select .') == 1
        assert g.value("ftr-s .") == 1
        assert g.value('"app" 1 pkg-bank-valid .') == -1
        assert g.value("irq-start .") == 1
        assert g.value("ring3-probe .") == 1
        assert g.value("pkg-run-pair .") == 1
        assert g.value("user-preempt-a-steps .") == 100
        print("PASS: native rollback restores prior hash-validated source and works after cold reboot", flush=True)
    boot(disk, rollback)

    stage_upload(disk, app2, app_v2_source, corrupt=True)
    def reject_corruption(g):
        assert g.value('"upload.franctxt" "upload.frac" "app" pkg-install-verified .') == 0
        assert g.value('"app" pkg-select .') == 1
        assert g.value("ftr-s .") == 1
        assert g.value('"app" pkg-uninstall .') == 1
        assert g.value('"base" pkg-uninstall .') == 1
        assert g.value('"app" pkg-select .') == 0
        assert g.value('"base" pkg-select .') == 0
        print("PASS: corrupted source rejected before write; both app and dependency uninstalled", flush=True)
    boot(disk, reject_corruption)

    def verify_cold_uninstall(g):
        assert g.value('"app" pkg-select .') == 0
        assert g.value('"base" pkg-select .') == 0
        assert g.value("page-free-count .") == 2048
        assert g.value("2 3 + .") == 5
        print("PASS: uninstall survives cold reboot with healthy protected native kernel", flush=True)
    boot(disk, verify_cold_uninstall)

print("PASS: Wave 3 native package lifecycle + genuine Franc CPL3 user execution", flush=True)
