# Building and testing FrancOS

## Native OS — current standard-layout build

From the root on Linux with GNU binutils, Make and x86-64 QEMU:

    make os

This assembles **boot/bios/boot.S**, **runtime/abi.S**, the Franc-generated
seed **compiler/bootstrap_seed.S**, and the kernel module set into
**build/out/francos-bios.img**. The live native path uses **Franc and
assembly**, not C or Python to compile the kernel.

To prove FrancOS rebuilds itself with every host compiler, assembler and linker blocked:

```sh
make os
bash tests/selfhost/run.sh build/out/francos-bios.img
```

On a running system, `w` on the Home screen does the same rebuild onto a blank second disk.

To prove native self-hosting, including booted Franc generation 2 and 3:

    make os-proof

This invokes **build/bootstrap.sh**, stages **build/seed_sources.list**,
compiles the kernel within QEMU, and compares emitted bytes and compiler
assembly against the committed Franc seed.

To build the separate UEFI firmware adapter (requires Clang, LLD and mtools):

    make os-uefi

This generates **build/out/francos-uefi-esp.img**. The **boot/uefi/** adapter
uses freestanding C for UEFI firmware interaction; C is **not** linked into
the Franc kernel. See boot/uefi/README.md when available and the native
UEFI QEMU test for launch arguments.

The hosted historical Frac interpreter still uses:

    make
    make test

## Architecture and source authority gates

    python3 tools/verify_architecture_layout.py
    python3 -m franctxt.build preflight

The first checks the canonical sources, preserved snapshots and legacy
compatibility symlinks. Franctxt preflight verifies the existing pinned
source lock and application registry. Build/out is intentionally ignored
by Git.

## Real QEMU acceptance

The existing V1.1 legacy path remains supported through symlink aliases
while the QEMU runners are moved to tests/qemu:

    make -f stage4/Makefile.native native-proof
    python3 stage4/qemu_v1_journey.py stage4/native_seed.img
    python3 stage4/uefi/test_boot.py

For the new standard-layout disk, the same BIOS QEMU journey can run on:

    python3 stage4/qemu_v1_journey.py build/out/francos-bios.img

The final acceptance requires native bootstrap identity, persistent IDE and
file operations, the restricted Ring 3 execution tests, offline package
lifecycle, UDP/DNS networking and actual guest screenshots. A compiler
success or host unit test alone does not close the release gate.

## Current limits

The BIOS path uses the established legacy VGA display; the UEFI adapter
supports a tested 1024×768 framebuffer. Applications are not yet a
general-purpose window manager. Persistent storage is intentionally small;
there is no general TLS/HTTPS networking, broad hardware compatibility or
production security hardening.

For source ownership see [repository architecture](REPO_ARCHITECTURE.md).
For numeric behavior see [Mathematical Foundation](MATHEMATICAL_FOUNDATION.md).
