# Stage 4 — Native, self-hosting FrancOS (development branch)

**Current finish line:** [FrancOS v1 dual-track roadmap](../docs/FRANCOS_V1_DUAL_TRACK_ROADMAP.md). Kernel/process/network correctness **and** a usable IDE, packages, file workflow, launcher and consistent UI are jointly required; neither is deferred to v2. See [current milestones](../docs/FRANCOS_NEXT_MILESTONES.md) and [native software inventory](apps/README.md) for verified scope.

**Historical implementation snapshot (2026-11-02):** FrancOS cold-boots as a C-free
x86-64 kernel, runs the Franc native JIT and interactive console,
compiles **all 11 Franc kernel source modules** into relocatable x86-64
assembly, and produces a second and third identical generation of the
OS. The committed Franc-produced seed is independently rebuildable
with no C or Python compiler calls. The original twelve Franc libraries
and apps are also shipped on a separate disk bundle, loaded by Franc's
JIT, and exercised by QEMU integration tests.

That snapshot's image size and SHA-256 are **not current release identities**. The later [full Franc AOT QEMU integration](https://github.com/Rsan0948/franc/actions/runs/41678295866) verified a **159,130-byte** Franc-produced generation-2/3 kernel and byte-for-byte reproducibility at its tested commit. Always obtain the current exact image hash from the latest passing tested-build record rather than this README.

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

## FrancOS v1 Wave 1 integration (native BIOS/QEMU)

The FrancOS v1 two-track contract is in
[docs/FRANCOS_V1_DUAL_TRACK_ROADMAP.md](../docs/FRANCOS_V1_DUAL_TRACK_ROADMAP.md).
The authoritative native acceptance driver is `stage4/qemu_home.py`;
`.github/workflows/wave1.yml` runs it after the independent
E820/CR3 process-owner probe. A passing source build alone does not close
Wave 1.

- **Home:** Boots directly to a 320x200 keyboard-first Home surface.
  Up/Down and Enter select applications; 1–9 shortcuts work even before
  loading the trusted native library bundle. The existing numeric menu,
  REPL and diagnostic keys remain operational.
- **Files:** `z` displays the persistent `FRANCFS1` directory; open,
  new, rename and delete are accessible by visible letter shortcuts,
  with invalid-name/capacity/disk failure messages and Esc return.
  Deleting a file removes the directory entry before scrubbing data
  sectors. Directory-sector replacement is still **not** power-fail
  journaled or crash-atomic; do not advertise power-loss durability.
- **Packages:** `m` displays the existing offline source package list
  and guarded load command. This is an *accessible foundation*, not yet
  the U3 manifest/hash/dependency/update/rollback lifecycle.
- **IDE:** Home key 9 launches the native source IDE. The current editor
  has bounded cursor insertion, Backspace and a viewport; additional
  multiline visual/diagnostic acceptance belongs to Wave 2.
- **Memory:** `space-probe` constructs two private 4KiB page-table
  hierarchies from E820-authorized, generation-tagged leased frames,
  traps a user read of another process's physical page, then executes
  a surviving CPL3 context, tears down both roots and reclaims pages.
  This is sequential assembly-probe execution, **not** concurrently
  scheduled Franc user programs.

The image now reserves four BIOS kernel extents (382 sectors total):
LBA 1–127, 200–263, 264–390 and 391–454. The additional 391–454
extent loads at physical 0x37c00; it never overlaps FRANCFS1 at
128–199 or the disk source bundle at LBA 1024. This is still a 128 MiB
QEMU-only experimental configuration, not a real-hardware map claim.

**Gate:** Wave 1 closes only after an exact integrated seed/image
passes the independent process CR3 test and the real keyboard-first
Home/files/apps/cold-reboot QEMU journey, with a nonblank framebuffer
capture inspected. Wave 2 adds timer-resumed CPL3 user contexts and a
stronger editor; Wave 3 adds genuine Franc users and the real package
lifecycle. Each status must be tied to a tested commit.
