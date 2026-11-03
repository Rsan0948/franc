# FrancOS engineering roadmap — Stage 4+

**Development branch:** `stage4-roadmap-foundations`  
**Updated:** 2026-11-03  
**Rule:** kernel, runtime and compiler use Franc + assembly, never a C/Python runtime. The separate UEFI firmware adapter may use C; CI and build-validation scripts may use Python, shell and binutils.

> This is the actionable milestone plan. The older [development log](STAGE4_PLUS_ROADMAP.md) records the previous implementation increments. A commit is not a completed milestone; only an explicit integration test can establish that.

## Verified foundations

| Subsystem | Demonstrated | Unfinished |
| --- | --- | --- |
| Kernel / build | Native Franc self-hosting, repeatable generation-2/3 output, BIOS/OVMF QEMU boot | Relocation and real hardware |
| Franctxt | Portable typed configuration, SHA-256, native persisted manifest, build source inventories, seed lock and static reservation checks | Authenticated secure boot and live policy enforcement |
| Memory | 4 KiB checked bitmap arena, zeroed allocation, bounded heap | Firmware memory discovery and process page tables |
| Scheduler | Round robin callbacks and two independently stacked cooperative fibers | Interrupts, preemption, process isolation |
| Networking | e1000 BAR0 MMIO, DMA ARP TX/RX, independent QEMU Ethernet capture | Reusable rings, IPv4/ICMP/UDP/TCP and sockets |
| UEFI | OVMF boot through C-only firmware adapter to C-free kernel | GOP graphics, full firmware map and real hardware |
| Userland | Native IDE, twelve original apps, partial float/bignum/FrancLite/offline packages | Full arithmetic, language, package resolver and online install |

