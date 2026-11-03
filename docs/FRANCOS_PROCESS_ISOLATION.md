# FrancOS memory handoff and process fault-containment increment

**Branch:** `stage4-process-isolation-foundation` (stacked on the merged Stage 4 UDP/JIT scheduler work)

## Verified baseline

- Ring 0: PIT IRQ-based preemption of two native Franc JIT words with independent CPU/rational stacks and explicit task-local scalars.
- Ring 3: BIOS/QEMU one-shot user INT80 and supervisor-memory page-fault test.
- These were **independent demonstrations** and are not yet a production process subsystem.

## This increment (CI pending until the process-isolation QEMU workflow passes)

1. **Firmware inventory:** the 512-byte BIOS loader far-calls a real-mode helper at 0x1000:0005 already embedded in the loaded native kernel image. The 64-bit kernel entry skips that helper via an initial 5-byte JMP. This real-mode helper runs INT 15h E820 *before* mode transition, writes at most 48 fixed-size 24-byte descriptors to 0x5000, and only publishes an `E820` signature if the map is complete. Native read-only Franc words `e820-count`, `e820-base`, `e820-length` and `e820-type` enforce bounds and return zero for missing or invalid descriptors. This does **not** imply a dynamic physical allocator, safe reuse of E820-usable pages, full memory reservation, or UEFI GetMemoryMap integration.

2. **Distinct physical backing:** the existing BIOS-only CPL3 page-table experiment is extended with private B code and B stack frames. When A is active, only A's user pages are mapped at virtual addresses 0x40000000 and 0x40001000. A deliberately reads the supervisor kernel address 0x10000, causing #PF. After validating the user fault, the kernel marks A as faulted, replaces both user PTEs with B's *different* physical pages, reloads CR3 to flush stale translations, and enters B at the *same virtual addresses* with CPL3.

3. **Survivor check:** B executes 50,000 writes to its own user stack page, calls INT80, and the kernel checks the private physical frame, retires B, revokes both user aliases, and returns to the Franc REPL. `process-a-state`, `process-b-state`, `process-b-steps`, and `process-survived?` expose the observed result.

4. **Independent gate:** `FRANC_TEST_PROC_ISO=1 python3 stage4/qemu_irq.py` asserts real E820 presence, legal/illegal inventory access, expected fault, separate B progress, one-shot semantics, and a working Franc REPL after the fault.

## Deliberate boundaries and next stages

This probe executes **two user-mode assembly snippets sequentially**, not two simultaneously scheduled Franc Ring 3 processes. It reuses a fixed trusted BIOS CR3, a single GDT/TSS and one two-PTE user alias window. It is neither a general syscalls API nor independent per-process CR3 space, and it is not built for UEFI or real hardware.

The next work should allocate separate address-space roots using the firmware-authorized/reservation-aware page allocator; install Ring 3-compatible timer scheduling with per-process kernel stacks/TSS RSP0, address-space switching, and a strictly validated syscall ABI; then run **two actual Franc user programs**, fault one while the other is actively runnable, and prove continued progress after the fault. The existing ring-0 JIT compiler/runtime cannot simply execute unchanged at CPL3 because its native helpers and mutable dictionary are supervisor-owned.

Never relabel these successive isolation tests as concurrent fault-tolerant multiprocess execution.


## Image capacity and Franctxt reservation

The native kernel grew past the former 310-sector/158,720-byte boot extent. The BIOS loader and GNU packer now agree on 318 sectors (162,816 bytes): 127 sectors at LBA 1–127, 64 sectors at LBA 200–263, and 127 at LBA 264–390; the physical destination remains contiguous from 0x10000. The FRANCFS1 partition (LBA 128–199) and app source bundle (LBA 1024+) are unchanged. The Franctxt seed reservation is 163,840 bytes (40 KiB multiples), covering the full newly loaded extent. No source list/compiled Franc seed changes are required, but every full bootstrap and image-integrity gate must be rerun.


## Firmware-gated physical pages

The existing 2,048-page bitmap allocator still uses the fixed, declared Franctxt 8 MiB arena at `0x07000000..0x07800000`, but it now calls `fr_e820_arena_usable` before allocations or reporting free page capacity. The gate requires a complete E820 inventory, a type-1 descriptor containing the whole arena and **no overlapping non-type-1 descriptor**. Overflowed or malformed ranges are rejected. The read-only Franc word `page-arena-safe?` exposes the predicate. This is a firm safety improvement on BIOS/QEMU, not a discovery-based arbitrary-page allocator; an unprovided UEFI map causes allocation to fail closed until the UEFI adapter passes its GetMemoryMap data.
