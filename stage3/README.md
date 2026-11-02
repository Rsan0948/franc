# Stage 3 — Franc-owned I/O and source storage

Franc now owns the keyboard state machine (`drivers.frac`), ATA PIO sector
read **and write** (`ata.frac`), source store directory and serialization
(`storage.frac`), framebuffer rendering, ASCII glyph rasterization, console
state and COM1 output (`display.frac`), and the shell (`shell.frac`).

The C/assembly substrate still provides raw port I/O (io8@/io8!/io16@/
io16!), bounded byte-array access for one ATA sector and source buffer,
frame@/frame!, access to the 8×8 font data, and bootstrap services.
In particular, C arithmetic, the first-stage JIT/dictionary, early boot
output, and error printing remain. This is **not** a zero-C kernel.

## Storage

The Franc module uses the established FRANCFS1 layout: header at sector
128, directory at 129, 12 slots, four sectors each starting at 136. A
write is restricted to sectors 128–199, protecting the kernel and its
second BIOS-loaded segment at sectors 200–255. File writes publish the
directory entry after data sectors; replacement is not power-loss atomic.
All on-disk data is opt-in through a valid FRANCFS1 header; `fs-format`
is an explicit destructive operation. The hosted build delegates source
operations to the previously tested opt-in file-backed adapter.

`fs-save` accepts `(name-addr source-addr -- success)`, `fs-source` accepts
`(name-addr -- source-addr-or-zero)`, and `fs-files` lists filenames. Public
`save`, `source`, and `files` words are shadowed by Franc implementations.
The existing `load` word compiles the result through the Franc compiler.

## Display

`pixel`, `pixel@`, `clearfb`, `fillrect`, `line`, `emit`, `type`, and `home`
are shadowed by Franc implementations. The byte-level framebuffer access
and public-domain font lookup remain hardware/ABI primitives, pending the
C-free AOT milestone. Host tests check pixels, glyphs and screenshots.

## Boot image

The added Franc sources exceed the old 127-sector kernel maximum. BIOS
now loads 127 sectors at LBA 1 plus 56 more sectors from LBA 200, leaving
FRANCFS1's LBA 128–199 unchanged. The image is still 256 sectors (128 KiB).

QEMU CI must verify guest execution of the new Franc ATA write, reload,
source-file storage, graphics and console paths. Without that CI evidence
only the host tests and image-structure checks may be claimed.

`docs/C_FREE_EXIT_CRITERIA.md` remains the final acceptance condition.
