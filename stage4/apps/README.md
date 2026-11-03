# FrancOS native software inventory

This document describes what is **integrated into the assembly/Franc-only
Stage 4 image** on `stage4-franc-native-bootstrap`. The original libraries
in `lib/` are not copied or rewritten. `pack_native.sh` stages their exact
source bytes, in dependency order, as a NUL-terminated disk source bundle.
The native Franc JIT compiles them inside FrancOS on demand.

## On-device application control

From the native `Franc>` menu, press `l` once to load the source bundle.
The console reports `APPS LOADED <count>` and `APPS READY` only after
compilation and initialization. Afterwards:

| Key | Native entry | Source | Feature |
| --- | --- | --- | --- |
| 1 | `calc-main` | `lib/calc.frac` | Interactive rational calculator, history, editing |
| 2 | `app-edit` -> `edit-line` | `lib/edit.frac` | One-line source editor; `notes.frac` file |
| 3 | `walk-main` | `lib/walk.frac` | Interactive Stern–Brocot explorer |
| 4 | `app-font-demo` -> `crosshair` | `lib/graphics.frac` | Native VGA crosshair |
| 5 | `app-ford-demo` -> `fordland` | `lib/ford.frac` | Ford circles landscape |
| 6 | `app-spiro-demo` -> `spiro-demo` | `lib/spiro.frac` | Hypotrochoid / spirograph |
| 7 | `math-demo` | `stage4/apps/native-programs.frac` | Rational precision / continued fractions |
| 8 | `app-demo` | `stage4/apps/native-programs.frac` | Exact rational arithmetic, square, recursion |

Esc returns from calculator, source editor and explorer to the parent menu.
The guest's `r` command launches the Franc REPL, where any loaded library
definition can be invoked directly. Menus dispatch by looking up the mutable
JIT dictionary; there is no C-side application table.

## Reusable native source libraries

All **12 original source files** are staged:

| File | Library | Native arrangement |
| --- | --- | --- |
| `lib/fixpt.frac` | Decimal fixed-point, precision and rounding | JIT source |
| `lib/cf.frac` | Continued-fraction expansion | JIT source |
| `lib/approx.frac` | `min`, `max`, `sqrt`, `pi`, `e` approximations | JIT source |
| `lib/iv.frac` | Rational interval arithmetic | JIT source |
| `lib/trans.frac` | Approximate exp, log, sin, cos, atan, sinh, cosh | JIT source |
| `lib/graphics.frac` | Crosshair, border, diagonals | JIT source |
| `lib/ford.frac` | Ford circles and Farey iterations | JIT source |
| `lib/spiro.frac` | Spirograph/hypotrochoid drawing | JIT source |
| `lib/calc.frac` | Interactive FracCalc app | JIT source |
| `lib/edit.frac` | One-line source editor | JIT source |
| `lib/walk.frac` | Rational Stern–Brocot navigator | JIT source |
| `lib/dd.frac` | Two-component rational operations | JIT source |

`stage4/apps/native-compat.frac` supplies Franc-language equivalents of
hosted-only words (`inv`, integer `^`, `eval`, `key-mode`, `line`,
`fillrect`, `pixel@`, `palette`, `copy`, `load`, `launch`,
calculator scratch-buffer locations and a named app initializer).
`stage4/apps/native-programs.frac` adds native entrypoints for the
existing example/graphics demonstrations without relying on Linux screenshot
export. `stage4/apps/registry.frac` reserves AOT dictionary getter/setter
words for the libraries' global registers, because the current native JIT
does **not** yet allocate arbitrary named registers at runtime.

## Verification boundaries

- `.github/workflows/apps.yml` launches an **independent QEMU guest**
  running the pinned Franc-generated C-free assembly seed.
- The first passing end-to-end suite compiled **94 source lines** from
  the staged libraries without `stage2: unsupported token` errors, then
  demonstrated a recursive factorial app, powers, Stern–Brocot arithmetic,
  VGA pixel readback, and the real interactive FracCalc. Extended native CI also verifies
  the source editor and file reload, exact continued fractions, intervals,
  two-component rationals, a trigonometric case, native crosshair drawing,
  and **actual Ford-circle and spirograph framebuffer pixels**.
- The independent `native-bootstrap.yml` workflow still requires exact
  seed/gen2/gen3 kernel identity with Python and C compiler commands blocked.
