# FrancOS Stage 4+ roadmap execution (experimental branch)

Source: `next steps` on `main`, after "MOST RECENT IS APPENDED:".
This document tracks *implemented functionality*, not aspirational demo code.
Do not substitute C micro-runtime code from the original proposal: the
shipping Stage 4 seed is Franc-generated assembly plus assembly ABI helpers.

## Increment 1: Franc userland foundations

- `lib/bignum.frac`: unsigned, base-256 variable-length integer objects;
  u16 capacity/length headers, checked arena allocation, add, compare,
  subtract (nonnegative only), multiply, small-divisor in-place division,
  power with nonnegative integer exponent, decimal print. All arithmetic
  intermediates are within the core Rat range. `bn-init` resets the arena.
- `lib/float.frac`: exact *binary64 representation decoding* into a
  signed significand and base-2 exponent, classification of zero/normal/
  subnormal/inf/NaN, and 64-bit Rat conversion **only when representable**.
  This is not an FPU driver and does not claim full IEEE-754 arithmetic.
- `lib/litetofrac.frac`: shunting-yard infix translation for unsigned
  integer literals, `+`, `-`, `*`, `/`, and parentheses; `lite-run`
  evaluates the translated postfix expression using the Franc JIT.
  There is no variable binding, unary minus or C-like statement syntax yet.
- `lib/pkg.frac`: offline `pkg-install`, `pkg-load`, `pkg-list`,
  `pkg-ready` based on FRANCFS1. No HTTP fetching, dependency
  solver, package signatures or disk-backed uninstall. Each stored source
  file is currently limited to 2047 bytes and storage has twelve slots.

Native integration: sources are shipped on the app bundle at LBA 1024 and
compiled on device via `l`, alongside all 12 original sources. Native
QEMU CI executes each feature using the pinned C-free seed. The AOT registry
must predeclare each new mutable register for JIT access.

## Memory and safety

The bignum allocator currently assumes QEMU BIOS x86-64 with at least
128 MiB of mapped identity memory. It reserves 0x06000000..0x063fffff for
a 4 MiB bump arena, uses metadata at 0x05fff000, and a decimal print
scratch buffer at 0x06500000 (4096 chars). Floating-point test bytes use
0x06600000; FrancLite uses 0x06800000 output (2048 bytes) and
0x06810000 operator stack (128 bytes). These are *fixed guest RAM addresses*,
not virtual-memory allocations or validated physical memory reservations.
They must be replaced with a kernel-managed allocator before UEFI or
multi-process operation. All modules are trusted kernel-privileged source.

The bignum precision grows with allocated storage; capacity is limited to
65,535 base-256 digits per object and the fixed 4 MiB arena. It is not an
unbounded or general-purpose arbitrary-precision numeric tower. Error is
returned as zero pointer, and operations never mutate their operands except
`bn-div-small!`. These APIs handle nonnegative integers only.

## Remaining Stage 4+ milestones

1. True IEEE-754 operations or a hardware FPU module, with NaN/sign/rounding
   tests; finish signed bignum, general division and parsing.
2. Full-screen Franc IDE with a bounded multiline buffer and safe edits.
3. Networking: identify a specific QEMU NIC model, build device driver,
   Ethernet/IP/TCP/HTTP and packet/interrupt tests. No fictional `http-get`.
4. UEFI: a separate x86-64 loader and framebuffer integration, verified
   in QEMU/OVMF before any real-hardware assertions.
5. Cooperative scheduling and then preemptive interrupts, with correct
   x86-64 callee-saved registers, ABI, IRQ state and stack ownership.
6. User privilege (Ring 3), page tables, TSS, proper syscall transitions
   and fault recovery. Original pseudocode incorrectly assumes SYSCALL
   automatically switches to the TSS.rsp0 stack.
7. Expand FrancLite to variables, declarations and functions; optimize the
   integer/rational fast path only with benchmark and exactness gates.
8. Networked package repositories, integrity/signature verification,
   dependency resolution, semver and a larger persistent file store.

Success criteria: every hardware claim requires QEMU proof; do not equate
passing a source-compilation test to all paths or failure modes working.

## Increment 2: native IDE, hardware enumeration and callbacks

- `lib/ide.frac` is the native multiline source editor. It implements
  bounded insertion/deletion, append-line, load/save through FRANCFS1,
  VGA/serial display, and multi-definition JIT compilation. Press `9`
  after `l` to launch its UI. Key `i` enters a source line, `v` views,
  `s` saves, `l` loads, `c` compiles, `x` clears and `q` exits.
  Still missing: arrow-controlled document navigation, full-screen
  cursor editing, syntax highlighting and large-file persistence.
- `stage4/pci.frac` adds `pci-read`, `pci-find-network`,
  `pci-find-e1000`, and `pci-scan`; assembly handles 32-bit port
  transfers (`io32@`/`io32!`). The integration guest is launched with
  a QEMU e1000 NIC for proof of real PCI enumeration. **No TX/RX,
  interrupt service, IP, TCP or HTTP yet.**
- `stage4/tasks.frac` adds a four-slot cooperative callback scheduler
  through Franc JIT code pointers, with repeatable round-robin counters.
  Each callback must return voluntarily. **This is not CPU context
  switching, separate stacks, preemption, or user-mode processes.**

The previous four Stage 4+ modules (bignum, floating-point decoding,
FrancLite and offline packages) were deliberately left unchanged.

The guest tests use 128 MiB identity-mapped QEMU RAM, with scratch
regions 0x06a00000 for callback entries and 0x06b00000 for IDE source.
These addresses are not managed allocations. UEFI, network transfers,
Ring 3, FPU arithmetic, preemptive scheduling, full-screen editor UI,
and online packages are still separate milestones.

## Increment 3: kernel memory and integer fast path

- The assembly/Franc kernel now exports `alloc` (4 MiB fixed physical
  arena, 16-byte alignment, returns 0 on exhaustion/invalid size) and
  `heap-free` (bytes remaining). The arena is reserved at
  `0x05400000..0x057fffff` on the current 128 MiB identity-mapped QEMU
  target. Allocation is monotonic, not a managed heap: no `free`,
  garbage collection, relocation, page allocation or physical memory map.
- `shl`/`shr` (also `<<`/`>>`) are native signed integer bit
  shifts. Shift count must be 0..63. Fractional operands and left-shift
  overflow return Franc bottom; right shift is arithmetic (sign-extending).
- Integer values with canonical denominator 1 skip the rational GCD path
  in `fr_push`. This is an exactness-preserving integer fast path, not
  a claim of specific speedup without benchmarks.
- The new primitives are registered in Franc's self-hosted AOT/JIT
  dictionary. QEMU regression checks the bounded allocator, memory
  read/write, shift semantics, and preserves existing rational tests.
- C remains confined to the separate UEFI firmware adapter. The native
  kernel and its generation-2/generation-3 bootstrap stay C/Python-free.

These are building blocks, not the full allocator, lazy-GCD rational engine,
virtual memory manager, protected user processes or production-ready
hardware abstraction layer.
