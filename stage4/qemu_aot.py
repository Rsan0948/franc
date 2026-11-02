#!/usr/bin/env python3
"""QEMU evidence for Franc AOT, no C runtime, no C object files."""
from pathlib import Path
import os, selectors, shutil, subprocess, sys, time
root=Path(__file__).resolve().parent
qemu=shutil.which('qemu-system-x86_64')
if not qemu:sys.exit('QEMU missing: boot cannot be claimed verified')
p=subprocess.Popen([qemu,'-m','128M','-accel','tcg','-display','none',
                    '-monitor','none','-no-reboot','-serial','stdio',
                    '-drive',f'file={root/"franos-aot.img"},format=raw,if=ide'],
                   stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,bufsize=0)
selector=selectors.DefaultSelector();selector.register(p.stdout,selectors.EVENT_READ)
buffer=b''
try:
    deadline=time.monotonic()+30
    while time.monotonic()<deadline and b'AOT BOOT OK' not in buffer:
        if p.poll() is not None:break
        if selector.select(0.3):
            data=os.read(p.stdout.fileno(),8192)
            if not data:break
            buffer+=data
    print(buffer.decode(errors='replace'))
    for marker in [b'FrancOS AOT | 64-bit | no C runtime',b'1/2',b'25',b'BRANCH OK',b'3\n',b'70\n',b'42\n',b'ATA WRITE READBACK DONE',b'def saved 77 ;',b'STORAGE OK',b'AOT BOOT OK']:
        assert marker in buffer, f'missing {marker!r}; QEMU output={buffer!r}'
    # Hardware exercised through the Franc-owned COM1 input polling loop.
    deadline=time.monotonic()+8
    while time.monotonic()<deadline and b'FRANC INTERACTIVE READY' not in buffer:
        if selector.select(0.2):
            data=os.read(p.stdout.fileno(),8192)
            if data: buffer+=data
    assert b'FRANC INTERACTIVE READY' in buffer, f'console missing: {buffer!r}'
    os.write(p.stdin.fileno(), b'psg\x1b')
    deadline=time.monotonic()+15
    while time.monotonic()<deadline and b'EXIT CONSOLE' not in buffer:
        if selector.select(0.3):
            data=os.read(p.stdout.fileno(),8192)
            if data: buffer+=data
    for marker in (b'FRANC FRAMEBUFFER READY',b'FRANC INTERACTIVE READY',b'GRAPHICS IN FRANC',b'EXIT CONSOLE'):
        assert marker in buffer, f'missing {marker!r} from Franc console: {buffer!r}'
    assert buffer.count(b'1/2') >= 2, buffer
    print('PASS: C-free cold boot, Franc framebuffer console, serial keyboard and storage')
finally:
    p.kill();p.wait()