- A module **loading** or having its definitions registered is not the same
  as proving every function and numerical edge case works. The application launcher itself and the Ford/spirograph pixel paths are
  now executed under QEMU, but complete graphical frames, every possible
  interactive path and all numerical edge cases remain unverified; see the passing app
  workflow for the checked subset.

## Disk layout and limitations

- LBA 128–199: persistent `FRANCFS1` source store, 12 short files.
- LBA 512: compiler's disposable full-kernel source marker; data at LBA 513.
- LBA 1024: independent application source marker; data at LBA 1025.
  Source staging is bounded to 131071 bytes and the ATA read limit is 4096 LBAs.
- `0x300000` and `0x310000`: reserved guest scratch buffers for calculator
  and history, with the native JIT's generated code starting at `0x400000`.
- `screenshot` in this native adapter explicitly reports that PPM export is
  not implemented; the graphics demos draw directly to the VGA framebuffer.
- The original `examples/demo.frac` uses hosted-only decimal expansion `~`.
  `app-demo` preserves a rational/numeric/factorial demonstration but is **not
  full syntax/behavior parity** with every hosted example operation.
- Numerical approximations are bounded by rational overflow, global register
  naming and the existing approximation algorithms.
- All Franc source runs at **kernel privilege**. There are no process boundaries
  or sandbox guarantees; only load trusted source bundles.

## Build and run

From repository root:

```sh
make -C stage4
qemu-system-x86_64 -m 128M -accel tcg -display none -monitor none \
  -no-reboot -serial stdio \
  -drive file=stage4/native_seed.img,format=raw,if=ide
# In FrancOS: press l, then 1..8, or r for interactive Franc.
```

This does not use a package registry, dependency solver, dynamic linker or
software distribution service. The "packages" are ordered source modules
loaded by Franc's own compiler. Updates require repacking the source bundle.

## Stage 4+ roadmap additions (experimental)

The `stage4-roadmap-foundations` branch additionally ships four Franc-only
source modules: `bignum.frac` (unsigned multi-limb integer operations),
`float.frac` (IEEE-754 binary64 bit decoding and checked Rat conversion),
`litetofrac.frac` (a small infix expression translator/evaluator), and
`pkg.frac` (offline source-file install and load). These load with `l`;
their definitions can be used in the `r` REPL. The original 12 source
libraries and eight menu launch options remain unchanged.

A separate native QEMU test runs representative bignum, floating-point,
infix and package examples; see
[`docs/STAGE4_PLUS_ROADMAP.md`](../../docs/STAGE4_PLUS_ROADMAP.md) for
memory reservations, exact limitations and remaining roadmap items.

## Stage 4+ hardware and OS foundations (systems branch)

The `stage4-roadmap-systems` branch adds `stage4/apps/ide.frac` (multiline
buffer editing, native VGA text rendering, arrow navigation, source persistence
and compilation), `stage4/apps/task.frac` (bounded round-robin **step callbacks**)
and `stage4/apps/pci.frac` (PCI configuration via native 32-bit PIO; probe
for a QEMU RTL8139 device, its BAR and MAC bytes). Press `l`, then `i` for
IDE, `t` for cooperative task demo, or `n` for NIC probe. The `r` REPL
exposes all functions. The IDE edits `notes.frac` by default.

The task module does not save program counters or stacks and is **not**
preemptive multitasking; the PCI probe does **not** transmit Ethernet frames,
load a NIC driver, or implement TCP/IP. Userland and kernel remain a
single trusted x86-64 address space. QEMU CI supplies an explicit RTL8139
device and checks its identification.

### Raw Ethernet transmission (experimental)

The additional `stage4/apps/net.frac` module initializes a PCI RTL8139
with programmed I/O, a guest-physical receive ring and a transmit DMA buffer.
`net-send-demo` sends one 60-byte broadcast Ethernet frame with the
experimental EtherType `0x88B5` and payload `FRANCOS-ETHER-TEST`. Native
menu key `m` runs the test and prints success/failure. QEMU CI must prove
the actual transmitted Ethernet frame is visible in a host-side PCAP captured
with `filter-dump`, not only that the NIC's TX status bit was set.

This is **raw Ethernet only**. It is not an IP stack, DHCP client, internet
connection, socket API or general-purpose networking capability. The NIC
buffer addresses are fixed assumptions of the QEMU 128 MiB test machine;
do not use this experimental code on real hardware.
