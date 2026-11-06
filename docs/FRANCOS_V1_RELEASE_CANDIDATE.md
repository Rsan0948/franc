# FrancOS experimental v1 — integrated release candidate

> Development record: the v1 release-candidate acceptance. For the current system,
> start with the [project overview](../README.md) and [build guide](BUILD_AND_TEST.md).

**Current status:** Waves 1–4 are fully implemented in `main` after [Wave 4 PR #15](https://github.com/Rsan0948/franc/pull/15) passed **14/14 exact-head GitHub Actions workflow suites**, including the full real-QEMU integrated acceptance driver. This is an experimental QEMU-focused operating system, not a production-secure, broadly portable desktop OS.

**Release tag gate:** `.github/workflows/francos-v1-release.yml` rebuilds the final *main-commit* image, verifies byte-for-byte second/third generation self-hosting, repeats the integrated user journey, native Franc CPL3 fault isolation, six-cold-boot package lifecycle and live UDP/PCAP checks. It records main-image hashes and only creates the annotated `francos-v1.0-experimental` tag **if all those exact-main checks succeed**. Do not consider the tag published until it exists.

## Paired Wave 4 acceptance already passed

Source: accepted PR head `a92563aca5d2b0cdc6979d53b02503c005ffb16f`, merged to main as `1b0d101957d8736a8910696aec53194560dbe462`. [Wave 4 workflow](https://github.com/Rsan0948/franc/actions/runs/41734417319) and independent [Wave 3 package revalidation](https://github.com/Rsan0948/franc/actions/runs/41734417375) both succeeded on the acceptance head.

- **F4:** `lib/services.frac` wraps existing Franc e1000/ARP/IPv4/UDP/DNS and FRANCFS1 operations with bounded calls, explicit error returns and no indefinite network wait. The network suite exercises real guest NIC DMA and host-side PCAP verification, deliberately invalid packets, and guest network error/recovery.
- **U4:** `lib/ui.frac` provides shared home/IDE/packages/file style, VGA/serial title, error and status language. A QEMU test captures and reviews actual BIOS VGA screens while interacting exclusively through keyboard/serial. UEFI GOP graphics remain out of scope.
- **Integrated release journey:** `stage4/qemu_v1_journey.py` reuses **one disk over four cold boots**, with an extra forked-disk interrupted-update recovery test. It creates and edits a multiline Franc file through actual keyboard/cursor events; saves and reopens after reboot; uses the restricted Franc compiler to run real CPL3 processes; faults A, preserves B and relaunches a replacement; performs verified offline package dependency install/update/rollback/uninstall through the Packages UI; uses calculator/Ford-circle graphics; demonstrates bounded network failure and actual DNS packet exchange; and captures **18 real VGA frames**.
- **Separate regressions:** the Wave 1/2 process/IRQ/editor gates, Wave 3 CPL3 isolation and six-boot package lifecycle, Franc native apps, BIOS/UEFI boots, clean C-free bootstrap and Franctxt build authority all passed.

## Precisely bounded v1 capabilities

The kernel and compiler are Franc and assembly, with a separate allowed C UEFI firmware adapter and GNU assembler/linker for builds. The trusted REPL/native JIT remains CPL0; **only a deliberately restricted user compiler** (`def main N count fault|again ;`, `1..255`) produces audited CPL3 user code. This is genuine protected and preemptively scheduled user execution, **not** arbitrary Franc programs running safely as processes.

Packages use two fixed IDs (`base`, `app`), two version banks each, canonical Franctxt metadata, pinned dependency checks and exact raw SHA-256 source verification. A file is capped at 2047 bytes; the 12-slot FRANCFS1 directory includes two system files and must fit editor/staging/package files. Hashes protect against tampering relative to the trusted offline manifest, but there is no publisher signature, public repository, automatic update, HTTP/TLS, or general on-device dependency solver. Banks guard ordinary interrupted updates, **not arbitrary power-fail atomicity of every disk sector**; flat directory writes are not journaled.

BIOS/QEMU VGA 320x200, serial, PS/2, ATA/FRANCFS1, e1000 and bounded UDP/DNS are the tested target. No mouse/compositor/GOP UI, general network sockets, FPU/SIMD user-state virtualization, general filesystem, SMP, USB, broadly supported hardware, or production-grade security is claimed.

## Evidence and next changes

Binding [dual-track acceptance contract](FRANCOS_V1_DUAL_TRACK_ROADMAP.md). [Wave 3 accepted implementation](FRANCOS_WAVE3_FIRST_IMPLEMENTATION.md). [Wave 4 code/documentation](FRANCOS_WAVE4_STARTED.md). [Native app inventory](../stage4/apps/README.md).

**Release discipline:** once the exact-main gate publishes the tag, do not reinterpret its status or silently retag a changed commit. New features and wider language/hardware parity belong in a separately tested post-v1 development branch.
