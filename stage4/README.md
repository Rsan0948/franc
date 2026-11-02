# Stage 4: first C-free native boot (experimental AOT bridge)

This is **not** the completed FrancOS migration. It is an independently bootable
kernel compiled from `kernel.frac` to native x86-64 with **no C source, C
object, libc, or C runtime** in the kernel binary or Stage 4 Makefile.

```sh
cd stage4
make
python3 test_compiler.py
python3 qemu_aot.py   # requires qemu-system-x86_64
```

The loader is the existing Stage 1 BIOS `.S` file; the kernel consists of
`runtime.S` plus assembly emitted from Franc source by `compiler.py` and linked
at **0x10000**. Runtime services are x86-64 assembly using 16-byte rational
stack entries and BIOS-selected Mode 13h. The OS image is the standard 256-sector
layout with reserved `FRANCFS1` data at LBAs 128-199. No C objects are linked.

Current *working subset*: definitions, strings, rational literals, signed
integer fractions, nested `if/if0/ifnz/else/then`, `begin/while/repeat/again`,
registers, console serial output, pixel/clear, byte memory and raw 8/16-bit I/O. The existing
Franc-written `stage3/ata.frac` ATA read/write driver is now compiled into this
C-free kernel; QEMU verifies a magic-byte read and sector write/readback.
Arithmetic normalizes 64-bit fractions and emits bottom on intermediate
multiplication overflow; **this does not yet guarantee every edge case of the
full Stage 0 arithmetic**.

The AOT build tool is **Python, not yet Franc**. Also not yet migrated: full
compiler/dictionary at runtime, the interactive REPL, the full Stage 3 storage
and graphical console stack, PS/2 input, complete persistent source filesystem,
interrupts, complete numeric tower, verified C-free *self-build*. These remain
mandatory work, not optional or done by the mere fact this image cold-boots.
The development branch retains the Stage 1/3 C-backed kernel as a fallback.

Security limitations: no isolation, no privilege separation, no stack checks
in the assembly primitives. Fixed, single-user x86-64/BIOS demonstration only.

## Native console and keyboard migration (experimental)

The next standalone image links the DejaVu-derived bitmap font as assembly data
(`font.S`), and its screen character cells, glyph loops, scroll policy and
character output are implemented in `display.frac` using byte memory operations.
`keyboard.frac` owns serial/PS2 polling and scancode translation. An interactive
Franc menu is started after the AOT boot checks; CI sends real COM1 key events
(`p`, `s`, `g`, `Esc`) into the emulated machine. The immutable binary continues
to use Franc's ATA read/write driver and source-store module.

**Important limitations:** the interactive menu is not a source-code REPL. The
compiler for this image is still `compiler.py` (build-time Python), and the
native kernel lacks a runtime Franc source compiler, dynamic dictionary and
multiple numerical/graphics primitives from the older JIT. There are no C
objects in this image, but this is not a fully self-hosting no-Python build.
The complete transition requires a Franc-authored native AOT compiler able to
build the full OS, plus runtime dictionary and compilation support. Do not
confuse this tested fixed-program image with that end state.
