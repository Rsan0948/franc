# FrancOS v1 — Wave 2 acceptance and Wave 3 handoff

**Authority:** [FRANCOS_V1_DUAL_TRACK_ROADMAP.md](FRANCOS_V1_DUAL_TRACK_ROADMAP.md) remains the v1 release contract. This document records *testable implementation*, not a substitute for passing QEMU on the exact merge commit.

## Paired Wave 2 implementation

### F2 — protected CPL3 contexts and narrow syscall ABI

- Two E820-authorized, generation-tagged process owners each have a private PML4/PDPT/PD/PT, RX user code page, RW user stack, and a private RSP0 kernel stack.
- IRQ0 preempts arbitrary non-yielding **assembly** user snippets and switches 15 integer GPRs, full IRET frames, CR3, and TSS RSP0; normal exit, fault, invalid syscall, and the fixed 80-tick budget all return to a healthy trusted host.
- INT80 is intentionally *small and fail-closed*: RAX=0 exits, RAX=1 writes between 1 and 80 bytes from **only** the mapped user stack interval `0x40001000..0x40001fff`, RAX=2 returns the PIT tick count, RAX=3 reads a serial character without blocking (returns -1 if absent). Unknown calls or invalid pointers retire only the offending task. The handler never treats a user-controlled pointer as a kernel address.
- A normal exit and an invalid syscall have distinct per-task terminal states. After A exits, faults, or is rejected, B keeps its isolated state and is preempted until the bounded timeout. Reclaimed pages must return to the initial free count.
- Current user programs are *trusted fixed assembly templates* with no FPU/SIMD instructions; arbitrary instruction loading, library calls, dynamic allocation and file/package syscalls are not yet permitted. Those need new contract and tests before F3 user programs can consume them. This is not production OS isolation.

### U2 — persistent bounded IDE

- File name and dirty/full status, 2047-byte source cap, vertical/horizontal cursor motions, home/end, backspace/delete, and a bounded serial/VGA multiline viewport.
- Real file creation/open/save and source persistence across a cold QEMU reboot.
- `ide-build` compiles one source line at a time, refuses lines above 239 bytes and stops at the *first* Stage 2 compile failure with a line number. `ide-run` requires a `def main ` entrypoint in the current buffer and never invokes the old dictionary's `main` after a failed build or missing entrypoint.
- Keyboard and PS/2 tests must create a two-line program in the editor, repair a token in the middle, save, reboot the same disk, reopen, compile and run it with observable output. VGA captures must show the edited and reopened source.

## Exact acceptance gates

**Integrated branch under test:** `francos-wave2-completion-wave3-start`, PR #10.

1. `FRANC_TEST_USER_PREEMPT=1 python3 stage4/qemu_irq.py stage4/native_seed.img`: two CPL3 tasks preempt, A faults while B lives; further probes require clean exit, invalid syscall, valid console/ticks return, rejected kernel pointer, full page reclaim and a working Franc REPL.
2. `python3 stage4/qemu_roadmap.py stage4/native_seed.img`: kernel/library/editor regressions plus compile error line reporting and stale-main refusal.
3. `python3 stage4/qemu_ide_wave2.py stage4/native_seed.img`: fresh editor keyboard journey, PS/2 mid-line repair, cold reboot, build/run and actual screenshots.
4. Existing Wave 1 Home/Files/CR3 tests, native bootstrap generation 2/3, AOT, UEFI, networking, application and Franctxt validation remain green.

**Status:** Pending exact-commit green QEMU and integration review. Implementation/structural checks alone do not close Wave 2.

## Immediately following: paired Wave 3 — user Franc + offline packages

**F3:** Define a restricted, auditable user-mode code-generation format for genuine Franc source, separate from the existing supervisor JIT helpers. Compile Franc source into a bounded RX-only CPL3 page. Run two separately scheduled Franc-compiled programs; fault A while B remains runnable; clean up A, allow B to complete its bounded work, then launch another Franc program. User-mode file/package syscall additions must validate every pointer/length/handle and never call trusted JIT helpers with an untrusted address.

**U3:** Create a canonical Franctxt-compatible manifest with package ID, version, declared dependencies, file inventory and SHA-256 identities. Implement an offline trusted local repository, dependency-ordered installation and duplicate/missing/cyclic dependency handling, verified update, uninstall and rollback/safe failure. The package system must never silently run installed code at ring 0, must account for FRANCFS1's 12 slots and <=2047-byte file cap, and must survive cold reboot.

**Wave 3 proof:** A user installs a local dependency plus application, validates stored hashes, executes the compiled *Franc* app in CPL3, upgrades/rolls back and uninstalls it, while an unrelated isolated Franc task survives an intentional user fault.

Do **not** describe Wave 2 assembly stubs as Franc-compiled CPL3 applications or the current `pkg-ui` source loader as a full U3 package lifecycle.
