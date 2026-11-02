# Stage 3 — Franc-owned kernel services (incremental migration)

The boot image currently relies on a C/assembly initialization and primitive
substrate. `shell.frac` owns the interactive REPL and calls the self-recompiled
Franc compiler for user expressions. The new Franc device modules are:

- `drivers.frac`: COM1 polling, PS/2 scan-set-1 decoding (Shift and extended
  arrow codes) and key event policy; `key` is rebound *after* loading libraries.
- `console.frac`: recompiled line editor, linking it to the Franc keyboard word.
- `ata.frac`: **read-only** primary-master ATA PIO sector fetch through
  `io8@`, `io8!`, `io16@`; persistent disk writes still use the known-good C
  driver. `128 ata-read-sector .` should print 1 under the QEMU IDE test image;
  `ata-header-byte .` should print 70 (the first byte of `FRANCFS1`).
- `shell.frac`: startup, self-recompilation, shell and C diagnostic fallback.

Port primitives are hardware-only in bare metal; on Linux they return zero/noop
and `host-key` supplies input. The Franc keyboard state machine is tested
without privileged I/O on Linux. The QEMU tests must validate actual port I/O.

**Not yet C-free:** CPU setup, C arithmetic/dictionary/JIT bootstrap, screen
pixel driver, serial output and persistent writes still depend on C.

The required end-state is explicitly recorded in
[`docs/C_FREE_EXIT_CRITERIA.md`](../docs/C_FREE_EXIT_CRITERIA.md). We will not
call the experiment finished until a cold-bootable, self-hosted kernel can be
built and executed without C compiler/runtime/code dependencies.
