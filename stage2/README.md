# Stage 2 — self-compiling Franc native compiler

The core compiler logic in [`compiler.frac`](compiler.frac) is Franc code:
scanning tokens, dictionary search, mixed-base/decimal rational literals,
quoted strings, native x86-64 call/branch emission, control-flow relocation,
and registration of new definitions. It emits machine code and executes it,
not interpreted bytecode.

## Reproducible bootstrap

1. Stage 0 C JIT bootstraps the initial Franc compiler definitions.
2. `s2-self-source s2-source` recompiles those definitions using the Franc
   compiler rather than C. This installs generation 2 in the dictionary.
3. Running the same command again installs generation 3, compiled by
   generation 2. Both generations compile real arithmetic, definitions,
   nested conditionals, and loops. See `tests/test_stage2.py`.
4. In bare-metal FracOS, `os-bootstrap` builds the second generation and
   then recompiles the Franc shell using `s2-shell-source s2-source`.
   The interactive shell compiles through the Franc-defined `s2-eval`.

`make test` runs the hosted regression suite. To experiment interactively:

```sh
make
cat stage2/compiler.frac - | ./frac
```

```text
Frac> s2-self-source s2-source .
29
Frac> "0.1 0.2 +" s2-compile s2-run .
3/10
Frac> "def sq dup * ;" s2-compile drop
Frac> "5 sq" s2-compile s2-run .
25
```

## Limits

This is **self-compilation, not independent machine bootstrapping**. The first
compiler generation still needs Stage 0, and the Franc compiler uses a small
native runtime bridge for memory allocation, word addresses, calling generated
code and stable string storage. It handles one definition or expression per
source line (which matches the project's current source layout); it is not a
complete general-purpose, standalone replacement for every Stage 0 syntax
extension. Generated code uses fixed 64 KiB blocks and unsafe pointers.
