# FrancOS apps and libraries

FrancOS loads an ordered bundle of Franc source from disk and compiles it
with its native JIT. The Home launcher loads the bundle when you first open
an app; `l` also loads it directly from the console. The source inventory is
[`build/app_sources.list`](../../build/app_sources.list).

## Open an app

Use Up/Down and Enter on Home, or press its number:

| Key | App | What it does |
| --- | --- | --- |
| 1 | Calculator | Rational expressions, editable input, history recall, and draft restoration |
| 2 | Notes | Saved-note list, named notes, read/edit views, and save/discard choices |
| 3 | Stern–Brocot explorer | Navigate the tree of positive rational numbers |
| 4 | Crosshair | Display a native framebuffer drawing |
| 5 | Ford circles | Draw a Ford-circle landscape |
| 6 | Spirograph | Draw a hypotrochoid |
| 7 | Math | Show labelled precision and continued-fraction examples |
| 8 | Demo | Show exact arithmetic, powers, and recursive factorial |
| 9 | Source IDE | Edit, save, build, and run Franc programs |

Press `r` for the Franc REPL to call loaded library definitions directly.
Demo, Math, and graphical viewers keep their results visible until a key
returns Home. Calculator and the explorer use Esc to return.

## Notes

Notes starts with **New note** and a list of saved `.txt` notes, including
legacy `notes.frac`. Use arrows and Enter to select. New notes ask for a
title of 1–19 characters; existing notes open in read view.

**E** edits, **Ctrl-S/Tab** saves, and **Esc** goes back through the read
view and list. Leaving unsaved text offers Save, Discard, or Stay. Notes
shares the source editor and the existing persistent file store.

## Source IDE

The IDE opens to a command menu showing the active file and a runnable example:

```text
def main 42 . ;
```

Use **I** to append a source line or **E** to enter the editor. The menu
also offers New, Open, Files, Save, Build, View, Clear, and Run.

In the editor:

- Arrows move the cursor; typing, Enter, Backspace, and Ctrl-D edit text.
- Ctrl-A/Ctrl-E move to the start/end of a line.
- Ctrl-S or Tab saves the active file.
- Ctrl-R compiles and runs the current buffer, showing output below the source.
- Ctrl-T opens a one-command Franc shell prompt; Ctrl-L clears output.
- Esc returns to the command menu; Esc again returns Home.

Runs preserve the editing cursor and resume editing when the program returns.
Build errors appear in the output pane. The pane stores 639 output bytes and
labels truncated output. Source files hold up to 2,047 bytes, with a maximum
of 239 bytes per compiled line. The menu's isolated-run option uses the
supported CPL3 user-program subset described in the
[process guide](../../docs/FRANCOS_PROCESS_ISOLATION.md).

## Libraries

| Source | Purpose |
| --- | --- |
| `lib/fixpt.frac` | Fixed-point precision and rounding |
| `lib/cf.frac` | Continued-fraction expansion |
| `lib/approx.frac` | Min/max, square root, pi, and e approximations |
| `lib/iv.frac` | Rational interval arithmetic |
| `lib/trans.frac` | Approximate exponential, logarithmic, and trigonometric functions |
| `lib/graphics.frac` | Crosshairs, borders, and diagonals |
| `lib/ford.frac` | Ford circles and Farey iterations |
| `lib/spiro.frac` | Spirograph drawing |
| `lib/calc.frac` | Calculator |
| `lib/edit.frac` | Line editor used by existing library clients |
| `lib/ide.frac` | Multiline source editor and run output |
| `lib/walk.frac` | Stern–Brocot navigator |
| `lib/dd.frac` | Two-component rational operations |
| `lib/bignum.frac` | Unsigned multi-limb integers |
| `lib/float.frac` | IEEE binary64 decoding and checked rational conversion |
| `lib/litetofrac.frac` | Infix expression translation/evaluation |
| `lib/pkg.frac` | Offline source package operations |

See the [mathematical foundation](../../docs/MATHEMATICAL_FOUNDATION.md)
for numerical behavior and examples. The ordered manifest includes the
additional OS-facing modules used by the IDE, packages, and services.

## Implementation and verification

`native-compat.frac` binds shared library words to the native console,
framebuffer, storage, and runtime. `registry.frac` supplies the libraries'
AOT getter/setter words. `native-programs.frac`, `notes.frac`, and
`workspace.frac` provide app entrypoints. Menu dispatch uses Franc's JIT
dictionary.

The editor's existing 4KiB page holds source, UI state, and output capture.
Notes uses the full editor height. Files and packages share the 12-slot
`FRANCFS1` directory. The trusted REPL and app bundle execute at kernel
privilege; see the [security policy](../../SECURITY.md).

QEMU acceptance exercises arithmetic, calculator history, note creation and
cold reopening, cursor editing, build/run output, shell commands, compile
failure, and Escape navigation. Graphics tests inspect actual crosshair,
Ford-circle, and spirograph framebuffer pixels. The
[build guide](../../docs/BUILD_AND_TEST.md) lists commands for BIOS and UEFI
checks; the [integration record](../../docs/INTEGRATION_FIX_VALIDATION.md)
records the current validation evidence.
