#!/usr/bin/env python3
"""Proof gate: feed the complete FrancOS source tree to Franc's native AOT."""
from pathlib import Path
import os
import re
import selectors
import shutil
import subprocess
import tempfile
import time

root = Path(__file__).resolve().parent
repo = root.parent
sources = [
    repo/'stage3/ata.frac',repo/'stage3/storage.frac',
    root/'display.frac',root/'keyboard.frac',
    repo/'stage2/compiler.frac',root/'repl.frac',root/'upgrade.frac',
    root/'aot.frac',root/'bundle.frac',root/'kernel.frac'
]
qemu=shutil.which('qemu-system-x86_64')
assert qemu, 'QEMU is needed for native Franc compiler proof'
with tempfile.TemporaryDirectory(prefix='franc-selfhost-') as tmp:
    scratch=Path(tmp)
    disk=scratch/'seed.img'
    shutil.copyfile(root/'franos-aot.img',disk)
    subprocess.run(['sh',str(root/'source_pack.sh'),str(disk),
                    *[str(path) for path in sources]],check=True)
    guest=subprocess.Popen([
        qemu,'-m','128M','-accel','tcg','-display','none','-monitor','none',
        '-no-reboot','-serial','stdio',
        '-drive',f'file={disk},format=raw,if=ide'
    ],stdin=subprocess.PIPE,stdout=subprocess.PIPE,
       stderr=subprocess.STDOUT,bufsize=0)
    output=b''
    poll=selectors.DefaultSelector()
    poll.register(guest.stdout,selectors.EVENT_READ)
    def read_until(marker,timeout):
        global output
        end=time.monotonic()+timeout
        while marker not in output and time.monotonic()<end:
            if guest.poll() is not None:
                break
            if poll.select(0.2):
                chunk=os.read(guest.stdout.fileno(),65536)
                if not chunk:break
                output+=chunk
        assert marker in output, (
            f"missing {marker!r}; tail={output[-2000:]!r}")
    try:
        read_until(b'Franc> ',180)
        os.write(guest.stdin.fileno(),b'k')
        read_until(b'FRANC-KERNEL-END',360)
        assert b'FRANC-KERNEL-SOURCE-ERROR' not in output,output[-2000:]
        assert b'FRANC-PROGRAM-ERROR' not in output,output[-2000:]
        block=re.search(rb'FRANC-PROGRAM-BEGIN\n(.*?)FRANC-PROGRAM-END\n',output,re.S)
        assert block,output[-2000:]
        assembly=block.group(1).decode('ascii')
        assert 'call fw_626f6f74' in assembly,assembly[:1000]
        assert 'fw_626f6f74:' in assembly,assembly[-3000:]
        assert 'fw_73322d636f6d70696c65:' in assembly, (
            'Stage 2 self-host Franc compiler not present')
        native=scratch/'kernel-from-franc.S'
        native.write_text(assembly)
        obj=scratch/'kernel-from-franc.o'
        subprocess.run(['as','--64','-o',str(obj),str(native)],check=True)
        sym=subprocess.check_output(['nm',str(obj)],text=True)
        assert 'T franc_aot_entry' in sym and 'fw_626f6f74' in sym,sym[-2000:]
        print(f'PASS: Franc emitted and GNU as assembled full kernel source '
              f'({len(assembly)} assembly bytes, {len(sources)} Franc files)')
    finally:
        guest.kill()
        guest.wait()
