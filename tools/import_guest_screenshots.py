#!/usr/bin/env python3
"""Import *real* QEMU PPM screenshots from pinned, verified CI artifacts.

This is a host-side, dependency-free release-media tool; it never draws a
representation of FrancOS or modifies the running guest. Every input has an
exact SHA-256 to prevent accidentally publishing a different screenshot.
"""
from __future__ import annotations

import hashlib
from pathlib import Path
import re
import struct
import sys
import zlib

# (relative source path, committed PNG name, SHA-256 of QEMU PPM, dimensions)
SOURCES = (
    ("gop-latest/uefi-gop-home.ppm", "home-uefi-1024x768.png",
     "dc55260d9a80ac50ede046b3595b4042548bc3ac4732e1033d7c57e0b44fbbe5", (1024, 768)),
    ("gop-original/uefi-gop-home.ppm", "home-uefi-initial-1024x768.png",
     "fc2e9681bbe74578abe2a2f4266d9e882cbceee0b132a1c647dc0f428e898f25", (1024, 768)),
    ("bios-ui/home.ppm", "home-bios-640x400.png",
     "3f26bdc5adcc613fa36b7516427bb4959ebfd27a73fd003c85065c3ae2c2801a", (640, 400)),
    ("bios-ui/ide.ppm", "ide-bios-640x400.png",
     "41f3caa1aa957df68e49840a30f1692d4301fc65ad3fcda685b867162b857e93", (640, 400)),
    ("bios-ui/files.ppm", "files-bios-640x400.png",
     "34ab955d6e7684e94b9ed0330a26a3acf79b5b4518e87cc672f68794b1c085f1", (640, 400)),
    ("bios-ui/packages.ppm", "packages-bios-640x400.png",
     "61a0e0fb0b02a5b00c3e23159c7b03b917f814d065ceb8d928a1aee8b177c4f4", (640, 400)),
)


def chunk(kind: bytes, payload: bytes) -> bytes:
    return (struct.pack(">I", len(payload)) + kind + payload
            + struct.pack(">I", zlib.crc32(kind + payload) & 0xFFFFFFFF))


def convert_ppm(raw: bytes, expected_size: tuple[int, int]) -> bytes:
    header = re.match(rb"P6\s+(\d+)\s+(\d+)\s+255\s", raw)
    if not header:
        raise ValueError("Not a binary QEMU RGB PPM screenshot")
    width, height = map(int, header.groups())
    if (width, height) != expected_size:
        raise ValueError(f"Wrong screenshot dimensions: {width}x{height}")
    pixels = raw[header.end():]
    pitch = width * 3
    if len(pixels) != pitch * height:
        raise ValueError("Missing or extra framebuffer pixels")
    # Real glyphs must appear inside the intended guest display; nonblack
    # firmware border pixels alone don't qualify as a screen capture.
    hits = 0
    for y in range(32, min(height, 280), 4):
        for x in range(32, min(width, 640), 4):
            n = y * pitch + x * 3
            hits += any(pixels[n:n + 3])
    if hits < 60:
        raise ValueError(f"Framebuffer interior too empty: {hits} samples")
    scanlines = bytearray((pitch + 1) * height)
    for y in range(height):
        start = y * (pitch + 1)
        scanlines[start + 1:start + pitch + 1] = pixels[y * pitch:(y + 1) * pitch]
    ihdr = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)
    return (b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr)
            + chunk(b"IDAT", zlib.compress(scanlines, 9))
            + chunk(b"IEND", b""))


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("usage: import_guest_screenshots.py ARTIFACT_DIR OUTPUT_DIR")
    source_dir, output_dir = (Path(p) for p in sys.argv[1:])
    output_dir.mkdir(parents=True, exist_ok=True)
    sums = []
    for source, name, expected_hash, dims in SOURCES:
        raw = (source_dir / source).read_bytes()
        actual = hashlib.sha256(raw).hexdigest()
        if actual != expected_hash:
            raise ValueError(f"Unexpected artifact contents: {source}, SHA-256 {actual}")
        encoded = convert_ppm(raw, dims)
        (output_dir / name).write_bytes(encoded)
        digest = hashlib.sha256(encoded).hexdigest()
        sums.append(f"{digest}  {name}")
        print(f"Verified guest screenshot: {name}, {dims[0]}x{dims[1]}, "
              f"{len(encoded)} bytes, SHA-256 {digest}", flush=True)
    (output_dir / "SHA256SUMS").write_text("\n".join(sums) + "\n", encoding="ascii")


if __name__ == "__main__":
    main()
