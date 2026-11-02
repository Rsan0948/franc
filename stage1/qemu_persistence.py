#!/usr/bin/env python3
"""Prove FRANCFS1 source survives a poweroff/reboot in QEMU ATA-IDE.

This script only writes a disposable copy of stage1/fracos.img, never the
repository's source image and never a real device.
"""
from pathlib import Path
import os
import selectors
import shutil
import subprocess
import sys
import tempfile
import time

root = Path(__file__).resolve().parent
qemu = shutil.which('qemu-system-x86_64')
if not qemu:
    sys.exit('QEMU unavailable; disk persistence not verified')

class Guest:
    def __init__(self, disk):
        self.process = subprocess.Popen([
            qemu, '-m', '128M', '-accel', 'tcg', '-monitor', 'none',
            '-display', 'none', '-no-reboot', '-serial', 'stdio',
            '-drive', f'file={disk},format=raw,if=ide',
        ], stdin=subprocess.PIPE, stdout=subprocess.PIPE,
           stderr=subprocess.STDOUT, bufsize=0)
        self.sel = selectors.DefaultSelector()
        self.sel.register(self.process.stdout, selectors.EVENT_READ)
        self.output = b''

    def wait_for(self, needle, start=0, timeout=65):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            if needle in self.output[start:]: return
            if self.process.poll() is not None: break
            for _key, _mask in self.sel.select(timeout=0.3):
                b = os.read(self.process.stdout.fileno(), 16384)
                if b: self.output += b
        raise AssertionError(f'Expected {needle!r}, rc={self.process.poll()}, output={self.output[-3000:]!r}')

    def command(self, source, needle):
        start = len(self.output)
        self.process.stdin.write(source.encode() + b'\n')
        self.process.stdin.flush()
        self.wait_for(needle, start=start)

    def close(self):
        self.process.kill()
        self.process.wait()
        self.sel.close()

with tempfile.TemporaryDirectory() as temp:
    disk = Path(temp) / 'francos-persistent.img'
    shutil.copyfile(root / 'fracos.img', disk)
    assert disk.stat().st_size == 256*512
    first = Guest(disk)
    try:
        first.wait_for(b'Frac> ')
        first.command('disk-ready? .', b'1')
        first.command('"hello.frac" "def persistent-test 37 5 + ;" save', b'Frac> ')
        first.command('"hello.frac" load', b'Frac> ')
        first.command('persistent-test .', b'42')
        print('PASS: QEMU writes and loads source from the formatted ATA-IDE image')
    finally:
        first.close()
    assert b'hello.frac' in disk.read_bytes()[129*512:130*512], 'directory was not written to disk'
    second = Guest(disk)
    try:
        second.wait_for(b'Frac> ')
        second.command('"hello.frac" load', b'Frac> ')
        second.command('persistent-test .', b'42')
        print('PASS: persisted Frac source survives QEMU poweroff and cold boot')
    finally:
        second.close()
