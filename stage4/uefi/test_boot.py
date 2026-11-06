#!/usr/bin/env python3
"""Actual OVMF/UEFI cold-boot test of the separate C loader + C-free FrancOS.

UEFI firmware boots a FAT ESP on virtio, while Franc's original ATA disk
remains the first IDE master. No firmware C is linked into the Franc kernel.
"""
from pathlib import Path
import os
import selectors
import re
import socket
import shutil
import subprocess
import tempfile
import time

root = Path(__file__).resolve().parents[1]
qemu = shutil.which("qemu-system-x86_64")
assert qemu, "qemu-system-x86_64 missing"
esp = Path(os.environ.get("FRANC_UEFI_ESP", str(root / "uefi" / "franc-esp.img"))).resolve()
native = Path(os.environ.get("FRANC_BIOS_IMAGE", str(root / "native_seed.img"))).resolve()
assert esp.is_file() and native.is_file()

firmware = [
    (os.environ.get("FRANC_OVMF_CODE", ""), os.environ.get("FRANC_OVMF_VARS") or None),
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
    monitor = temp / "monitor.sock"
    cmd = [qemu, "-m", "128M", "-accel", "tcg",
           "-display", "none",
           "-monitor", f"unix:{monitor},server=on,wait=off", "-no-reboot",
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
            b"ATA READ OK",
            b"AOT BOOT OK", b"FRANC INTERACTIVE READY",
        ]
        missing = [value for value in required if value not in output]
        if missing:
            raise AssertionError(f"OVMF did not boot native FrancOS; missing {missing}")
        print("PASS: OVMF UEFI C loader transfers to C-free FrancOS kernel", flush=True)
        if b"UEFI GOP HANDOFF READY" not in output:
            raise AssertionError("UEFI did not select a validated 800x600+ display")
        # Actual QEMU HMP screendump; no host-drawn imitation of the OS.
        time.sleep(0.8)
        destination = temp / "uefi-gop-home.ppm"
        with socket.socket(socket.AF_UNIX,socket.SOCK_STREAM) as hmp:
            hmp.settimeout(20)
            deadline=time.monotonic()+20
            while not monitor.exists() and time.monotonic()<deadline:
                time.sleep(0.1)
            hmp.connect(str(monitor))
            greeting=b""
            while b"(qemu)" not in greeting:
                greeting+=hmp.recv(8192)
            hmp.sendall(("screendump "+str(destination)+"\n").encode("ascii"))
            response=b""
            while b"(qemu)" not in response:
                response+=hmp.recv(8192)
            assert b"error" not in response.lower(), response
            print("GOP QEMU HMP screenshot response: "+repr(response), flush=True)
        deadline=time.monotonic()+10
        while not destination.exists() and time.monotonic()<deadline:
            time.sleep(0.1)
        if not destination.exists():
            raise AssertionError(f"QEMU did not create GOP screendump: {response!r}")
        raw=destination.read_bytes()
        match=re.match(rb"P6\s+(\d+)\s+(\d+)\s+255\s",raw)
        assert match, raw[:60]
        w,h=map(int,match.groups())
        assert w>=800 and h>=600, ("GOP framebuffer resolution",w,h)
        pixels=raw[match.end():]
        assert len(pixels)==w*h*3,(len(pixels),w,h)
        sample_step=max(3,(len(pixels)//1400)//3*3)
        palette={pixels[i:i+3] for i in range(0,len(pixels),sample_step)}
        # A few firmware-colored pixels at y<10 are NOT proof of a
        # kernel-owned framebuffer. Require colored native glyphs inside
        # the real text viewport, which starts at y=32.
        interior=0
        for y in range(32,min(h,280),4):
            for x in range(32,min(w,800),4):
                idx=(y*w+x)*3
                if any(pixels[idx:idx+3]):
                    interior+=1
        if interior<50:
            print(f"FAIL: GOP screenshot had only {interior} inner nonblack samples, "
                  f"colors={palette}",flush=True)
            raise AssertionError("GOP text interior not rendered by FrancOS")
        assert len(palette)>1, "No native FrancOS glyphs on GOP screen"
        # The native Home item currently selected by Franc should have a
        # real green-teal 16-pixel focus bar behind its text.
        selected=(180*w+550)*3
        focus_rgb=tuple(pixels[selected:selected+3])
        assert 45<=focus_rgb[0]<=75 and 60<=focus_rgb[1]<=105 and 55<=focus_rgb[2]<=100, (
            "Guest keyboard-focus highlight not painted",focus_rgb)
        print("PASS: native FrancOS Home focus bar RGB="+repr(focus_rgb),flush=True)
        if w>=980:
            panel_pixel=(420*w+760)*3
            red,green,blue=pixels[panel_pixel:panel_pixel+3]
            assert 25<=red<=50 and 35<=green<=65 and 45<=blue<=85, (
                "Native FrancUI workspace panel was not rendered",
                (red,green,blue))
            print("PASS: guest-native FrancUI workspace panel RGB="
                  +repr((red,green,blue)),flush=True)
        captures=Path(os.environ.get("FRANC_UEFI_CAPTURE_DIR",root/"uefi"/"screenshots"))
        captures.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(destination,captures/"uefi-gop-home.ppm")
        print(f"PASS: native GOP framebuffer {w}x{h}, pixel colors={len(palette)}",flush=True)
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

        def send_ui_key(key, marker, seconds=100):
            start=len(log)
            process.stdin.write(key)
            process.stdin.flush()
            deadline=time.monotonic()+seconds
            while time.monotonic()<deadline and marker not in log[start:]:
                if process.poll() is not None:
                    break
                if select.select(0.2):
                    part=os.read(process.stdout.fileno(),16384)
                    if not part:break
                    log.extend(part)
            if marker not in log[start:]:
                raise AssertionError(("UEFI keyboard route missing",marker,
                                      bytes(log[-1500:])))
            print("PASS: UEFI native keyboard route "+repr(marker),flush=True)

        def take_uefi_app_frame(label):
            time.sleep(0.7)  # serial output precedes the actual guest glyphs
            output=temp/(f"uefi-gop-{label}.ppm")
            with socket.socket(socket.AF_UNIX,socket.SOCK_STREAM) as hmp:
                hmp.settimeout(25)
                hmp.connect(str(monitor))
                greeting=b""
                while b"(qemu)" not in greeting:greeting+=hmp.recv(8192)
                hmp.sendall(("screendump "+str(output)+"\n").encode("ascii"))
                response=b""
                while b"(qemu)" not in response:response+=hmp.recv(8192)
                assert b"error" not in response.lower(),response
            deadline=time.monotonic()+12
            while not output.exists() and time.monotonic()<deadline:
                time.sleep(0.1)
            assert output.exists(), ("Missing real QEMU screenshot",label)
            raw=output.read_bytes()
            match=re.match(rb"P6\s+(\d+)\s+(\d+)\s+255\s",raw)
            assert match,(label,raw[:64])
            cw,ch=map(int,match.groups())
            assert cw==w and ch==h,(label,cw,ch,w,h)
            rgb=raw[match.end():]
            assert len(rgb)==cw*ch*3,(label,len(rgb))
            if cw>=980:
                pos=(420*cw+760)*3
                red,green,blue=rgb[pos:pos+3]
                assert 25<=red<=50 and 35<=green<=65 and 45<=blue<=85,(
                    "Native GOP panel missing in "+label,(red,green,blue))
            shutil.copyfile(output,captures/output.name)
            print(f"PASS: real UEFI FrancOS {label} frame {cw}x{ch}",flush=True)

        send_ui_key(b"m",b"pkg> ",seconds=160)
        take_uefi_app_frame("packages")
        send_ui_key(b"\x1b",b"Franc> ")
        send_ui_key(b"9",b"ide> ",seconds=160)
        send_ui_key(b"e",b"FrancOS IDE")
        take_uefi_app_frame("ide")
    finally:
        process.kill()
        process.wait()
