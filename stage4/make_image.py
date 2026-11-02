#!/usr/bin/env python3
"""Build raw BIOS disk. Keep exactly the stage1 two-part layout.
LBA 1-127 (127*512 bytes), LBA 128-199 reserved FS, LBA 200-255 tail.
"""
import sys
from pathlib import Path
boot,kernel,output=map(Path,sys.argv[1:])
b=boot.read_bytes(); k=kernel.read_bytes()
assert len(b)==512 and b[-2:]==b'\x55\xaa'
assert len(k)<=183*512, f'AOT kernel too large: {len(k)}'
img=bytearray(256*512)
img[:512]=b
img[512:512+min(len(k),127*512)]=k[:127*512]
img[200*512:200*512+len(k[127*512:])]=k[127*512:]
img[128*512:128*512+8]=b'FRANCFS1'
output.write_bytes(img)
