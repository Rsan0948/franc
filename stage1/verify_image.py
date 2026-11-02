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
assert len(image)==128*512, 'disk image should contain boot plus 127 kernel sectors'
assert image[512:512+len(kernel)]==kernel
assert image[512+len(kernel):]==b'\x00'*(127*512-len(kernel))
assert boot[-2:]==b'\x55\xaa'
print(f'PASS: BIOS image structure ({len(image)} bytes, kernel {len(kernel)} bytes)')
print('NOTE: this validates disk layout, not CPU boot execution.')
