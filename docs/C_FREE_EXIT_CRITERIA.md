# Required final milestone: zero C

> Development record: the early native-bootstrap goals. For the current system,
> start with the [project overview](../README.md) and [build guide](BUILD_AND_TEST.md).

**Non-negotiable project objective:** the release candidate must boot, rebuild,
and operate without any C code, C compiler, C runtime objects, or C-derived
machine-code helpers. The current Stage 3 image does **not** meet this goal.
This document distinguishes the *language of the runtime* from the *language
of the build tools*, and makes both independently testable.

## Current dependency boundary (Stage 3)

- BIOS boot and 64-bit entry: x86 assembly (`stage1/boot.S`, `entry.S`).
- C still implements initialization, console output, heap, executable-memory
  allocation, Rat arithmetic, dictionary entry management and JIT bootstrap.
- Franc now owns the Stage 3 input driver logic (COM1/PS/2), keyboard scancode
  conversion, interactive line editor, shell and Stage 2 source compilation.
- `stage3/ata.frac` is a **read-only** ATA PIO prototype; validated sector
  writes and the persistent file store still use the C path.
- `gfx.c` still owns framebuffer pixels, glyph rasterization and scrolling.
- `stage3/shell.frac` takes over after initial C setup; Esc returns to the C
  diagnostic REPL. Do not describe this as a C-free kernel.

## Required milestones, in order

1. **Franc-owned kernel services.** Complete and QEMU-test Franc-driven serial,
   PS/2 input, ATA read/write with bounds and error handling, framebuffer and
   console; move source storage and application lifecycle policy into Franc.
   Keep the original boot path as a known-good fallback during migration.
2. **Freestanding native primitive replacement.** Implement Rat arithmetic,
   stack, string/memory and dictionary mechanics as Franc-generated code plus
   the minimum architecture-specific assembly. Eliminate all calls from emitted
   Franc code to C function addresses. Model numeric overflow explicitly.
3. **Franc AOT object/flat-image emitter.** Emit relocatable references or
   fixed image-relative addresses, resolve internal and external symbols,
   initialize static data/BSS, and write a complete image with a known entry
   point and verifiable size. Never dump absolute JIT helper addresses as an
   alleged standalone executable.
4. **Reproducible cold bootstrap.** A documented seed compiler builds a newer
   Franc compiler, which builds its own source and a Franc kernel. Compare
   successive generations by executable behavior and, where deterministic,
   bytes. Compiler stage-0 seed must be replaceable by a Franc/assembly-only
   build before declaring C removed from the toolchain.
5. **C-free boot.** Boot only an assembly loader + Franc-generated image on
   QEMU TCG, no C objects in the image. Preserve source save/load and reboot
   persistence, self-recompilation, graphics, keyboard, and error recovery.
6. **C-free repository verification.** `make`/CI must build a working image
   without running a C compiler; no `.c` compilation or C library linking.
   Historical C implementations may remain in `archaeology/` but must not be
   inputs to build, boot or self-hosting. The link map and symbol scan must
   show no references to C helpers. The final binary must reproducibly boot.

## Proof gates

- Unit and differential tests for arithmetic, port I/O, parsing, compiler
  self-hosting and file-system corruption/limits.
- QEMU TCG serial transcripts and keyboard injection for every migrated driver.
- ATA round-trip with a **disposable** disk image, followed by a cold reboot.
- Video RAM pixel checks and framebuffer screenshot comparisons in QEMU.
- Two-generation compiler rebuild and a third-generation native program.
- Explicit CI assertion that the final build invokes no C compiler and links
  no C object or libc; no claim of completion until this assertion passes.

## Scope and hardware limits

Initial target is BIOS x86-64 under QEMU with PS/2, COM1 and legacy IDE.
UEFI-only and USB-only real machines need their own firmware and hardware
support and are not implied by QEMU success. Interrupt-entry stubs must save
x86-64 registers and return with `iretq`; legacy `pusha/popa` are invalid in
long mode. A tiny hand-written assembly loader is permissible. **C is not.**

## Stage 4 experimental branch — verified implementation snapshot

At commit `9e77da1` on `stage4-cfree-aot`, the dedicated QEMU workflow passed:

- The kernel image links only x86-64 assembly runtime/boot objects and
  machine code compiled from Franc, without C object files, libc or a C runtime.
- Franc's Stage 2 native compiler runs within that standalone image using a
  bounded assembly-backed executable arena and mutable word dictionary.
- Named-register accessors for AOT-known Franc sources are exposed in the
  native dictionary; two successive compiler self-recompilation generations
  are verified and a third-generation native program executes.
- The Franc-authored interactive REPL compiles user input and definitions.
- Franc ATA read/write, source filesystem, framebuffer console and serial
  input work in QEMU. A saved `startup.frac` survives a full QEMU cold
  reboot, is natively recompiled, and executes `startup-main`.

**Not yet an exit:** the initial bootable image still requires the Python
`stage4/compiler.py` AOT translation and `stage4/make_image.py` layout
generator. GNU assembler/linker are intentional, allowed x86-64 toolchain
components. A complete Franc-based AOT compiler, deterministic native image
writer, independent bootstrap and C/Python-free rebuild proof are still
required before claiming full dependency elimination. Stage 0/1/3 C code is
retained solely in the fallback/historical build path, not in the Stage 4
standalone kernel.
