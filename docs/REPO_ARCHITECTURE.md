# FrancOS source architecture — current ownership and migration

FrancOS started as four sequential bootstrapping experiments. The
`stage1/`–`stage4/` naming is **history**, not the intended permanent module
structure. The active release is the Stage 4 Franc/assembly native path.

## Where the active implementation lives now

| Concern | Authoritative current sources | Notes |
|---|---|---|
| BIOS boot | `stage4/boot.S` | UEFI adapter separately in `stage4/uefi/` |
| Compiler and AOT | `stage2/compiler.frac`, `stage4/aot.frac`, `stage4/bootstrap_seed.S` | Ordered by `stage4/seed_sources.list` |
| CPU runtime and interrupts | `stage4/runtime.S`, `stage4/interrupts.S`, `stage4/scheduler.S` | Native assembly |
| Process isolation | `stage4/process_spaces.S`, `stage4/user_scheduler.S`, `lib/user_aot.frac` | Narrow protected user language |
| Filesystem and ATA | `stage3/ata.frac`, `stage3/storage.frac` | Active sources despite historical directory |
| VGA and keyboard | `stage4/display.frac`, `stage4/keyboard.frac` | Kernel-linked |
| Graphical UI | `lib/ui.frac`, `lib/ide.frac`, `stage4/kernel.frac` | JIT UI and pinned Home |
| Network | `stage4/net.frac`, `stage4/ip.frac`, `stage4/udp.frac`, `lib/services.frac` | QEMU e1000 target |
| Offline packages | `lib/pkg.frac`, `franctxt/packages.py` | Franc native UI, Python planning/tests |
| State identity | `lib/franctxt.frac`, `franctxt/` | Portable format and build verification |
| QEMU acceptance | `stage4/qemu_*.py`, `franctxt/tests/` | Host-only Python, not kernel dependency |

## Target boundaries

`boot/`, `kernel/{memory,process,scheduler,interrupts}/`,
`drivers/{storage,network,display,input}/`, `compiler/`, `runtime/`,
`system/{home,ide,files,packages,ui}/`, `apps/`, `lib/`, `formats/`,
`tests/{qemu,unit}/`, `tools/`, `archive/`, `docs/`.

Do **not** rename current sources in one mass move. First introduce stable
facade APIs and reusable test helpers. Then migrate subsystem by subsystem,
using a source/consumer map and checking the native manifest after each move.

A source-path change is not harmless: the seed lock binds ordered paths and
bytes; the bootstrap seed and exact generation-2/3 equality require a
verified repin whenever a kernel input moves. The native app inventory and
kernel-linked dictionary must remain consistent. Keep experimental v1 tag
immutable and perform modernization only on new branches.

## Python

Python belongs to host testing, legacy comparisons, image verification and
build provenance—not the FrancOS native BIOS kernel. Retain it. Consolidate
repeated QEMU capture/keyboard/serial and image-validation code incrementally;
start with `stage4/qemu_visual.py` for reusable real-frame assertions.
