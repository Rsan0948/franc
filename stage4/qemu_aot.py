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
    for marker in [b'FrancOS AOT | 64-bit | no C runtime',b'1/2',b'25',b'BRANCH OK',b'3\n',b'70\n',b'42\n',b'ATA WRITE READBACK DONE',b'JIT-SUM 5\n',b'JIT-DEF 36\n',b'def saved 77 ;',b'STORAGE OK',b'AOT BOOT OK']:
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
        (b'r', b'Franc REPL | Esc returns to menu\nFrac> ')
    ]:
        # COM1 has a single-byte receive register. Wait for the Franc
        # polling loop to re-enter input mode after drawing the prompt.
        time.sleep(0.5)
        offset = len(transcript)
        os.write(p.stdin.fileno(), key)
        transcript = read_until(expected, timeout=45, after=offset)
    # The interactive REPL uses Franc's own Stage 2 native-code emitter.
    # COM1 has only a single-byte receive register, so wait for echoed input.
    for source, expected in [(b'2 3 +\n', b'5\nFrac> '),
                             (b'def n 7 ;\n', b'Frac> '),
                             (b'n 6 *\n', b'42\nFrac> '),
                             (b'"startup.frac" "def startup-main 99 . ;" fs-save\n', b'1\nFrac> ')]:
        for ch in source:
            time.sleep(0.12)
            offset = len(transcript)
            os.write(p.stdin.fileno(), bytes([ch]))
            if ch == 10:
                transcript = read_until(expected, timeout=45, after=offset)
            else:
                transcript = read_until(bytes([ch]), timeout=15, after=offset)
    for marker in [b'JIT-SUM 5\n', b'JIT-DEF 36\n']:
        assert marker in transcript, f'missing {marker!r}'
    for key, expected in [(b'\x1b', b'Franc> '),
                          (b'b', b'SELFHOST OK\nFranc> '),
                          (b'\x1b', b'EXIT CONSOLE')]:
        time.sleep(0.5)
        offset = len(transcript)
        os.write(p.stdin.fileno(), key)
        transcript = read_until(expected, timeout=150 if key == b'b' else 45, after=offset)
    for marker in [b'SELFHOST START\n', b'GEN 2: 29\n', b'GEN 3: 29\n', b'42\n', b'SELFHOST OK\n']:
        assert marker in transcript, f'missing {marker!r}: {transcript!r}'
    assert b'stage2: unsupported token' not in transcript, transcript
    for marker in (b'FRANC FRAMEBUFFER READY', b'FRANC INTERACTIVE READY',
                   b'GRAPHICS IN FRANC', b'EXIT CONSOLE'):
        assert marker in transcript, f'missing {marker!r}: {transcript!r}'
    assert transcript.count(b'1/2') >= 2, transcript
    print('PASS: C-free cold boot, Franc framebuffer console, serial keyboard and storage')
finally:
    p.kill();p.wait()

# A second BIOS cold boot must discover and compile the source persisted
# by the first guest, without regenerating the disk or running a C compiler.
p2 = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                      stderr=subprocess.STDOUT, bufsize=0)
sel2 = selectors.DefaultSelector()
sel2.register(p2.stdout, selectors.EVENT_READ)
reboot_output = b''
try:
    deadline = time.monotonic()+150
    while time.monotonic() < deadline:
        if b'99\nAOT BOOT OK' in reboot_output and b'Franc> ' in reboot_output:
            break
        if p2.poll() is not None:
            break
        if sel2.select(0.3):
            data = os.read(p2.stdout.fileno(), 8192)
            if not data:
                break
            reboot_output += data
    assert b'99\nAOT BOOT OK' in reboot_output, (
        'persisted Franc startup not compiled/executed after cold reboot: '
        + repr(reboot_output))
    assert b'Franc> ' in reboot_output, reboot_output
    print('PASS: second cold boot native-compiles and executes saved Franc startup source')
finally:
    p2.kill()
    p2.wait()
