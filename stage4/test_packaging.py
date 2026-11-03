#!/usr/bin/env python3
"""Differential regression only: the actual disk image is built without Python."""
from pathlib import Path
import subprocess
import sys
import tempfile

root = Path(__file__).resolve().parent
actual = (root / 'franos-aot.img').read_bytes()
with tempfile.TemporaryDirectory(prefix='franc-pack-reference-') as tmp:
    reference = Path(tmp) / 'reference.img'
    subprocess.run([
        sys.executable, str(root / 'make_image.py'),
        str(root / 'boot.bin'), str(root / 'kernel.bin'), str(reference)
    ], check=True)
    expected = reference.read_bytes()
assert actual == expected, 'GNU dd output differs from reference image'
print('PASS: no-Python disk packer matches legacy Python image byte-for-byte')
