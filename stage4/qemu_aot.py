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
    deadline=time.monotonic()+150
    while time.monotonic()<deadline and b'AOT BOOT OK' not in buffer:
        if p.poll() is not None:break
        if selector.select(0.3):
            data=os.read(p.stdout.fileno(),8192)
            if not data:break
            buffer+=data
    print(buffer.decode(errors='replace'))
    for marker in [b'FrancOS AOT | 64-bit | no C runtime',b'1/2',b'25',b'BRANCH OK',b'3\n',b'70\n',b'42\n',b'ATA WRITE READBACK DONE',b'def saved 77 ;',b'STORAGE OK',b'AOT BOOT OK']:
        assert marker in buffer, f'missing {marker!r}; QEMU output={buffer!r}'
    # Read and send one character at a time. Sending "psg\x1b" together
    # can overflow the emulated COM1 receive register while Franc redraws.
    nonlocal_buffer = []
    # Use a mutable collector for all output read after boot.
    def read_until(marker, timeout=12, after=0):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            current = buffer + b''.join(nonlocal_buffer)
            if marker in current[after:]:
                return current
            if p.poll() is not None:
                break
            if selector.select(0.2):
                data = os.read(p.stdout.fileno(), 8192)
                if not data:
                    break
                nonlocal_buffer.append(data)
        raise AssertionError(f'missing {marker!r}; QEMU output={current!r}')

    transcript = read_until(b'Franc> ', timeout=10)
    for key, expected in [
        (b'p', b'1/2\nFranc> '),
        (b's', b'def saved 77 ;\nFranc> '),
        (b'g', b'GRAPHICS IN FRANC\nFranc> '),
        (b'\x1b', b'EXIT CONSOLE')
    ]:
        offset = len(transcript)
        os.write(p.stdin.fileno(), key)
        transcript = read_until(expected, timeout=12, after=offset)
    for marker in (b'FRANC FRAMEBUFFER READY', b'FRANC INTERACTIVE READY',
                   b'GRAPHICS IN FRANC', b'EXIT CONSOLE'):
        assert marker in transcript, f'missing {marker!r}: {transcript!r}'
    assert transcript.count(b'1/2') >= 2, transcript
    print('PASS: C-free cold boot, Franc framebuffer console, serial keyboard and storage')
finally:
    p.kill();p.wait()
