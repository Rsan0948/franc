#!/usr/bin/env python3
"""Actual OVMF/UEFI cold-boot test of the separate C loader + C-free FrancOS.

UEFI firmware boots a FAT ESP on virtio, while Franc's original ATA disk
remains the first IDE master. No firmware C is linked into the Franc kernel.
"""
from pathlib import Path
import os
import selectors
import shutil
import subprocess
import tempfile
import time

root = Path(__file__).resolve().parents[1]
qemu = shutil.which("qemu-system-x86_64")
assert qemu, "qemu-system-x86_64 missing"
esp = root / "uefi" / "franc-esp.img"
native = root / "native_seed.img"
assert esp.is_file() and native.is_file()

firmware = [
    ("/usr/share/OVMF/OVMF_CODE_4M.fd", "/usr/share/OVMF/OVMF_VARS_4M.fd"),
    ("/usr/share/OVMF/OVMF_CODE.fd", "/usr/share/OVMF/OVMF_VARS.fd"),
    ("/usr/share/ovmf/OVMF.fd", None),
]
code, vars_template = next(
    ((Path(code), Path(vars_) if vars_ else None) for code, vars_ in firmware
     if Path(code).is_file() and (not vars_ or Path(vars_).is_file())), (None, None))
assert code, "OVMF firmware files unavailable"

with tempfile.TemporaryDirectory(prefix="franc-uefi-") as tmp:
    temp = Path(tmp)
    ata = temp / "native.img"
    fat = temp / "esp.img"
    shutil.copyfile(native, ata)
    shutil.copyfile(esp, fat)
    cmd = [qemu, "-m", "128M", "-accel", "tcg",
           "-display", "none", "-monitor", "none", "-no-reboot",
           "-serial", "stdio", "-net", "none",
           "-drive", f"file={ata},format=raw,if=ide,index=0",
           "-drive", f"file={fat},format=raw,if=virtio"]
    if vars_template:
        vars_copy = temp / "OVMF_VARS.fd"
        shutil.copyfile(vars_template, vars_copy)
        cmd += ["-drive", f"if=pflash,format=raw,unit=0,readonly=on,file={code}",
                "-drive", f"if=pflash,format=raw,unit=1,file={vars_copy}"]
    else:
        cmd += ["-bios", str(code)]
    process = subprocess.Popen(
        cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT, bufsize=0)
    select = selectors.DefaultSelector()
    select.register(process.stdout, selectors.EVENT_READ)
    log = bytearray()
    try:
        deadline = time.monotonic() + 170
        while time.monotonic() < deadline:
            if b"FRANC INTERACTIVE READY" in log or process.poll() is not None:
                break
            if select.select(0.25):
                chunk = os.read(process.stdout.fileno(), 16384)
                if not chunk:
                    break
                log.extend(chunk)
        output = bytes(log)
        print(output[-6000:].decode("utf-8", errors="replace"), flush=True)
        required = [
            b"UEFI FRANC LOADER", b"UEFI KERNEL LOADED",
            b"UEFI TRANSFER", b"UEFI EXIT OK",
            b"FrancOS AOT | 64-bit | no C runtime",
            b"ATA WRITE READBACK DONE", b"STORAGE OK",
            b"AOT BOOT OK", b"FRANC INTERACTIVE READY",
        ]
        missing = [value for value in required if value not in output]
        if missing:
            raise AssertionError(f"OVMF did not boot native FrancOS; missing {missing}")
        print("PASS: OVMF UEFI C loader transfers to C-free FrancOS kernel", flush=True)
        # Confirm QEMU still uses the original ATA image rather than the ESP.
        process.stdin.write(b"l")
        process.stdin.flush()
        deadline = time.monotonic() + 110
        while time.monotonic() < deadline and b"APPS READY" not in log:
            if process.poll() is not None:
                break
            if select.select(0.25):
                chunk = os.read(process.stdout.fileno(), 16384)
                if not chunk:
                    break
                log.extend(chunk)
        if b"APPS READY" not in log:
            raise AssertionError(f"UEFI guest did not load Franc apps: {bytes(log[-1600:])!r}")
        print("PASS: UEFI kernel loads Franc source applications from original ATA disk",
              flush=True)
    finally:
        process.kill()
        process.wait()