Baseline test evidence: [AOT self-hosting](https://github.com/Rsan0948/franc/actions/runs/41589946227), [e1000 packet capture](https://github.com/Rsan0948/franc/actions/runs/41589348353), [Franctxt integration](https://github.com/Rsan0948/franc/actions/runs/41589348403). Results apply to their exact tested commits; re-test changed artifacts.

## P1 — Reusable Ethernet, ARP, IPv4, ICMP and UDP

1. Replace one-shot TX with eight indexed DMA descriptors. Wait for completion, reuse descriptors safely, reject bad lengths and timeouts.
2. Add RX consumption/rearm via RDT and maintain a ring head index. Validate received frame length, status and error bits. Test multiple packets.
3. Validate ARP, capture the gateway MAC, and keep bounded neighbor state. Handle timeouts and malformed packets.
4. Introduce strict IPv4 encoding/decoding: version, IHL, length, checksum, protocol and address bounds. No fragmented-packet handling until explicitly implemented.
5. Send ICMP echo to the QEMU gateway, validate its reply, then add UDP TX/RX with independent packet-capture and response assertions.
6. Do not claim TCP/DNS/HTTP until retransmission, sequence/timeout state and end-to-end tests exist.

**Acceptance:** 2+ distinct transmitted packets and 2+ consumed/returned RX descriptors in QEMU; verified ICMP request/reply; a verified UDP exchange; malformed packet rejection. CI ties the resulting evidence to a Franctxt-tested-build identity.

**Files:** `stage4/net.frac`, planned `stage4/ip.frac`, `stage4/qemu_net.py`, `.github/workflows/network.yml`, `stage4/app_sources.list`, `stage4/apps/registry.frac`.

## P2 — CPU exceptions, timer interrupts and preemption

1. Install a real x86-64 IDT and typed CPU exception handlers, accounting for vectors with and without a hardware-pushed error code.
2. Enable a timer (PIT/PIC or APIC), acknowledge interrupts correctly, and validate tick counts in native QEMU.
3. Preserve *all* relevant CPU state, Franc rational stacks, shared globals and interrupt nesting/critical-section invariants.
4. Transition from cooperative fibers to timer-driven preemptive scheduling, proving two tasks advance without voluntarily yielding.

**Acceptance:** actual QEMU timer IRQ proof, exception diagnostics, timer-driven progress of independent tasks and no stack/ABI corruption. A cooperative yield test is not proof of preemption.

## P3 — Physical/virtual memory and Ring 3

1. Consume BIOS E820 / UEFI memory maps rather than assuming all 128 MiB is free. Reserve runtime, DMA, page tables, framebuffer and firmware ranges using Franctxt declarations.
2. Allocate/manage 4 KiB page tables, bounds and permissions. Set NX/W^X where feasible.
3. Add GDT/TSS user descriptors, Ring 3 stack and page permissions, and an explicit trusted syscall path (SYSCALL does not automatically switch to TSS.rsp0).
4. Validate user privilege boundaries and recover from invalid user accesses without halting the entire kernel.

**Acceptance:** QEMU proves user-mode code cannot write protected kernel memory and a faulty process cannot crash a healthy one. Requires sound exception/interrupt infrastructure.

## P4 — Language, developer environment, packages and portability

- `float.frac`: IEEE-754 operations, rounding, infinity/NaN and signed zero tests.
- `bignum.frac`: signed numbers, general division, conversions and safe allocation.
- `litetofrac.frac`: variables, declarations, functions and diagnostics.
- `ide.frac`: cursor movement, fullscreen editing, highlighting and larger persistent files.
- `pkg.frac`: dependency resolution, semantic versions, signatures and secure network-based installation.
- UEFI: GOP framebuffer support, true memory handoff and hardware-safe relocation.
- Performance: benchmark integer/rational paths and retain exactness tests; never assert speedups without measurements.

## Build discipline and verification

- **Franctxt authority:** consume exactly `stage4/seed_sources.list` and `stage4/app_sources.list`; refuse stale `franctxt/seed.lock.franctxt`; validate `franctxt/memory.franctxt`; verify packed kernel, runtime, registry, boot sector and app bundle digests before guest tests.
- **Native and cross-language:** Franc kernel/runtime remain Franc+assembly; portable Python/JS and host build tools are permitted, but cannot masquerade as on-device functionality.
- **No invented capabilities:** distinguish source code written, executable linked, QEMU-verified hardware behavior and production security.
- **Branch safety:** keep `main` untouched; pin matching AOT bootstrap assembly and seed lock atomically; track tests by exact commit.
- **Negative tests:** cover invalid input, timeouts, resource reuse, interrupt/page faults and malformed network packets. Independent QEMU packet captures required for network claims.

## Milestone state log

| Date | Item | State |
| --- | --- | --- |
| 2026-11-03 | Franctxt build authority, fixed memory layout, seed identity | Verified foundation |
| 2026-11-03 | e1000 DMA ARP transmission and reception | Verified foundation |
| 2026-11-03 | Physical pages and cooperatively resumed stacks | Verified foundation |
| 2026-11-03 | Eight-slot e1000 TX/RX and repeated ARP exchange | Partial QEMU proof passed; full network CI pending |\n| 2026-11-03 | IPv4 and ICMP echo request/reply | Implemented, QEMU receive-validation failing |\n| 2026-11-03 | UDP | Planned |
| 2026-11-03 | PIC/PIT timer IRQ + IDT foundation (not preemptive) | Verified QEMU — [CI run 41652092184](https://github.com/Rsan0948/franc/actions/runs/41652092184) |
| 2026-11-03 | Ring 3 process isolation | Planned |

**Status definitions:** planned = no implementation; implemented/pending = code exists, gate unresolved; verified = successful relevant CI/QEMU test at that commit; partial = a subset works; blocked = a known failing gate. Update this log with test links and the exact result as work proceeds.

## Increment in progress: first native hardware timer

`stage4/interrupts.S` installs a 256-gate x86-64 IDT, remaps PIC IRQ0 to vector 32, programs a nominal 100 Hz PIT, and exposes `irq-start`, `irq-ticks`, and `irq-stop` through the Franc native ABI. A dedicated QEMU test measures real timer progress and verifies ticks stop after disabling interrupts. **This is a hardware interrupt foundation, not a preemptive scheduler:** it does not switch tasks, preserve per-process register contexts, use a per-CPU IRQ stack, handle recoverable exceptions, or implement Ring 3. Unexpected vectors deliberately fail closed. The dedicated [IRQ integration workflow](https://github.com/Rsan0948/franc/actions/runs/41652092184) passed: ticks advanced 148 to 287 and then stopped under CLI/masking. This validates hardware IRQ delivery and counter behavior only, not timer-driven task switching.

### Network acceptance update (2026-11-03)

The [network CI run 41652092097](https://github.com/Rsan0948/franc/actions/runs/41652092097) observed two completed e1000 TX descriptor slots, two received/released/rearmed RX descriptors, and successful basic IPv4 checksum and packet-size checks inside QEMU. **The full job failed** when the guest rejected the expected ICMP reply; packet/header diagnostics are underway. The ring proof is a partial result, not evidence that IPv4/ICMP/UDP are complete. No source-level claim substitutes for a full green network test.
