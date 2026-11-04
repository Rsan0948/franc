# FrancOS architecture: active subsystem tree and historical archive

This document records the **implemented source migration** begun after the frozen v1.1.0 experimental release. FrancOS's live native code is now organized by operating-system subsystem rather than development stage. The original Stage 1–4 source snapshots remain available under **archive/stages/**.

## The active tree

    boot/
      bios/boot.S                  BIOS real-mode loading and transition
      uefi/                        UEFI GOP/OVMF firmware adapter and Makefile
    compiler/
      bootstrap_seed.S             Verified, Franc-generated native kernel seed
      native/compiler.frac         Self-hosted native compiler
      aot.frac                     Native ahead-of-time emitter
      bundle.frac                  Bundled compiler input
    runtime/
      abi.S                        Rational ABI, dictionary, JIT and low-level primitives
    kernel/
      main.frac                    Native Franc kernel entry/application dispatcher
      kernel.ld                    Linker layout
      memory/                      E820 inventory and page ownership
      process/                     Ring 3, address spaces and native program emission
      scheduler/                   Timer/task scheduling
      interrupts/                  Native interrupt handling
    drivers/
      storage/                     ATA and FRANCFS1 persistence
      video/                       VGA Franc console, font, UEFI GOP framebuffer
      input/                       Keyboard
      network/                     PCI, e1000, IPv4 and UDP
    system/
      repl.frac                    Native REPL
      upgrade.frac                 Persistent source loader
    apps/native/                   Native app ABI adapters, registry, app entrypoints
    lib/                           Reusable Franc mathematical/UI/utility modules
    build/
      Makefile.native              Primary native BIOS/UEFI build
      bootstrap.sh                 Exact-generation self-host proof
      pack_image.sh                Native disk packer
      source_pack.sh               Native source streaming
      seed_sources.list            Ordered canonical kernel source inputs
      app_sources.list             Ordered canonical application source inputs
      out/                         Generated build artifacts (not tracked)
    tools/
      verify_architecture_layout.py  Source-owner/compatibility manifest gate
    tests/                          Hosted and QEMU regression checks
    archive/stages/stage1-4/         Unmodified stage snapshots for study

## How to build the real OS now

From the repository root:

    make os             # C/Python-free native Franc/assembly BIOS image
    make os-proof       # QEMU rebuilds generation 2 and 3; compares exact bytes
    make os-uefi        # Adds the separate UEFI firmware adapter and FAT ESP

The BIOS artifact is **build/out/francos-bios.img**; native kernel and boot
components are under **build/out/**. The UEFI adapter build is
**boot/uefi/Makefile** and outputs **build/out/francos-uefi-esp.img**.
The general hosted Frac JIT remains built with **make** and tested via
**make test**. See [build and test guide](BUILD_AND_TEST.md).

The new native Makefile names subsystem-owned sources explicitly and
self-hosts from **build/seed_sources.list**, not a hardcoded list of stage
directories.

## Why do some stage paths still appear?

The release v1.1 tag binds an ordered, hashed Franc seed input manifest, and
historical test jobs and packaging programs name **stage2/**, **stage3/** or
**stage4/**. Deleting these paths outright would silently break both the
byte-for-byte self-hosting proof and dozens of integration tests.

To avoid maintaining two editable kernels:

- **stage2/compiler.frac**, **stage3/ata.frac** and **stage3/storage.frac**
  are compatibility **symlinks** to their authoritative files in compiler/
  and drivers/.
- The active Stage 4 kernel, runtime, boot, video, network and app source
  files are also **symlink aliases** into their new subsystem directories.
  There is one editable source body, not two.
- Historical Stage 1 and non-live Stage 3 files are linked to the copies
  under **archive/stages/**. Existing test scripts and Makefiles that still
  depend on old relative paths are retained as compatibility interfaces.
- Immutable source snapshots of **all four stages** exist under
  **archive/stages/stage1/** to **stage4/**. They must not be edited when
  changing the active kernel.
- The older legacy Makefiles and QEMU test drivers remain available in
  stage paths while downstream CI transitions to the new build interface.

The authoritatively ordered seed and app sources are in **build/**, and
**tools/verify_architecture_layout.py** proves the compatibility aliases
reference exactly those same bytes in the same bundle order. The existing
legacy stage manifest stays pinned so older binary identity checks and
immutable tags continue to work.

**This is an implemented subsystem migration, not removal of all legacy
compatibility paths.** Complete removal of stage* compatibility should
follow a separately tested revision of all QEMU runners, provenance tooling,
Franctxt build-authority constants and release workflows. No one should
delete those aliases prematurely just to make the tree look cleaner.

## Numeric and language core

**runtime/abi.S** provides the 16-byte signed numerator/denominator
representation, canonicalization and bounded wheel-inspired exceptional
states. The compiler is located at **compiler/native/compiler.frac**, and
opt-in number theory and approximation libraries live under **lib/**.

See [the mathematical foundation reference](MATHEMATICAL_FOUNDATION.md)
for the math's behavior, examples, use cases and explicit limitations.

## Boot and privilege boundaries

BIOS boot enters the Franc/assembly freestanding kernel. UEFI has a small
separate C firmware adapter handing off to the same C-free kernel with GOP
information. The trusted REPL and full app bundle remain privileged; only
a restricted Franc user-program subset runs in Ring 3. This is a
QEMU-focused experimental OS, not a portable or hardened general-purpose
desktop. The operating system's pre-v1.1 source and tests remain available
through its immutable release tags.

## Migration acceptance

A migration must satisfy:

1. A complete snapshot exists for each original staged source.
2. Every active source is an ordinary file in a canonical subsystem directory.
3. Every old source alias resolves to exactly that canonical file.
4. Source manifests preserve identical bytes and ordering so the pinned
   kernel seed still builds reproducibly.
5. Existing C-free native/UEFI build and QEMU suites still pass.
6. The new top-level native build independently produces a bootable disk and
   verifies native generations 2 and 3.

A passing **source layout check alone** is not an OS proof; use
**make os-proof** and the actual guest tests.
