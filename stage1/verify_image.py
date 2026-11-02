#!/usr/bin/env python3
"""Offline checks for the Stage 1 raw BIOS image; not a substitute for boot testing."""
from pathlib import Path
import struct
root=Path(__file__).resolve().parent
boot=(root/'boot.bin').read_bytes()
kernel=(root/'kernel.bin').read_bytes()
image=(root/'fracos.img').read_bytes()
assert len(boot)==512, f'bootloader must be 512 bytes, got {len(boot)}'
assert boot[510:512]==b'\x55\xaa','BIOS boot signature missing'
assert len(kernel)<=127*512, 'kernel too large for BIOS read'
assert len(image)==256*512, 'disk image must include a reserved 128-sector source store'
assert image[512:512+len(kernel)]==kernel
assert image[512+len(kernel):128*512]==b'\x00'*(127*512-len(kernel))
assert image[128*512:128*512+8]==b'FRANCFS1', 'persistent source store header missing'
assert image[129*512:130*512]==bytes(512), 'directory should start empty'
assert image[130*512:]==bytes(126*512), 'source data should start empty'
assert boot[-2:]==b'\x55\xaa'
# The 64-bit kernel uses a downward-growing stack starting at 0x80000.
# Check that data/BSS remain well below the stack with some headroom.
import subprocess
syms=subprocess.check_output(['nm', '-n', str(root/'kernel.elf')],text=True)
bss_end=next(int(line.split()[0],16) for line in syms.splitlines() if line.endswith(' __bss_end'))
assert bss_end < 0x70000, f'kernel BSS encroaches on stack: {bss_end:#x}'

print(f'PASS: BIOS image structure ({len(image)} bytes, kernel {len(kernel)} bytes)')
print('NOTE: this validates disk layout, not CPU boot execution.')
