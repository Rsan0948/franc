# Stage 2 — Franc compiler in Franc (bootstrap milestone)

**Status: real native code emission in Franc, but partial self-hosting.**

The hosted C JIT first compiles `compiler.frac` into native functions. Those
functions implement a whitespace scanner, NUL-terminated string comparison,
mutable dictionary search, signed/mixed-base fraction literal parsing, and
x86-64 machine-code emission directly in Franc. The emitted programs actually
execute and can define new dictionary words. See `tests/test_stage2.py`.

```sh
make test                              # includes 19 Stage 2 tests
cat stage2/compiler.frac - | ./frac
```

Once inside the REPL:

```text
Frac> "1/3 1/6 +" s2-compile s2-run .
1/2
Frac> "def sq dup * ;" s2-compile drop
Frac> "5 sq" s2-compile s2-run .
25
Frac> "$FF/$10" s2-compile s2-run .
255/16
```

**What is compiled in Franc today:** one expression of literal and callable
word tokens, or one straightforward `def name ... ;` definition. Dictionary
lookup and token scanning happen in Franc; the native output consists of
real `movabs` and `call` instructions, not interpreted bytecode.

**Bootstrap bridge:** 10 tiny native helpers are made available to Franc:
`byte@`, `dict-head`, `dict-next`, `dict-name`, `dict-code`,
`s2-token-buffer`, `s2-lit-addr`, `s2-code`, `s2-run`, and `s2-define`.
They expose memory, dictionary layout, allocation, a numeric push helper,
and code execution. The lexical parser, dictionary walk and emitter are *not*
native C functions. Franc's existing byte-write `!` is used to write code.

**Not yet self-hosted:** `s2-compile` does not support conditional/loop
immediates (`if`, `if0`, `ifnz`, `else`, `then`, `begin`, `while`, `repeat`,
`again`, `exit`), string constants in its input, multiline source, or
arbitrary-precision literals. It therefore cannot compile
`stage2/compiler.frac` or replace the Stage 0 C compiler. Passing `make test`
is a partial Stage 2 milestone, not proof of full self-compilation.

The bootstrap bridge intentionally exposes unsafe pointers and writable/
executable memory, consistent with the experiment. Only run trusted code.
The token buffer is shared between compilations, and native output allocations
are currently fixed at 4 KiB each; this is a limited experimental compiler.

## Next milestone

1. Support nested `if`/`else`/`then` and `begin`/`while`/`repeat`, with a
   Franc-owned control-flow fixup stack.
2. Support strings, decimals and comments in input source.
3. Compile `compiler.frac` using `s2-compile` and run the resulting compiler.
4. Repeat the bootstrap with its newly compiled version and verify identical
   output against Stage 0 on a corpus of programs.
5. Remove remaining Stage 0 compilation dependencies, retaining only the
   necessary machine/OS primitives.
