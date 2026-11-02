# `next steps`: implementation record (pre-Stage 3)

This document tracks the private GitHub file named `next steps` and distinguishes
implemented code from design sketches. The original is preserved in the root.

| Proposal | Implementation | Verification | Limitations |
|---|---|---|---|
| Two-Rat precision extension | `lib/dd.frac` | `tests/test_dd.py` | Split exact sums; **not** a generic 30-digit float or arbitrary-precision package |
| Blocking/nonblocking input and cooperative break | `key`, `key?`, `break?`, `key-mode` | Hosted app input tests | No preemptive cancellation; bare-metal keyboard pending QEMU |
| Dynamic evaluation | `eval`, `depth` | `tests/test_apps.py` | C-backed compiler bridge; Stage 2 not fully self-hosted |
| Session RAM source files | `save`, `load`, `files`, `source`, `copy` | `tests/test_apps.py` | 12 files, <=2047 bytes each |
| Disk persistence | `stage1/disk_store.h`, ATA functions in `stage1/runtime.c`, padded disk | `tests/test_persistence.py`, `verify_image.py` | No actual QEMU ATA boot test yet; IDE only |
| Interactive main convention | `launch` (load + run fresh `main`), `run-main` | Persistence tests | Explicit launch, not implicit on each REPL command |
| Calculator | `lib/calc.frac` | `tests/test_apps.py` | Single-line input/history, not a complete IDE |
| Source editor | `lib/edit.frac` | `tests/test_apps.py` | One-line editor, not full-screen self-editor |
| Certified Stern–Brocot walk | `lib/walk.frac` | `tests/test_apps.py` | Exact invariants; framebuffer output only hosted-tested |

The note about double-double rationals equaling "30-digit precision" was not
implemented as written: a pair of bounded exact Rat values cannot recover
information already lost when the core overflows. `dd.frac` retains separate
representable components; operations are exact *when every component fits*.

### Reproduce

```sh
make test
make -C stage1
python3 stage1/verify_image.py
python3 stage1/qemu_smoke.py  # requires QEMU, still pending validation
```

To test persistent source **without real disk access**:

```sh
python3 tests/test_persistence.py
```

The source store in the BIOS image is intentionally simplistic and may be
replaced when Stage 3 begins. File operations must never be advertised as a
production filesystem or guaranteed durable without an actual QEMU run.
