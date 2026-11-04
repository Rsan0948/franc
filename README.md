# Franc / FrancOS

**A self-hosting, experimental x86-64 operating system built around the Franc programming language.**

FrancOS boots to its own keyboard-driven Home screen, runs native Franc
applications, edits and saves source files, manages a small offline package
system, draws graphics, and exchanges real network packets in QEMU. Franc
compiles native x86-64 code; its core kernel can rebuild itself byte-for-byte
without using C or Python.

**Latest experimental preview:** [FrancOS v1.1.0 — UEFI graphics](https://github.com/Rsan0948/franc/releases/tag/francos-v1.1.0-experimental).
This release is produced only after an exact-main QEMU self-hosting,
graphics, networking, storage and isolation acceptance gate passes.

The previous [`francos-v1.0-experimental`](https://github.com/Rsan0948/franc/tree/francos-v1.0-experimental)
tag remains immutable. [Its exact-main release proof](https://github.com/Rsan0948/franc/actions/runs/41738136870)
is retained for independent comparison.

The project is experimental, primarily verified with QEMU, and not a
general-purpose, production-secure desktop operating system.

## Mathematical foundation

Franc is built around **canonical rational arithmetic**. Instead of
automatically using a binary floating-point approximation, ordinary finite
values are represented as normalized numerator/denominator pairs. For example,
**1/3 1/6 +** evaluates to **1/2** exactly when the result fits the core type.

The language also has a **wheel-inspired exceptional-value model**:
**1/0** represents one infinity-like state and **0/0** represents
undefined/bottom. The arithmetic is not identical to IEEE 754, nor does
Franc claim unlimited precision: its core numerical values use two signed
64-bit integers. Bounded overflow can become bottom.

The bundled libraries explore continued fractions, Stern–Brocot trees, Ford
circles, fixed-point approximation, interval arithmetic, big integers and
IEEE binary64 bit decoding. They are especially useful for learning number
theory, exact ratios, representation tradeoffs and numerical methods.

**[Read the Franc Mathematics Bible — the deep reference](docs/MATHEMATICAL_FOUNDATION.md)**
for formal caveats, example calculations, library-by-library use cases,
and comparisons with C, Python, JavaScript, Rust and symbolic math systems.

## Screenshots — captured from running FrancOS

These are **actual QEMU framebuffer captures**, not renders or design mockups.
The 1024×768 UEFI gallery is **post-v1 development**; the existing
`francos-v1.0-experimental` tag was frozen before the high-resolution update.

[![FrancOS keyboard-driven 1024×768 Home screen](docs/screenshots/home-uefi-1024x768.png)](docs/screenshots/home-uefi-1024x768.png)

*FrancOS Home on the new 1024×768 UEFI display. Click for full resolution.*

| Programming IDE (legacy BIOS) | Package manager (legacy BIOS) |
| --- | --- |
| [![FrancOS IDE in QEMU](docs/screenshots/ide-bios-640x400.png)](docs/screenshots/ide-bios-640x400.png) | [![FrancOS Packages in QEMU](docs/screenshots/packages-bios-640x400.png)](docs/screenshots/packages-bios-640x400.png) |

[**Browse every screenshot**](docs/screenshots/README.md) ·
[**See the source QEMU runs and image hashes**](docs/screenshots/SOURCES.md)

## What works

| Area | Capability |
| --- | --- |
| Language | Interactive rational arithmetic, definitions, branching, loops, native JIT and kernel AOT |
| Boot | Native BIOS x86-64; separate UEFI/OVMF boot through a small firmware adapter |
| Built-in apps | Calculator, Notes, Stern–Brocot explorer, crosshair, Ford circles, spirograph and math demos |
| IDE | Multiline source editor, cursor operations, persistent save/reopen, build and run |
| Files | Small persistent `FRANCFS1` directory with create/open/rename/delete |
| Packages | Two fixed offline package IDs; hash verification, dependencies, update, rollback and uninstall |
| Protected programs | Restricted Franc-compiled Ring 3 programs with preemption and tested fault isolation |
| Networking | e1000 Ethernet, ARP, IPv4, ICMP, UDP and bounded DNS requests/replies |
| State | Portable `Franctxt` configuration and source/build identities |

The trusted native REPL and full native app libraries execute with kernel
privileges. **Only a restricted Franc source subset runs as protected user
programs.** The filesystem is limited to 12 slots and 2,047 bytes per file.
Networking does not provide HTTP/TLS or general sockets. See
[precise experimental v1 limits](docs/FRANCOS_V1_RELEASE_CANDIDATE.md).

## Live OS architecture

FrancOS's active source tree follows the standard OS module boundaries:
**boot/** (BIOS/UEFI), **kernel/** (memory, processes, scheduling,
interrupts), **runtime/**, **compiler/**, **drivers/** (video, storage,
network and input), **system/** and **apps/native/**. Original Stage 1–4
snapshots are preserved in **[archive/stages/](archive/README.md)**.

The older **stage2/**, **stage3/** and **stage4/** paths still contain
compatibility aliases for pinned self-hosting identities and historical CI;
they are **not** separately maintained kernel sources. The new authoritative
native build has its Makefile and source manifests in **build/**.

From the repository root on Linux:

    make os             # native BIOS disk → build/out/francos-bios.img
    make os-proof       # rebuild native generation 2 and 3 in QEMU
    make os-uefi        # separate UEFI firmware adapter and disk

For exact boundaries, migration status and safety of the historical
compatibility links, see [architecture](docs/REPO_ARCHITECTURE.md) and
[build and test guide](docs/BUILD_AND_TEST.md).

## Legacy boot and compatibility (x86-64 Linux)

Requirements: GNU binutils (`as`, `ld`, `objcopy`), `make`, `bash`,
`awk`, `dd`, and `qemu-system-x86_64`.

```sh
# Native Franc + assembly kernel (no C/Python compiler in the build):
make -f stage4/Makefile.native native-proof

# Run the experimental BIOS image:
qemu-system-x86_64 -m 128M -accel tcg -vga std -monitor none \
  -no-reboot -serial stdio \
  -drive file=stage4/native_seed.img,format=raw,if=ide
```

At the Home screen, use the **up/down arrows and Enter**, or press `1`–`9`
for native apps. Press `z` for Files, `m` for Packages, `r` for the
interactive Franc console, and `h` for help.

To verify the real guest with keyboard input and framebuffer captures:

```sh
python3 -m franctxt.build preflight
python3 stage4/qemu_home.py stage4/native_seed.img
python3 stage4/qemu_v1_journey.py stage4/native_seed.img
```

Python is a **host-side testing and verification tool**, not a dependency
of the native BIOS FrancOS runtime.

The historical Linux-hosted Franc interpreter can be built separately with
`make` and tested with `make test`.

## Try Franc

Franc is a postfix stack language. For example:

```text
1/3 1/6 +      \ prints 1/2
def sq dup * ;
5 sq           \ produces 25
```

Native Franc supports exact rational operations within its bounded numeric
representation. The hosted language has additional features that are not
all present in the freestanding native compiler.

## Where to find the code

This repository evolved through multiple bootstrap stages. The active OS
uses source files from `stage2/`, `stage3/` and `stage4/`, plus `lib/`.
Those folder names describe history, not independent current operating systems.

- [Active subsystem/source ownership](docs/REPO_ARCHITECTURE.md)
- [Native application and library inventory](stage4/apps/README.md)
- [Current release test contract](docs/FRANCOS_V1_DUAL_TRACK_ROADMAP.md)
- [Development and graphics plan](docs/FRANCUI_DESIGN.md)
- [Franctxt format](franctxt/README.md)
- [Contributing](CONTRIBUTING.md) · [Security](SECURITY.md)
- [Historical development README](docs/HISTORY_FROM_README_2026.md)

## License and publication

Franc is distributed under the [MIT license](LICENSE). The bundled font
has separate upstream attribution and redistribution terms in
[FONT-LICENSE.txt](FONT-LICENSE.txt).

The maintainer has approved an open-source launch. The
[public-release checklist](docs/OPEN_SOURCE_LAUNCH.md) records validation and
visibility prerequisites. A GitHub Release is not a substitute for making
the repository public; GitHub visibility is controlled separately.
