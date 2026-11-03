# FrancOS Stage 4+ roadmap execution (experimental branch)

Source: \`next steps\` on \`main\`, after "MOST RECENT IS APPENDED:".
This document tracks *implemented functionality*, not aspirational demo code.
Do not substitute C micro-runtime code from the original proposal: the
shipping Stage 4 seed is Franc-generated assembly plus assembly ABI helpers.

## Increment 1: Franc userland foundations

- \`lib/bignum.frac\`: unsigned, base-256 variable-length integer objects;
  u16 capacity/length headers, checked arena allocation, add, compare,
  subtract (nonnegative only), multiply, small-divisor in-place division,
  power with nonnegative integer exponent, decimal print. All arithmetic
  intermediates are within the core Rat range. \`bn-init\` resets the arena.
- \`lib/float.frac\`: exact *binary64 representation decoding* into a
  signed significand and base-2 exponent, classification of zero/normal/
  subnormal/inf/NaN, and 64-bit Rat conversion **only when representable**.
  This is not an FPU driver and does not claim full IEEE-754 arithmetic.
- \`lib/litetofrac.frac\`: shunting-yard infix translation for unsigned
  integer literals, \`+\`, \`-\`, \`*\`, \`/\`, and parentheses; \`lite-run\`
  evaluates the translated postfix expression using the Franc JIT.
  There is no variable binding, unary minus or C-like statement syntax yet.
- \`lib/pkg.frac\`: offline \`pkg-install\`, \`pkg-load\`, \`pkg-list\`,
  \`pkg-ready\` based on FRANCFS1. No HTTP fetching, dependency
  solver, package signatures or disk-backed uninstall. Each stored source
  file is currently limited to 2047 bytes and storage has twelve slots.

Native integration: sources are shipped on the app bundle at LBA 1024 and
compiled on device via \`l\`, alongside all 12 original sources. Native
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
\`bn-div-small!\`. These APIs handle nonnegative integers only.

## Remaining Stage 4+ milestones

1. True IEEE-754 operations or a hardware FPU module, with NaN/sign/rounding
   tests; finish signed bignum, general division and parsing.
2. Full-screen Franc IDE with a bounded multiline buffer and safe edits.
3. Networking: identify a specific QEMU NIC model, build device driver,
   Ethernet/IP/TCP/HTTP and packet/interrupt tests. No fictional \`http-get\`.
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

## Increment 2: first OS services (systems branch)

This independent branch leaves Increment 1's four libraries unchanged.

- `stage4/apps/ide.frac`: native 320x200 VGA editor with a 2047-byte
  multi-line edit buffer, arrows, delete/backspace, Enter, Ctrl-S persistent
  save, Ctrl-L reload, Ctrl-R trusted-source compilation, Escape to menu.
  The viewport currently displays the first 22 text rows and does not
  scroll to later pages. File storage still uses 12 FRANCFS1 slots.
- `stage4/apps/task.frac`: deterministic 8-slot round-robin step-function
  scheduler. A task voluntarily finishes each call. There are no context
  switches, independent stacks, interrupts, preemption or isolation.
- `stage4/apps/pci.frac`: 32-bit PCI configuration reads/writes through
  `io32@`/`io32!` assembly ABI primitives, RTL8139 vendor/device scan
  on PCI bus 0, I/O BAR and MAC register reads. No NIC initialization,
  Ethernet frames, IP/TCP, DHCP, IRQs or sockets yet.

The QEMU systems suite requires `-device rtl8139`; only a successful
native guest probe establishes the hardware detection claim.
The fixed RAM assumptions (IDE at 0x06900000, tasks at 0x06a00000)
are suitable only for the current 128 MiB QEMU identity-mapped test guest.
The 32-bit port I/O helpers are architecture-specific **assembly**,
not C, preserving the C-free kernel build.
