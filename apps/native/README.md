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

## Second pass: newly implemented OS-facing facilities

Press `9` after `l` to enter a Franc-native multiline source editor
(`lib/ide.frac`). It supports bounded insertion, deletion, append-line,
persistent open/save, compiling multiple source lines using the JIT, and
a VGA/serial command loop. Unlike the original one-line editor, it keeps
a whole editable source buffer of up to 2047 bytes; it is **not yet a
cursor-addressed or syntax-highlighted full-screen IDE**.

`stage4/pci.frac` accesses the x86 PCI configuration space using new
32-bit I/O primitives and detects QEMU's emulated e1000 by vendor/device
and class. This implements **PCI discovery, not Ethernet traffic or
a working TCP/IP network stack**.

`stage4/tasks.frac` dispatches up to four returning Franc callbacks
in deterministic round-robin order. This is **cooperative callback
scheduling**, not separate task stacks, preemption, interrupts, or
process isolation.

All three are exercised in the independent QEMU roadmap test while the
prior bignum/float/FrancLite/package implementations remain unchanged.

## FrancOS v1 Wave 1 application UX increment (PR #6)

The v1 [paired release contract](../../docs/FRANCOS_V1_DUAL_TRACK_ROADMAP.md)
makes file access, an editor and an integrated home/launcher **release
requirements**, not optional graphics polish.

The existing `9` menu entry still opens `lib/ide.frac` after `l` has loaded
the trusted application bundle. In its `ide>` menu:

- `e`: redraw a bounded VGA/serial edit viewport with a source cursor;
  PS/2 arrow events move the cursor, printable keys insert at the cursor,
  Enter inserts a newline, Backspace deletes one byte. Tab or Ctrl-S saves,
  Esc or Ctrl-Q returns to the parent IDE menu. Ctrl shortcuts are supported
  over serial; the PS/2 fallback uses Tab/Esc.
- `f`: list the live, bounded `FRANCFS1` directory on VGA and serial.
  `o`: prompt for an existing filename and open its source.
  `n`: prompt for a new filename and reset the editing buffer.
- `s`, `c`, `v`, `i`, `x`, `q`: preserve the prior save, compile,
  view, add-line, clear and quit menu operations.

The 2047-byte source cap, 12 disk slots, 23-byte filename cap, shared
`FRANCFS1` read scratch, and single-foreground-editor policy are unchanged.
A 4KiB editor reservation provides temporary character/dirty-state/filename
storage. The status line fits the native 40-column VGA text viewport.
No general filesystem, project browser, rename/delete, undo history,
syntax highlighting, independent user process, app switcher or complete
home screen is claimed. Compiler calls still execute trusted source in
kernel context.

`franctxt/tests/test_ide_contract.py` rejects unmatched editor control
structures; `stage4/qemu_roadmap.py` additionally checks cursor changes,
insertion, deletion, save/open and a real `FRANCFS1` file listing in QEMU.
Visual appearance and reboot-level IDE workflow remain independent gates.
