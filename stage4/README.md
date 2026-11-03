# Stage 4 — Native, self-hosting FrancOS (development branch)

**Current status (2026-11-02):** FrancOS cold-boots as a C-free
x86-64 kernel, runs the Franc native JIT and interactive console,
compiles **all 11 Franc kernel source modules** into relocatable x86-64
assembly, and produces a second and third identical generation of the
OS. The committed Franc-produced seed is independently rebuildable
with no C or Python compiler calls. The original twelve Franc libraries
and apps are also shipped on a separate disk bundle, loaded by Franc's
JIT, and exercised by QEMU integration tests.

The native kernel is **124,592 bytes**. The boot source's Franc-produced
assembly is **658,558 bytes**, compared byte-for-byte with the
committed `bootstrap_seed.S`. Verified kernel SHA-256:
`ca92072d6f649f2af4249e52123b140e0aba6295034550fce883c6a5a7cace89`.

## Build

From the repository root:

```sh
# Production, reproducible Franc/assembly-only build:
make -C stage4

# Explicit rebuild proof (same as default):
make -f stage4/Makefile.native native-proof

# Historical Python AOT comparison, not a production dependency:
make -C stage4 legacy-all

# Run the native image (requires QEMU):
qemu-system-x86_64 -m 128M -accel tcg -display none \
  -monitor none -no-reboot -serial stdio \
  -drive file=stage4/native_seed.img,format=raw,if=ide
```

Tools required for the native path: GNU `as`, `ld`, `objcopy`,
`make`, `bash`, `sh`, `awk`, `dd`, and QEMU x86-64.
Python is present in the repository's **testing/historical** code,
but never invoked by the native build. No C object files, libc,
C runtime or C compiler are part of the native kernel or bootstrap.
This does not imply that a custom Franc assembler/linker exists yet.

## Kernel architecture

- **`boot.S`:** 512-byte BIOS loader, kernel sector extents,
  Mode 13h setup, A20/GDT, identity-mapped paging and x86-64 long mode.
- **`runtime.S`:** Assembly CPU and ABI bridge, rational stack and
  arithmetic, native JIT allocation, mutable dictionary, low-level
  byte access, COM1 and ATA port operations.
- **`stage3/ata.frac` + `stage3/storage.frac`:** Franc-written PIO
  IDE read/write driver and the fixed 12-file `FRANCFS1` source store.
- **`display.frac` + `keyboard.frac`:** Franc-written framebuffer
  character console, glyphs, scrolling, COM1 and PS/2 input.
- **`stage2/compiler.frac` + `repl.frac`:** Native x86-64
  runtime JIT, mutable dictionary, interactive source compilation.
- **`upgrade.frac`:** Recompile and execute persistent `startup.frac`
  when a fresh `startup-main` definition exists after cold boot.
- **`aot.frac` + `bundle.frac`:** Relocatable AOT emission,
  metadata/dictionary generation and disk-staged source input.
- **`apps/registry.frac`:** Static register shims for the JIT-loaded
  application suite. These are metadata, not apps linked into the kernel.
- **`kernel.frac`:** Boot flow, diagnostics console, application loader
  and Franc-specific application dispatch.

The kernel is single-user and single-address-space. User definitions
execute as machine code with kernel privileges. The runtime uses fixed
buffers, global named registers and 64-bit rational numerator/denominator
cells, with incomplete parity against the mature hosted Stage 0
arithmetic and runtime.

## Applications and packages

Press **l** in the native `Franc>` console to compile the twelve existing
`lib/*.frac` modules from disk using the native JIT. Press **1–8**
afterwards to launch FracCalc, the source editor, Stern–Brocot
navigator, crosshair, Ford circles, spirograph, and numerical demos.
The `r` key launches the Franc REPL; any loaded library definition
can be used from there.

The **[complete native apps inventory](apps/README.md)** documents
every source module, entrypoint, bundled dependency and remaining
hosted-only behavior. The independent QEMU app workflow verifies
interactive calculator arithmetic, source editing and persistence,
continued fractions, intervals, two-component rational values,
trigonometry, exact powers, rational exploration and native drawing.
Targeted Ford-circle and spirograph QEMU tests now execute the actual
Franc drawing routines and verify resulting VGA pixel colors. Full-scene
screenshots and all interactive graphics paths are not exhaustively verified.

The application bundle is staged at disk LBA 1024. The kernel
recompilation source bundle remains at LBA 512; persistent data uses
LBA 128–199. The assembly bootloader supports the fixed kernel
region spread across LBAs 1–127, 200–255 and 256–382. The **base**
boot disk is 512 sectors; the app-bundled image extends beyond LBA 1024.

## Self-hosting proof

`stage4/bootstrap_seed.S` is a pinned, **Franc-generated** assembly
bootstrap compiler/kernel artifact. The independent
`.github/workflows/native-bootstrap.yml` workflow starts from a fresh
checkout, blocks invocations of Python and C compilers, assembles the
seed, boots it in QEMU, recompiles the kernel from Franc sources,
boots generation two, recompiles generation three and requires
both binaries and regenerated assembly to match the seed.

`aot.yml` also retains a historical seed-translation comparison test.
The C/Python historical toolchain is not a dependency of the
production native build. As with any pinned compiler seed, reproducible
binary identity is evidence of a consistent rebuild, **not a proof**
that the compiler seed is immune to malicious compiler behavior.

## Limits, security and portability

No process isolation, privilege separation, networking, interrupts,
multitasking, journaling, arbitrary device drivers, UEFI or USB boot
support. Only trusted Franc source bundles should be compiled;
corruption resilience and write-atomicity for `FRANCFS1` are limited.
Current hardware verification is **QEMU BIOS x86-64** with legacy
VGA/COM1/PS2/IDE; running on arbitrary modern machines has not
been established. Kernel-linked memory is RWX and JIT memory
executes writable machine code. Numeric overflow becomes bottom
instead of arbitrary-precision values, and no broad formal or
numerical correctness guarantee exists.

For the historical sequence of Stage 4 compiler/driver milestones,
see [the archived development notes](../docs/STAGE4_DEV_HISTORY.md).

## Stage 4+ experimental userland

The `stage4-roadmap-foundations` feature branch adds an initial Franc-only
bignum library, binary64 decoder, infix translator and offline source
package commands to the source bundle. See
[`docs/STAGE4_PLUS_ROADMAP.md`](../docs/STAGE4_PLUS_ROADMAP.md)
for the feature boundaries and outstanding UEFI/networking/isolation work.
