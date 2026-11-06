# Building and testing FrancOS

## Native OS — current standard-layout build

From the root on Linux with GNU binutils, Make and x86-64 QEMU:

    make os

This assembles **boot/bios/boot.S**, **runtime/abi.S**, the Franc-generated
seed **compiler/bootstrap_seed.S**, and the kernel module set into
**build/out/francos-bios.img**. The live native path uses **Franc and
assembly**.

To prove native self-hosting, including booted Franc generation 2 and 3:

    make os-proof

This invokes **build/bootstrap.sh**, stages **build/seed_sources.list**,
compiles the kernel within QEMU, and compares emitted bytes and compiler
assembly against the committed Franc seed.

To build the separate UEFI firmware adapter (requires Clang, LLD and mtools):

    make os-uefi

This generates **build/out/francos-uefi-esp.img**. The **boot/uefi/** adapter
uses freestanding C for UEFI firmware interaction and hands off to the
Franc/assembly kernel. See the [UEFI guide](../boot/uefi/README.md) for
the boot contract and launch instructions.

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
lifecycle, UDP/DNS networking, and guest screenshots. These guest journeys
complement compiler and host unit tests.

## Supported environment

FrancOS is developed and tested in QEMU with BIOS VGA or a 1024×768 UEFI
framebuffer, PS/2 keyboard input, ATA storage, and an e1000 NIC. The
keyboard-driven apps share persistent FRANCFS1 storage and the native
console. See the [security policy](../SECURITY.md) for execution and trust
boundaries.

For source ownership see [repository architecture](REPO_ARCHITECTURE.md).
For numeric behavior see [Mathematical Foundation](MATHEMATICAL_FOUNDATION.md).

## Launch and integration checks

Run `tools/run_francos.sh uefi` for the GOP graphical display, or
`tools/run_francos.sh bios` for the legacy VGA display. These commands refresh
the OS from canonical `build/out` images and retain user notes/programs in
`~/.local/share/francos/disk.img` (`XDG_DATA_HOME` and `FRANC_DISK` can override
the location). Kernel/system metadata is updated while user file slots are
preserved. The launcher holds a session lock and retains a damaged disk for
inspection instead of replacing it.
The launcher accepts `FRANC_OVMF_CODE` and `FRANC_OVMF_VARS` for existing
OVMF firmware; it also recognizes standard Linux and Homebrew QEMU paths.
Use arrows and Enter or number keys to select and launch apps.

To verify the canonical UEFI build with the existing OVMF acceptance:

    FRANC_BIOS_IMAGE=build/out/francos-bios.img \
    FRANC_UEFI_ESP=build/out/francos-uefi-esp.img \
      python3 stage4/uefi/test_boot.py

Targeted input, app output, persistence, picture and IDE regressions:

    python3 tests/test_native_integration.py
    python3 tests/qemu_native_integration.py build/out/francos-bios.img
    python3 tests/qemu_native_failures.py build/out/francos-bios.img
    python3 tests/qemu_native_integration.py build/out/francos-bios.img \
      build/out/francos-uefi-esp.img /path/to/OVMF_CODE.fd /path/to/OVMF_VARS.fd

The native app output bindings use the existing Franc console. Numeric
formatting captures the original native formatter into the final 1 KiB of
the existing IDE scratch page before drawing it; source and IDE state stay
within their original bounds. Drawing primitives preserve the VGA backing
store and map pixels/palette writes to a bounded GOP viewport when present.

## App acceptance

The [app guide](../apps/native/README.md) documents application navigation,
editor controls, and library use. Run these additional guest journeys to
verify app behavior and persistence:


    python3 tests/test_launcher_persistence.py
    python3 tests/qemu_app_qol.py build/out/francos-bios.img
    python3 tests/qemu_ide_output.py build/out/francos-bios.img

The same QOL test accepts ESP/CODE/VARS arguments for UEFI as documented for
the integration test. `FRANC_SHOW_GUEST=1` displays the driven QEMU window.
