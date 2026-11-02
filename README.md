# Frac — Stage 0: x86-64 JIT

**Tiny, deliberately strange, AI-assisted language/compiler experiment.** Frac is a Forth-style stack language over fractions, inspired by Terry Davis's tightly integrated HolyC/TempleOS development environment. This repository is a miniature proof of capability, **not** a TempleOS implementation and not intended to be a general-purpose product.

## What's real right now

- A hosted **x86-64 Linux JIT**, written in C, that emits machine-code calls and relative conditional branches into executable memory (`mmap`). No bytecode interpreter for compiled words.
- Rat values with total division behavior: `1/0` represents `∞`, `0/0` represents `⊥`. Arithmetic uses cross-products and gcd reduction.
- `if` (negative), `if0` (zero), `ifnz` (nonzero); `else`, `then`, and `begin … again`.
- User-defined, recursively callable JIT functions with `def name … ;`, and a mutable dictionary, including operator, numeric-literal and immediate-word shadowing.
- Decimal repeating-cycle `~`, base `~`, unary-percent/binary-modulo `%`, hex `$`, binary `#`, and mixed-base fraction literals.
- String literals (`"hello"`) with `type`, registers `a`–`z` and `:a`–`:z`, and byte-level JIT memory access via `@`/`!`.
- Automated black-box tests running the actual generated code.

**Not present:** freestanding/bare-metal boot, VGA keyboard REPL, a compiler written in Frac, or a Frac kernel. Those are later stages.

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

- `+ - * / ^ abs neg inv`: exact rational arithmetic within the bounded representation; denominator zero stays an ordinary value.
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
- Syntax for definitions is single-line (`def … ;` must be on one line). Compilation errors are detected, but this is not a hardened parser or a production runtime.
- Stage 1 (bootable FracOS) will require an actual boot path, freestanding runtime, I/O drivers, and memory layout, **not** just swapping four libc functions.
- Stage 2 is a compiler implemented in Frac; Stage 3 is the Frac kernel. Neither has been implemented yet.

## License

MIT. See [LICENSE](LICENSE).

## Stage 1 — in progress (private development)

`stage1/` contains the first freestanding **x86-64 BIOS boot image** implementation: a 512-byte bootloader, identity-mapped long mode, minimal VGA/serial/PS2 console and memory allocator, and a kernel that compiles the Stage 0 JIT against a small freestanding libc shim. The original hosted Stage 0 remains usable and its 62 tests still pass.

```sh
make -C stage1
python3 stage1/verify_image.py
# Requires QEMU, not installed in the development environment used so far:
python3 stage1/qemu_smoke.py
```

**Verification status:** image builds and passes offline disk-layout checks, but actual QEMU boot and Frac REPL execution on bare metal are still unverified. No claim of successful bare-metal execution is made.

**Repository privacy:** this project is intended to remain **private during development** and only be made open source when its owner elects to release it.
