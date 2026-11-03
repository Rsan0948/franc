#!/usr/bin/env python3
"""Isolated native Franctxt test on QEMU BIOS FrancOS with persistent storage.

Replaces only the *test disk's* app bundle with Franc compatibility and
Franctxt source; the committed production bundle is left unchanged.
"""
from pathlib import Path
import hashlib
import os
import selectors
import shutil
import subprocess
import sys
import tempfile
import time

root = Path(__file__).resolve().parents[2] / "stage4"
base = Path(sys.argv[1] if len(sys.argv) > 1 else root / "native_seed.img")
assert base.is_file() and shutil.which("qemu-system-x86_64")

with tempfile.TemporaryDirectory(prefix="franctxt-native-") as temp:
    disk = Path(temp) / "disk.img"
    shutil.copyfile(base, disk)
    original = disk.read_bytes()
    directory = 129 * 512 + 32
    size = int.from_bytes(original[directory + 24:directory + 26], "little")
    config = original[140 * 512:140 * 512 + size]
    canonical_sha = hashlib.sha256(b"franctxt/1" + bytes((0,)) + config).hexdigest()

    subprocess.run(
        ["sh", str(root / "source_pack.sh"), str(disk),
         str(root / "apps" / "native-compat.frac"),
         str(root.parent / "lib" / "franctxt.frac")],
        env={**os.environ, "FRANC_SOURCE_LBA": "1024"},
        check=True,
    )

    def session(persist=False, tampered=False):
        guest = subprocess.Popen(
            ["qemu-system-x86_64", "-m", "128M", "-accel", "tcg",
             "-display", "none", "-monitor", "none", "-no-reboot",
             "-serial", "stdio", "-drive", f"file={disk},format=raw,if=ide"],
            stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, bufsize=0,
        )
        data = bytearray()
        sel = selectors.DefaultSelector()
        sel.register(guest.stdout, selectors.EVENT_READ)

        def until(needle, start=0, timeout=100):
            end = time.monotonic() + timeout
            while time.monotonic() < end:
                if needle in data[start:]:
                    return bytes(data[start:])
                if guest.poll() is not None:
                    break
                if sel.select(0.1):
                    chunk = os.read(guest.stdout.fileno(), 16384)
                    if not chunk:
                        break
                    data.extend(chunk)
            raise AssertionError(f"Missing {needle!r}, last output={bytes(data[-1000:])!r}")

        def key(k, marker):
            start = len(data)
            os.write(guest.stdin.fileno(), k)
            return until(marker, start, 120)

        def line(command, expected):
            start = len(data)
            for c in command.encode("ascii"):
                position = len(data)
                os.write(guest.stdin.fileno(), bytes((c,)))
                until(bytes((c,)), position, 12)
                time.sleep(0.08)
            os.write(guest.stdin.fileno(), b"\n")
            result = until(b"Frac> ", start, 100)
            assert b"stage2: unsupported token" not in result, result
            assert expected in result, (command, expected, result[-1000:])
            return result

        try:
            until(b"Franc> ", timeout=160)
            loaded = key(b"l", b"APPS READY")
            assert b"stage2: unsupported token" not in loaded, loaded[-1400:]
            key(b"r", b"Frac> ")
            line("ft-config ft-header? .", b"1\nFrac> ")
            line('ft-config "memory.page-size" ft-get ft-int .', b"4096\nFrac> ")
            line('ft-config "schema" ft-get ft-unquote type cr',
                 b"francos.kernel.v1\nFrac> ")
            line("ft-show-config", b"FRANCTXT CONFIG")
            line("ft-show-identity", b"FRANCTXT KERNEL IDENTITY")
            target_hash = modified_sha if tampered else canonical_sha
            line("ft-config ft-hash type cr", target_hash.encode("ascii") + bytes((10,)) + b"Frac> ")
            line("ft-verify-config .", (b"0" if tampered else b"1") + bytes((10,)) + b"Frac> ")
            print("PASS: native FrancOS SHA-256 exactly matches independent host digest", flush=True)

            if persist:
                line('"saved.franctxt" ft-config fs-save .', b"1\nFrac> ")
            else:
                line('"saved.franctxt" ft-file "system.name" ft-get ft-unquote type cr',
                     b"FrancOS\nFrac> ")
            print("PASS: QEMU Franc-native parser, typed lookup and disk-backed identity")
        finally:
            guest.kill()
            guest.wait()

    session(persist=True)
    session(persist=False)
    print("PASS: Franctxt configuration survives a complete FrancOS cold reboot")
    # Tamper with one character of the persistent config but leave the
    # separately stored manifest unchanged. A third cold boot must reject
    # the config's manifest binding and still permit the saved copy.
    image = bytearray(disk.read_bytes())
    start = 140 * 512
    where = image.find(b"FrancOS", start, start + size)
    assert where >= 0, "native config has no expected system.name"
    image[where:where + 7] = b"FrancMX"
    disk.write_bytes(image)
    changed_config = bytes(image[start:start + size])
    modified_sha = hashlib.sha256(
        b"franctxt/1" + bytes((0,)) + changed_config
    ).hexdigest()
    assert modified_sha != canonical_sha
    session(persist=False, tampered=True)
    print("PASS: native FrancOS detects changed config against the unchanged manifest")

