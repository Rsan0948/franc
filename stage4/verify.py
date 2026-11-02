#!/usr/bin/env python3
from pathlib import Path
import re, subprocess
s=Path(__file__).resolve().parent
img=(s/'franos-aot.img').read_bytes()
assert len(img)==128*1024
assert img[510:512]==b'\x55\xaa'
assert img[128*512:128*512+8]==b'FRANCFS1'
# Require image's entry address and all linked symbols to come from assembler.
symbols=subprocess.check_output(['nm','-n',str(s/'kernel.elf')],text=True)
assert re.search(r'0000000000010000 T _kstart',symbols),symbols[:900]
# Don't accidentally link C-built objects; this target owns its entire link list.
makefile=(s/'Makefile').read_text()
assert 'gcc' not in makefile and '.c ' not in makefile
print('PASS: 128 KiB C-free AOT boot image, boot signature, protected storage layout, entry 0x10000')
