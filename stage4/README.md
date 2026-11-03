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

The **seed AOT build tools remain Python** (`compiler.py`, `make_image.py`).
However, the standalone C-free image now runs a Franc-native JIT compiler,
a mutable dictionary, a Franc interactive REPL, Franc ATA/source storage,
framebuffer text output and keyboard policy. Runtime compiler self-recompilation
through two generations and an on-disk startup file executed after cold reboot
are verified in QEMU CI.

**Still incomplete:** Franc-authored standalone AOT image emission and a
repeatable compiler/kernel rebuild without Python; full Stage 0 primitive and
numeric compatibility; dynamic creation of arbitrary new named registers;
hardware and corruption-edge-case tests, interrupt support and broader hardware
targets. The Stage 1/3 C-backed kernel remains an intentionally separate fallback.

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

**Important limitations:** the menu now includes a native source-code REPL
(`r`) and compiler self-rebuild diagnostic (`b`). They run Franc's native
JIT at runtime. The original `compiler.py` remains the *build-time* compiler
for creating the initial bootable image. Therefore the standalone runtime is
self-compiling but its image-generation toolchain is not yet self-hosted.
Do not confuse runtime self-compilation with a Python-free cold image rebuild.

## Experimental runtime native compiler bridge

The C-free image now embeds the Franc-authored Stage 2 compiler, with a
machine-code dictionary and allocation bridge implemented in x86-64 assembly.
The initial static dictionary contains AOT definitions and primitive entry
addresses; new compiled words are installed in a bounded mutable dictionary.
This is **native JIT compilation inside the C-free kernel**, but not yet a
Franc-authored AOT image compiler or completely independent rebuild path.
The QEMU startup probe exercises dynamic expressions and a new definition.

## Interactive native Franc REPL (experimental)

The C-free Stage 4 console now accepts `r` to enter `repl.frac`, a line
editor and evaluation loop implemented entirely in Franc. Each submitted line
passes through Stage 2's Franc-written x86-64 compiler, with newly compiled
definitions entered into the mutable dictionary. Esc returns to the original
hardware diagnostics menu. The REPL currently accepts up to 255 input bytes
per line and is not a general-purpose filesystem editor. The on-device native
compiler is distinct from the Python image compiler still used at build time.

## Self-recompilation proof gate (experimental)

Choose `b` at the C-free diagnostics menu to load the embedded Stage 2 Franc
compiler source and recompile it through generation two, then generation three.
The smoke test checks both generation counts, executes a resulting native
program, and requires a `SELFHOST OK` marker. This establishes runtime JIT
compiler self-compilation only; producing a new bootable disk image still
uses the host-side Python `compiler.py` and assembler/linker.

The AOT compiler generates primitive dictionary entries for each named register
referenced in its Franc sources. These assembly accessors let the native Stage 2
compiler resolve register reads and writes while recompiling itself. Arbitrary
new register names entered at runtime still need dynamic registration support.

## Persisted Franc startup without an external rebuild

When the source store contains `startup.frac`, the C-free kernel now compiles
its definitions with the resident Franc native compiler. A **freshly defined**
`startup-main` word runs once during boot; no stale entry is invoked. The CI
smoke test saves this Franc source through the interactive REPL, stops QEMU,
boots the same writable disk image again, and expects the startup word to run.
This is runtime source-driven startup; the immutable seed image itself is still
created by the host Python AOT bridge and GNU assembly tools. Startup programs
execute with kernel privileges and must be trusted.

## Franc-generated relocatable AOT assembly (first supported subset)

Run `a` from the standalone FrancOS menu to use `stage4/aot.frac`.
The Franc-authored compiler emits **GNU x86-64 relocatable assembly source**
through COM1. GitHub Actions extracts and assembles the output with `as`,
checking the exported entry symbol and external primitive references.
This first compiler supports bounded signed 32-bit rational literals and
`+ - * / dup drop swap over .` in straight-line expressions; there is no
control flow, new definitions, data emission, kernel relocation or image
writer yet. It does not replace `stage4/compiler.py` for the full OS build.
