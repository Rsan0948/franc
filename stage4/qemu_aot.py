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
    for marker in [b'FrancOS AOT | 64-bit | no C runtime',b'1/2',b'25',b'BRANCH OK',b'3\n',b'70\n',b'42\n',b'ATA WRITE READBACK DONE',b'AOT BOOT OK']:
        assert marker in buffer, f'missing {marker!r}; QEMU output={buffer!r}'
    print('PASS: cold BIOS boot -> standalone native Franc program (assembly runtime only)')
finally:
    p.kill();p.wait()
