#!/usr/bin/env python3
"""Validate packed Franctxt files in native FRANCFS1 without launching QEMU."""
from pathlib import Path
import sys
from franctxt import FranctxtError, canonical, digest, parse, validate_kernel
from franctxt.__main__ import verify_kernel_image

if len(sys.argv) != 3:
    raise SystemExit("usage: python3 franctxt/tests/test_native_disk.py IMAGE KERNEL")
image = Path(sys.argv[1]).read_bytes()
kernel = Path(sys.argv[2]).read_bytes()
assert image[128 * 512:128 * 512 + 8] == b"FRANCFS1"
found = {}
for slot in range(12):
    entry = image[129 * 512 + slot * 32:129 * 512 + (slot + 1) * 32]
    name = entry[:24].split(b"\0", 1)[0].decode("ascii")
    if not name:
        continue
    size = int.from_bytes(entry[24:26], "little")
    assert 0 < size < 2048, (name, size)
    offset = (136 + slot * 4) * 512
    payload = image[offset:offset + size]
    assert len(payload) == size and not payload.endswith(b"\0")
    assert canonical(parse(payload)) == payload, f"{name} not canonical"
    found[name] = payload

assert "kernel.franctxt" in found and "system.franctxt" in found
manifest, config = found["kernel.franctxt"], found["system.franctxt"]
validate_kernel(parse(config))
assert verify_kernel_image(manifest, kernel), "kernel SHA-256 digest mismatch"
assert parse(manifest)["build.config-sha256"] == digest(config)
assert parse(manifest)["schema"] == "francos.kernel-build.v1"
print("PASS: native FRANCFS1 stores canonical Franctxt config and kernel identity")
print("PASS: persisted manifest binds actual kernel bytes and initial configuration")
print("kernel identity: " + parse(manifest)["build.kernel-sha256"])
print("config identity: " + digest(config))
