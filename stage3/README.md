# Stage 3: Franc-authored shell prototype (partial)

`stage3/shell.frac` provides a line editor and evaluation loop written in Franc,
using `calc-read`, `eval` and `depth` primitives. It is compiled by
Stage 0 during the bare-metal library bootstrap and invoked with `os-main`.
Escape returns to the caller.

Shell policy and the interaction loop live in Franc source. Drivers,
tokenization, machine-code generation, memory allocation, I/O and kernel boot
remain C/assembly. This is **not** a full Franc kernel or self-hosted compiler.

Tests: `python3 tests/test_stage3_shell.py`, and `python3 stage1/qemu_smoke.py`.
