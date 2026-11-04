# FrancOS development history (archived original README)

The text below is the original root README retained for historical context.
It documents Stage 0–4 experiments in chronological order. Statements of
unfinished work are snapshots from when they were written and **do not**
supersede the current verified release docs. Links were originally relative
to repository root.

---

# FrancOS — start here (current release plan)

**Canonical handoff document for another chat or contributor:** [FrancOS v1 dual-track release roadmap](docs/FRANCOS_V1_DUAL_TRACK_ROADMAP.md). This is the single entry point for the **definition of done**, the paired **Fundamentals/Networking** and **UX/IDE/Packages** tracks, currently verified behavior, remaining work and full release acceptance journey.

Supporting references:
- [Detailed Stage 4 engineering milestones and QEMU evidence](docs/FRANCOS_NEXT_MILESTONES.md)
- [Implemented applications, IDE, package module and library inventory](stage4/apps/README.md)
- [Current process-memory and fault-containment implementation boundaries](docs/FRANCOS_PROCESS_ISOLATION.md)
- [Native build/runtime instructions](stage4/README.md)
- [Earlier development and implementation history](docs/STAGE4_PLUS_ROADMAP.md)

**Current release baseline (November 3, 2026):** [francos-v1.0-experimental](https://github.com/Rsan0948/franc/tree/francos-v1.0-experimental) is tagged at `c0e66715b744fa4aab8a5ebd81e7a8ab30743566`. Its exact-main workflow passed Franc/assembly-only self-hosting, the persistent-disk QEMU Home/IDE/Files/Packages journey, two separately scheduled restricted Franc-compiled Ring 3 processes with fault containment, offline package install/update/rollback/uninstall, and captured real Ethernet/UDP/DNS traffic. This is an **experimental single-user QEMU-focused OS**; its trusted full REPL remains privileged, protected user syntax is narrow, and portable hardware/production security are not claimed. The paragraphs below this introduction are historical development notes and may describe previously unfinished milestones. Current source of truth: [release candidate record](docs/FRANCOS_V1_RELEASE_CANDIDATE.md).

---

# Franc — native-compiled rational language and miniature OS

**Development status (November 2026):** The experimental
[`stage4-franc-native-bootstrap`](https://github.com/Rsan0948/franc/tree/stage4-franc-native-bootstrap)
branch now builds and boots FrancOS from a **committed, Franc-generated x86-64
assembly compiler seed**, then compiles the complete operating-system kernel
using Franc itself. Two successive native rebuilds are byte-identical to the
seed kernel. This production build invokes **no Python, C compiler, libc, or
C runtime**. A separate historical Python seed build is retained for regression
testing. See [Stage 4](stage4/README.md) for architecture and limitations.

### Build FrancOS with Franc and x86-64 assembly (development branch)

```sh
# Requires GNU as/ld/objcopy, make, bash, dd, and QEMU x86-64.
make -C stage4

# Equivalent explicit clean-source bootstrap:
make -f stage4/Makefile.native native-proof

# Historical Python AOT comparison only:
make -C stage4 legacy-all
```

The verified native source seed is `stage4/bootstrap_seed.S` (520,642 bytes).
The independent clean-checkout test blocks Python and C compiler invocations,
assembles that seed, boots QEMU, recompiles all ten FrancOS source files twice,
and compares assembly sources and kernel binaries. All three resulting kernels
are **102,016 bytes**, with SHA-256
`0944adba3bf6c524f43cade682ec8fcd5a778de1c6e7301a1afe6696bd2f67d5`.
A fixed bootstrap seed is a trusted artifact, not a proof against compiler
backdoors; reproducibility verifies consistency, not absolute correctness.

Historical Stage 0–3 still has C-backed hosted and legacy operating-system
paths for regression and comparison. Those are **not** dependencies of the
native Stage 4 build. The native disk image also bundles **12 original Franc libraries and eight
application launch options** (FracCalc, source editor, Stern–Brocot, Ford
circles, spirograph and demos). QEMU verifies live JIT loading and the main
application/math/drawing paths. See the [native software inventory](stage4/apps/README.md).

The project remains a miniature experimental OS, not a
full TempleOS replacement, and Stage 0 semantic parity, peripheral coverage
and hardened security boundaries are still incomplete.

To run historical hosted checks, use `make test`. Stage 1 can still be built
with `make -C stage1` and tested with its separate Python/QEMU scripts.

---

# Franc — AI-built rational language, JIT and experimental OS

**Tiny, deliberately strange, AI-assisted language/compiler experiment.** Frac is a Forth-style stack language over fractions, inspired by Terry Davis's tightly integrated HolyC/TempleOS development environment. This repository is a miniature proof of capability, **not** a TempleOS implementation and not intended to be a general-purpose product.

## What's real right now

- A hosted **x86-64 Linux JIT**, written in C, that emits machine-code calls and relative conditional branches into executable memory (`mmap`). No bytecode interpreter for compiled words.
- Rat values with total division behavior: `1/0` represents `∞`, `0/0` represents `⊥`. Arithmetic uses cross-products and gcd reduction.
- `if` (negative), `if0` (zero), `ifnz` (nonzero); `else`, `then`, `begin … again`, and `begin … while … repeat`.
- User-defined, recursively callable JIT functions with `def name … ;`, and a mutable dictionary, including operator, numeric-literal and immediate-word shadowing.
- Decimal repeating-cycle `~`, base `~`, unary-percent/binary-modulo `%`, hex `$`, binary `#`, and mixed-base fraction literals.
- String literals (`"hello"`) with `type`, registers `a`–`z`, `:a`–`:z`, and dynamically allocated named global registers such as `:angle` / `angle`, and byte-level JIT memory access via `@`/`!`.
- `floor` primitive; rational fixed-point rounding, continued fractions, approximations, intervals, and elementary transcendental functions defined in five `.frac` libraries.
- Automated black-box tests run generated native code, math libraries, the partial Stage 2 compiler, graphics, interactive apps, two-Rat arithmetic and persistence.

**Historical note (before the QEMU runs):** whether the Stage 1 boot image runs correctly under QEMU. A partial compiler is now written in Franc (`stage2/compiler.frac`), but full self-hosting and a kernel in Franc have not been achieved.

## Build and run

Requires x86-64 Linux, GCC (or compatible C11 compiler), Python 3 for the test runner.

```sh
make
./frac
```

Or run a source file through the REPL:

```sh
./frac < examples/demo.frac
make test
```

Load all libraries in order on Linux:

```sh
cat lib/fixpt.frac lib/cf.frac lib/approx.frac lib/iv.frac lib/trans.frac - | ./frac
```

Examples after loading:

```text
Frac> 3 fix-precision
Frac> 1/3 fix 1/3 - .
-1/3000
Frac> 355/113 cf .s
3 7 16
Frac> pi 6 / sin .
1/2
```

## Quick start

```text
Frac> 1/3 1/6 +
1/2
Frac> 1/7 ~
0.(142857)
Frac> 255 16 ~
FF
Frac> def sq dup * ;
Frac> 5 sq
25
Frac> def fact dup 1 - if drop 1 else dup 1 - fact * then ;
Frac> 5 fact
120
```

**This is postfix.** Write `1/3 1/6 +`, not `1/3 + 1/6`. A fraction literal has **no spaces** around `/`.

The REPL preserves its data stack across lines and automatically displays the top value after each line, **without consuming it**. Use `.` to print and pop, or `drop` to clear an unwanted value. This is especially important because unary/binary `~` and `%` currently dispatch on **the number of items on the entire stack**, not on an expression boundary:

- `1/7 ~` expands the rational when exactly one item is present.
- `255 16 ~` converts the integer to base 16 when at least two items are present.
- `50 %` is 1/2 with one item; `50 3 %` is integer remainder with two or more.

## Operators and conventions

- `+ - * / ^ pow abs neg inv floor`: exact rational arithmetic within the bounded representation; denominator zero stays an ordinary value.
- `%`: unary percent (divide by 100), binary Euclidean-style remainder for integers. Invalid remainder operands produce `⊥`.
- `~`: unary decimal/repeating expansion or binary integer-to-base output (2–36).
- `if`, `if0`, `ifnz`: **consume** the top value. `if` executes on negative, `if0` on zero, `ifnz` on nonzero. `else` and `then` delimit branches.
- `def name … ;`: compile a word and prepend it to the dictionary. You can shadow `+`, `1`, and even `if`/`def` (subsequent uses of those names then call your definition).
- `"string" type`: prints the literal. `key` reads a character from stdin. `emit` outputs the low byte of a rational's numerator.
- `:r` stores top value to register `r` and pops; `r` pushes it.
- `'word` or `' word` pushes a compiled word's machine-code address, `@` fetches **one byte** from the JIT mapping, `!` writes **one byte** in `(address value --)` order. Example: `'sq @ .` prints the first opcode byte (`72` for `0x48`). **Patching instruction bytes can make the process crash; this is an intentionally low-level experiment.**

## Architecture

`frac.c` contains a whitespace/quoted-string tokenizer, literal parser, wheel arithmetic helpers, mutable linked-list dictionary, code emitter, and one-line-at-a-time JIT REPL. Each generated word establishes x86-64 SysV stack alignment, calls native C helpers or other compiled words, and returns normally. Dictionary code is kept in the lower half of a 64 MiB executable mapping; temporary per-line code occupies the upper half. This separation prevents the REPL's `ret` from overwriting newly defined words, a defect in the initial pasted source.

`frac-original.c` preserves the **original supplied code** verbatim, extracted from the pasted design. `frac.c` is the tested/modified implementation. The modifications address persistent definitions, call-stack alignment, dictionary priority, quoted words and strings, byte patching syntax, control-structure validation, and signed arithmetic overflow.

## Deliberate limitations and upcoming work

- `Rat` stores signed 64-bit numerator and denominator. Math uses 128-bit intermediates; if a reduced answer does not fit, it currently becomes `⊥` (a **bounded-implementation compromise**, not a property of mathematical wheels). No arbitrary-precision arithmetic.
- `~` prints at most 1,024 fractional digits; expansions with longer cycles are truncated rather than marked. It also uses a basic quadratic remainder search.
- The stack and token buffers are fixed-size. The `@`/`!` experiment restricts addresses to the executable JIT region for some protection; `type` still assumes it receives a valid string pointer. The JIT allocates writable/executable memory, intentionally; don't execute untrusted Frac programs.
- Syntax for definitions is single-line (`def … ;` must be on one line (library files use one definition per line)). Compilation errors are detected, but this is not a hardened parser or a production runtime.
- Stage 1 now builds a freestanding graphics/serial/keyboard kernel with a flat ATA-IDE source store on the boot image. **It still requires a QEMU boot test**; hosted tests and a valid linker output do not prove it boots.
- Historical status: Stage 2 was partial and Stage 3 was not started. See the current status at the top of this README.
- Source persistence is intentionally **QEMU IDE / opt-in host-file only**, not a general-purpose filesystem or USB storage driver.
- `dd.frac` provides exact two-Rat component pairs for representable operations. It is **not** a general 30-digit double-double number type and does not provide arbitrary precision.

## License

MIT. See [LICENSE](LICENSE).

## Stage 1 — in progress (private development)

`stage1/` contains the first freestanding **x86-64 BIOS boot image** implementation: a 512-byte bootloader, identity-mapped long mode, minimal VGA/serial/PS2 console and memory allocator, and a kernel that compiles the Stage 0 JIT against a small freestanding libc shim. The original hosted Stage 0 remains usable, and the hosted test suite passes. Math, graphics, interactive, and two-component-rational libraries are embedded as source strings and loaded into the JIT before entering its REPL.

```sh
make -C stage1
python3 stage1/verify_image.py
# Requires QEMU, not installed in the development environment used so far:
python3 stage1/qemu_smoke.py
```

**Verification status:** image builds and passes offline disk-layout checks with the libraries embedded, but actual QEMU boot and Frac REPL execution on bare metal are still unverified. No claim of successful bare-metal execution is made.

**Repository privacy:** this project is intended to remain **private during development** and only be made open source when its owner elects to release it.

## Library limitations and numerical honesty

`lib/fixpt.frac`, `cf.frac`, `approx.frac`, `iv.frac`, and `trans.frac` deliberately operate in the existing bounded 64-bit rational system. Rounding error from `fix` can be obtained exactly by subtraction **when no intermediate overflow occurs**. `pi`, `e`, `sqrt`, `exp`, `log`, `sin`, and other routines are numerical approximations, not arbitrary-precision or formally verified implementations; many deliberately round intermediate results to avoid overflow. Interval division through zero is not a sound interval enclosure. The demo is designed to be runnable, not a numerical-analysis library.

## Math libraries (Stage 0 + Stage 1)

Five pure-Frac libraries live in `lib/`. They are loaded in this order:

1. `fixpt.frac` — decimal fixed-point rounding (`fix`, `fix-precision`, `eps`, `ceil`, `trunc`).
2. `cf.frac` — continued-fraction expansion (`cf`).
3. `approx.frac` — rational approximations of square root, π, e, and `min`/`max`.
4. `iv.frac` — basic interval arithmetic with pairs of rationals.
5. `trans.frac` — rational-series approximations for exp/log/sin/cos/atan and hyperbolic functions.

Load on Linux without modifying the core:

```sh
make
cat lib/{fixpt,cf,approx,iv,trans}.frac - | ./frac
```

Or copy the libraries into stdin followed by expressions. For example:

```text
3 fix-precision
1/3 fix 1/3 - .
355/113 cf .s
```

The command is postfix: `3 fix-precision`, not `fix-precision 3`.
The compiler supports `\` comments extending to end of source line, not `#` comments;
`#` is the binary literal prefix. Each `def` must fit on one line.

`stage1/embed_libraries.py` produces a C header from these source files as part
of `make -C stage1`, and the bare-metal kernel compiles and runs the definitions
before presenting its REPL. The same source files are used for the Linux tests.

**Numerical contract:** Fractions stay exact only when intermediate numerator and
denominator values fit in signed 64-bit integers. The approximate functions
explicitly quantize some intermediate values to avoid overflows. This gives a
convenient *measurable* rational rounding difference, but `pi-err` and `e-err`
are illustrative tolerance budgets, **not formally certified error bounds**.
Interval `/` does not offer a valid enclosure when a denominator interval crosses
zero, and integer-overflow-to-bottom is an implementation compromise.
`sqrt-err` provides an exact residual-based bound for positive input and positive
estimate when the arithmetic remains representable. Global named registers are
not lexical locals, so concurrent/reentrant definitions should avoid collisions.

Tests: `make test` runs the original 62 Stage 0 tests, 28 library checks, 19 Stage 2 checks, 15 graphics checks, and 12 application checks (136 total). QEMU boot remains separate; static kernel-image checks are not proof of boot.

## Stage 2 — partial Franc-authored compiler

`stage2/compiler.frac` is a working native-code compiler **written in Franc**,
bootstrapped by the Stage 0 C JIT. It tokenizes source, walks the dictionary,
parses base-prefixed fraction literals, emits x86-64 bytes through `!`, and
registers native word definitions. Nineteen execution checks compare its
results to the expected values. Run `make test` or see [stage2/README.md](stage2/README.md).

It does **not** yet compile conditional words, loops, or its own source; do not
call Stage 2 fully self-hosted until a compiler built by the Franc compiler
successfully compiles Franc's compiler again.

## Mode 13h graphics (pre-Stage 3)

Franc now has a shared framebuffer API backed by **320x200x256 VGA** on
bare metal or an in-memory 320x200 framebuffer under Linux. A rasterized
8x8 ASCII font draws the kernel's 40x25 console on VGA. COM1 remains active.

```sh
make
cat lib/{fixpt,cf,approx,iv,trans,graphics,ford,spiro}.frac demos/graphics-demo.frac | ./frac
# screenshot written to franc-frame.ppm (host only)
make -C stage1 && python3 stage1/verify_image.py
```

After loading the library definitions: `crosshair`, `20 fordland`,
`5 2 14 spiro`, `1 2 1 3 tangent?`. New C primitives: `clearfb`,
`pixel`, `pixel@`, `line`, `fillrect`, `palette`. `screenshot` exports
a PPM on Linux only. The Ford tangency check uses integer arithmetic, while
the drawing uses rational pixel-center tests on a finite raster; small circles
may become sub-pixel. Neither proves error bounds for arbitrary approximations.

**Stage 1 execution in QEMU is not yet verified;** Stage 2's Frac-written
compiler remains partial (control-flow and recompiling its own source are pending).
The repo remains private until its owner explicitly decides to publish it.

## FracCalc and Stern–Brocot explorer (last two applications before Stage 3)

These applications live **in Franc source**, not in special kernel code. The
shared C bootstrap provides minimal OS-facing words (`eval`, `depth`, `key`,
`key?`, `break?`, `key-mode`, `calc-buffer`, `history-buffer`, `b@`, `b!`,
`save`, `load`, `files`, `copy`, `source`, and `home`). `eval` generates and
runs native code without overwriting the currently executing REPL word.

```sh
make
cat lib/{fixpt,cf,approx,iv,trans,graphics,ford,spiro,calc,edit,walk}.frac - | ./frac
```

Launch the calculator by typing `calc-main`; evaluate postfix expressions with
Enter, use Up to recall older expressions, Backspace to correct an entry, and
Esc to exit. `ans` is a Franc word for the current accumulator. For example:

```text
Frac> calc-main
> 1/3 1/6 +
ans: 1/2
> def twice dup + ;
> 7 twice
ans: 14
> ans 2 *
ans: 28
> [Esc]
Frac> 7 twice .
14
```

The RAM source store works without a filesystem, but **does not survive reboot**:

```text
Frac> "foo" "def twice dup + ;" save
Frac> "foo" "foo.bak" copy
Frac> "foo" edit-line
> def triple dup dup + + ;
Frac> "foo" load
Frac> 9 triple .
27
```

`edit-line` is an intentionally minimal replacement-line editor, not a multi-line
full-screen file editor. A file can store multiple newline-separated definitions
through `save`, and `load` evaluates them; the interactive editor edits one line.
The memory stores at most 12 files of 2,047 bytes each, in RAM.

For the landscape use `walk-main`. The left/right arrows take exact mediants,
Esc returns to the normal REPL, and `walk-check` returns 1 only when both
Farey-neighbor determinant invariants are 1. You can test the arithmetic without
a keyboard:

```text
Frac> walk-reset
Frac> walk-left
Frac> wk-p wk-q / .
1/2
Frac> walk-right
Frac> wk-p wk-q / .
2/3
Frac> walk-check .
1
```

Both are embedded into the Stage 1 kernel image at build time. The hosted tests
exercise the actual compiler/JIT and framebuffer, including scripted keyboard
events. **Neither app has yet been verified booting in QEMU**. Keyboard arrows
use PS/2 in bare-metal mode; host terminals use ANSI arrow sequences. Serial
input currently handles ASCII, not extended arrow sequences.

Historical status: Stage 2 could not yet compile its source; this is now covered by two-generation tests.
Completing that compiler and verifying a real Stage 1 boot are separate gates
before claiming a full Frac-authored Stage 3 kernel.

## "next steps" implementation (pre-Stage 3)

The GitHub `next steps` design file is preserved verbatim. See
[`docs/NEXT_STEPS_IMPLEMENTATION.md`](docs/NEXT_STEPS_IMPLEMENTATION.md) for the
actual implemented features, test commands, and design deviations.

- `key`, `key?`, `break?`, and `key-mode`: interactive character/arrow input,
  with cooperative Esc checking (`break?`). Bare metal polls PS/2 and COM1.
- `eval`, `depth`, `save`, `load`, `source`, `copy`, `files`: compile source
  dynamically and maintain editable named source files in RAM.
- `disk-ready?`, `disk-format`: optional **FRANCFS1** fixed-slot persistence.
  In the QEMU boot image the disk is preformatted. For hosted tests, set
  `FRANC_DISK_IMAGE=/path/to/256-sector.img` to opt in. Without a formatted
  image, `save` stores only in RAM. Files survive a fresh process or QEMU reboot
  when the same disk image is retained.
- `launch` loads a named source file and calls its freshly defined `main` once;
  `run-main` invokes an existing `main`. We deliberately do **not** auto-run
  `main` after every REPL line.
- `lib/calc.frac`, `lib/edit.frac`, `lib/walk.frac`: interactive calculator,
  one-line source editor and exact Farey/Stern–Brocot explorer. Use `calc-main`,
  `"file" edit-line`, `walk-main` respectively. The editor is **not** yet a
  full-screen editor.
- `lib/dd.frac`: exact `(hi lo)` component arithmetic, intentionally not
  advertised as 30-digit precision.

To run all regression tests: `make test`; build the preformatted QEMU image
with `make -C stage1 && python3 stage1/verify_image.py`. The image is now
**128 KiB**, including the 64 KiB BIOS+kernel area and a 64 KiB persistent
source area. **QEMU execution remains an independent verification step.**

## Required release milestone: zero C dependencies

FrancOS must eventually build and boot without C source, C compiler, C
runtime, or C-derived helper functions. The incremental Stage 3 driver
migration is not that end state. See
[`docs/C_FREE_EXIT_CRITERIA.md`](docs/C_FREE_EXIT_CRITERIA.md) for concrete
AOT, relocations, native primitives, hardware porting and cold-boot CI gates.
