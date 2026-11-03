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
        # Identify unresolved AOT relocation classes if the link fails.
        all_syms=subprocess.check_output(['nm',str(obj)],text=True)
        native_names=[line for line in assembly.splitlines()
                      if line.startswith('aot_get_') or line.startswith('aot_set_')]
        print(f'DEBUG: native register shims: {len(native_names)}, '
              f'sample={native_names[:8]}',flush=True)
        print('DEBUG: unresolved AOT sample: '
              +repr([line for line in all_syms.splitlines()
                     if ' U ' in line][:18]),flush=True)
        # Link the complete Franc-generated kernel, without compiler.py or
        # any other Python language translator. The runtime and font are
        # permitted assembler-only objects.
        native_elf=scratch/'gen2.elf'
        native_bin=scratch/'gen2.bin'
        subprocess.run([
            'ld','-m','elf_x86_64','-nostdlib',
            '-T',str(root/'kernel.ld'),'-o',str(native_elf),
            str(root/'runtime.o'),str(root/'font.o'),str(obj)
        ],check=True)
        subprocess.run([
            'objcopy','-O','binary','-j','.text','-j','.rodata',
            '-j','.data',str(native_elf),str(native_bin)
        ],check=True)
        assert 0 < native_bin.stat().st_size <= 310*512, (
            f'Franc-native full kernel exceeds 310-sector loader capacity: '
            f'{native_bin.stat().st_size} bytes')
        print(f'PASS: full Franc-native AOT kernel linked '
              f'({native_bin.stat().st_size} bytes, zero C/Python compiler objects)')

        # Preserve source bundle at LBA 513+ and file store at 128..199.
        # Install native kernel into the exact extents the BIOS bootloader reads.
        gen2=scratch/'gen2.img'
        shutil.copyfile(disk,gen2)
        for seek,count in [(1,127),(200,56),(256,127)]:
            subprocess.run(['dd','if=/dev/zero',f'of={gen2}','bs=512',
                            f'seek={seek}',f'count={count}','conv=notrunc',
                            'status=none'],check=True)
        for seek,count,skip in [(1,127,0),(200,56,127),(256,127,183)]:
            subprocess.run(['dd',f'if={native_bin}',f'of={gen2}','bs=512',
                            f'seek={seek}',f'count={count}',f'skip={skip}',
                            'conv=notrunc','status=none'],check=True)
        next_guest=subprocess.Popen([
            qemu,'-m','128M','-accel','tcg','-display','none','-monitor','none',
            '-no-reboot','-serial','stdio',
            '-drive',f'file={gen2},format=raw,if=ide'
        ],stdin=subprocess.PIPE,stdout=subprocess.PIPE,
           stderr=subprocess.STDOUT,bufsize=0)
        next_output=b''
        next_poll=selectors.DefaultSelector()
        next_poll.register(next_guest.stdout,selectors.EVENT_READ)
        try:
            deadline=time.monotonic()+180
            while time.monotonic()<deadline and b'AOT BOOT OK' not in next_output:
                if next_guest.poll() is not None:break
                if next_poll.select(0.2):
                    data=os.read(next_guest.stdout.fileno(),65536)
                    if not data:break
                    next_output+=data
            assert b'AOT BOOT OK' in next_output and b'Franc> ' in next_output, (
                'Full Franc-compiled generation-2 kernel failed cold boot: '
                +repr(next_output[-2500:]))
            assert b'JIT-SUM 5\n' in next_output, next_output[-2000:]
            assert b'JIT-DEF 36\n' in next_output, next_output[-2000:]
            print('PASS: full Franc-native generation-2 kernel cold boots '
                  'with interactive JIT compiler functional')
        finally:
            next_guest.kill()
            next_guest.wait()
        print(f'PASS: Franc emitted and GNU as assembled full kernel source '
              f'({len(assembly)} assembly bytes, {len(sources)} Franc files)')
    finally:
        guest.kill()
        guest.wait()
