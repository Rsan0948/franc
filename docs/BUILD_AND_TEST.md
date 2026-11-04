# Building, testing and viewing FrancOS

FrancOS currently targets **x86-64 Linux/QEMU** as its primary reproducible
development environment. The native BIOS kernel is Franc + assembly; C and
Python are used only by other explicitly selected builds or host tools.

## Install prerequisites

GNU assembler/linker/objcopy, make, bash, awk, dd and QEMU x86-64 are
required to rebuild and boot the BIOS image. Python 3 is required to run
host-side verification. For optional UEFI tests, also install Clang, lld-link,
OVMF and mtools.

## Check, build and run

```sh
python3 -m franctxt.build preflight
make -f stage4/Makefile.native native-proof
qemu-system-x86_64 -m 128M -accel tcg -display none -monitor none \
  -no-reboot -serial stdio \
  -drive file=stage4/native_seed.img,format=raw,if=ide
```

`native-proof` is the important check: the guest recompiles its own kernel
twice, and the resulting generations must match the committed seed.

```sh
make test
python3 stage4/qemu_home.py stage4/native_seed.img
python3 stage4/qemu_v1_journey.py stage4/native_seed.img
```

The Home and release-journey tests inject real keyboard events and save PPM
screenshots using QEMU's monitor. A passing source or serial marker alone is
not a substitute for these guest checks. Actual screenshots are uploaded as
CI artifacts.

## UEFI / GOP (post-v1 development)

The experimental UEFI adapter is in `stage4/uefi/` and uses a small allowed
C firmware bridge. The runtime and compiler remain Franc + assembly.
Run `make -f stage4/uefi/Makefile esp` after building the native kernel,
then `python3 stage4/uefi/test_boot.py`. The test captures the framebuffer
and checks guest pixels. Firmware and real hardware compatibility beyond
tested OVMF/QEMU configurations is not asserted.

## Test ownership

`tools/qemu_visual.py` implements shared PPM decoding and real-pixel
assertions. `stage4/qemu_visual.py` remains the transition shim. Kernel,
storage, networking, IDE and package tests still live in `stage4/qemu_*.py`
and their respective Franctxt/unit-test suites. Migration is incremental.

## Development discipline

`stage4/seed_sources.list` is the exact ordered kernel source list.
`stage4/app_sources.list` is the ordered native app bundle.
Kernel source changes require rebuilding and re-pinning both the committed
Franc-generated assembly seed and the Franctxt seed lock, followed by
generation-2/3 proof. Do not casually rename these sources.

For documented scope and limitations see
[release candidate](FRANCOS_V1_RELEASE_CANDIDATE.md) and
[architecture ownership](REPO_ARCHITECTURE.md).
