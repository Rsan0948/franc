#!/usr/bin/env python3
"""Integration gate: native FrancOS loads and executes the original app libraries.

Python is only the CI UART/QEMU test driver, never the native kernel compiler.
The test starts from a Franc-generated assembly seed and executes app code in
the guest's Franc JIT. Its disk image is a disposable copy.
"""
from pathlib import Path
import os, re, selectors, shutil, subprocess, sys, tempfile, time

root=Path(__file__).resolve().parent
image=Path(sys.argv[1] if len(sys.argv)>1 else root/'native_seed.img').resolve()
qemu=shutil.which('qemu-system-x86_64')
assert qemu and image.is_file(), 'QEMU and assembled Franc seed image required'

with tempfile.TemporaryDirectory(prefix='franc-native-apps-') as temp:
    disk=Path(temp)/'apps.img'
    shutil.copyfile(image,disk)
    guest=subprocess.Popen([
        qemu,'-m','128M','-accel','tcg','-display','none','-monitor','none',
        '-no-reboot','-serial','stdio','-drive',f'file={disk},format=raw,if=ide'
    ],stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,bufsize=0)
    out=bytearray()
    sel=selectors.DefaultSelector()
    sel.register(guest.stdout,selectors.EVENT_READ)
    def read_until(marker,after=0,timeout=120):
        limit=time.monotonic()+timeout
        while time.monotonic()<limit:
            if marker in out[after:]:
                return bytes(out[after:])
            if guest.poll() is not None:
                break
            if sel.select(0.2):
                chunk=os.read(guest.stdout.fileno(),65536)
                if not chunk:break
                out.extend(chunk)
        raise AssertionError(f'Expected {marker!r}; UART tail={bytes(out[-3000:])!r}')
    def send_key(k,marker,timeout=90):
        start=len(out)
        time.sleep(0.3)
        os.write(guest.stdin.fileno(),k)
        return read_until(marker,start,timeout)
    def send_line(line,marker,timeout=80):
        # The emulated COM1 UART has a one-byte receive register: feed one
        # character at a time and await its echo, not a burst of serial bytes.
        text=line.encode('ascii')+b'\n'
        for ch in text:
            start=len(out)
            time.sleep(0.11)
            os.write(guest.stdin.fileno(),bytes([ch]))
            if ch==10:
                return read_until(marker,start,timeout)
            read_until(bytes([ch]),start,timeout)

    try:
        read_until(b'Franc> ',timeout=150)
        loaded=send_key(b'l',b'APPS READY',timeout=240)
        read_until(b'Franc> ',len(out)-1,timeout=50) if not out.endswith(b'Franc> ') else None
        assert b'APPS SOURCE MISSING' not in loaded,loaded[-1500:]
        assert b'APPS INIT MISSING' not in loaded,loaded[-1500:]
        assert b'stage2: unsupported token' not in loaded,loaded[-1500:]
        match=re.search(rb'APPS LOADED (\d+)\n',loaded)
        assert match and int(match.group(1))>=60,loaded[-1500:]
        print(f'PASS: Franc guest compiled {int(match.group(1))} source lines from all 12 native libraries',flush=True)

        demo=send_key(b'8',b'120\nFranc> ',timeout=80)
        assert b'25\n120\n' in demo,demo[-1000:]
        print('PASS: native example runs exact rational and recursive factorial code',flush=True)

        send_key(b'r',b'Frac> ',timeout=45)
        send_line('2 10 ^ .',b'1024\nFrac> ')
        send_line('walk-reset',b'Frac> ')
        send_line('walk-left',b'Frac> ')
        send_line('wk-p wk-q / .',b'1/2\nFrac> ')
        send_line('10 11 14 pixel',b'Frac> ')
        send_line('10 11 pixel@ .',b'14\nFrac> ')
        print('PASS: native powers, Stern-Brocot explorer logic and VGA pixel round-trip',flush=True)
        send_key(b'\x1b',b'Franc> ',timeout=50)

        calc=send_key(b'1',b'FracCalc | Enter:',timeout=60)
        assert b'FracCalc' in calc,calc[-800:]
        send_line('1/3 1/6 +',b'ans: 1/2\n',timeout=70)
        send_key(b'\x1b',b'Franc> ',timeout=50)
        print('PASS: interactive FracCalc evaluates rational expression in native guest',flush=True)
        print('PASS: native Franc app suite integrated in C-free FrancOS',flush=True)
    finally:
        guest.kill()
        guest.wait()
