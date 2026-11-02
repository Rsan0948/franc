#!/usr/bin/env python3
"""End-to-end Stage 1 smoke test, needs QEMU and x86-64 BIOS firmware."""
from pathlib import Path
import os
import selectors
import shutil
import subprocess
import sys
import time
import tempfile

root=Path(__file__).resolve().parent
qemu=shutil.which('qemu-system-x86_64')
if not qemu:
    sys.exit('QEMU unavailable; cannot claim a successful boot')
trace_file=Path(tempfile.gettempdir())/'franc-qemu-debug.log'
cmd=[qemu,'-m','128M','-accel','tcg','-d','int,cpu_reset,guest_errors','-D',str(trace_file),'-display','none','-monitor','none','-no-reboot',
     '-serial','stdio','-drive',f'file={root / "fracos.img"},format=raw,if=ide']
p=subprocess.Popen(cmd,stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,bufsize=0)
sel=selectors.DefaultSelector()
sel.register(p.stdout,selectors.EVENT_READ)
transcript=b''

def read_until(needle, timeout=60):
    global transcript
    deadline=time.monotonic()+timeout
    while time.monotonic()<deadline:
        if needle in transcript:return
        if p.poll() is not None:break
        events=sel.select(timeout=min(0.3,max(0,deadline-time.monotonic())))
        if events:
            buf=os.read(p.stdout.fileno(),8192)
            if not buf:break
            transcript+=buf
    raise RuntimeError(f'timed out waiting for {needle!r}; output:\n{transcript[-3000:]!r}')
try:
    read_until(b'Franc compiler and shell self-compiled')
    read_until(b'FrancOS Stage 3 | shell written in Franc')
    read_until(b'Frac> ')
    print('PASS: BIOS boot -> 64-bit FracOS -> Franc-authored shell')
    tests=[(b'1/7 ~\n',b'0.(142857)'),
           (b'def sq dup * ;\n',b'Frac> '),
           (b'5 sq\n',b'25'),
           (b'0.1 0.2 + .\n',b'3/10'),
           (b'0 if0 42 else 9 then .\n',b'42'),
           (b'1/0 1 +\n',b'inf'),
           (b'0 clearfb\n',b'Frac> '),
           (b'10 20 14 pixel\n',b'Frac> '),
           (b'10 20 pixel@ .\n',b'14'),
           (b'1 2 1 3 tangent? .\n',b'1'),
           (b'"guest.frac" "def guest-square dup * ;" save\n',b'Frac> '),
           (b'"guest.frac" load\n',b'Frac> '),
           (b'9 guest-square .\n',b'81')]
    for command,result in tests:
        position=len(transcript)
        p.stdin.write(command);p.stdin.flush()
        # Require output after the current test starts, not stale output.
        deadline=time.monotonic()+18
        while time.monotonic()<deadline:
            if result in transcript[position:]:break
            events=sel.select(timeout=0.3)
            if events:
                data=os.read(p.stdout.fileno(),8192)
                if not data:break
                transcript+=data
        else:raise AssertionError(f'{command!r} did not produce {result!r}: {transcript[position:]!r}')
        print(f'PASS: {command.decode().strip()}')
    print('PASS: QEMU end-to-end smoke test')
except Exception as exc:
    print('FAIL:',exc,file=sys.stderr)
    print('QEMU return code:',p.poll(),file=sys.stderr)
    if trace_file.exists():
        print('QEMU diagnostic trace tail:',trace_file.read_text(errors='replace')[-10000:],file=sys.stderr)
    print('TRANSCRIPT:',transcript.decode(errors='replace'),file=sys.stderr)
    sys.exit(1)
finally:
    p.kill()
    p.wait()
