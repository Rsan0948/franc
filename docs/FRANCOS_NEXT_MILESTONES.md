# FrancOS engineering roadmap — Stage 4+

**Development branch:** `stage4-roadmap-foundations`  
**Updated:** 2026-11-03  
**Rule:** kernel, runtime and compiler use Franc + assembly, never a C/Python runtime. The separate UEFI firmware adapter may use C; CI and build-validation scripts may use Python, shell and binutils.

> This is the actionable milestone plan. The older [development log](STAGE4_PLUS_ROADMAP.md) records the previous implementation increments. A commit is not a completed milestone; only an explicit integration test can establish that.

> **FrancOS v1 now has two first-class tracks.** The binding release scope, paired milestones and end-to-end UX acceptance live in [FRANCOS_V1_DUAL_TRACK_ROADMAP.md](FRANCOS_V1_DUAL_TRACK_ROADMAP.md). This file remains the detailed subsystem backlog. An IDE, package lifecycle, file UX and integrated visual shell are **v1 requirements**, not leftover optional P4 polish.

## Verified foundations

| Subsystem | Demonstrated | Unfinished |
| --- | --- | --- |
| Kernel / build | Native Franc self-hosting, repeatable generation-2/3 output, BIOS/OVMF QEMU boot | Relocation and real hardware |
| Franctxt | Portable typed configuration, SHA-256, native persisted manifest, build source inventories, seed lock and static reservation checks | Authenticated secure boot and live policy enforcement |
| Memory | BIOS E820 bounded inventory, firmware-gated 8 MiB/4 KiB page arena, zeroed allocation and bounded heap | General firmware-driven physical allocator, independent process page-table roots, UEFI GetMemoryMap |
| Scheduler | QEMU-verified IRQ0 preemption of two native Franc JIT workers, private rational stacks, explicit scalar task locals, bounded retirement | General task API, named-register isolation, FPU/SIMD save, guard pages, **concurrent** CPL3 scheduling |
| Networking | e1000 DMA rings, ARP, IPv4/ICMP, and one QEMU-verified UDP/DNS request/reply | Reusable UDP/DNS APIs, TCP, routing, sockets and production network handling |
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

## Track U — developer experience, packages and visual usability (v1 required)

**This is an equal release track, not optional P4 polish.** The actionable U1–U4 milestones and integrated acceptance are defined in [FrancOS v1 two-track release contract](FRANCOS_V1_DUAL_TRACK_ROADMAP.md). Native IDE, launcher, file workflows, usable package management and coherent graphical/text interaction all block the v1 tag until independently QEMU-tested.

The legacy language/portability backlog remains: IEEE-754 arithmetic, signed bignum, expanded FrancLite, general dependency resolution, signed public repositories, UEFI GOP rendering, real hardware/relocation and performance benchmarks. These enhancements must not displace the **bounded** v1 experience gates. The existing `lib/ide.frac`, `lib/pkg.frac` and native applications are starting points, not finished UI.

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
| 2026-11-03 | Eight-slot e1000 TX/RX and repeated ARP exchange | Verified — [QEMU network run 41654048287](https://github.com/Rsan0948/franc/actions/runs/41654048287) |
| 2026-11-03 | Bounded IPv4 and ICMP echo request/reply | Verified — [QEMU network run 41654048287](https://github.com/Rsan0948/franc/actions/runs/41654048287) |
| 2026-11-03 | QEMU-local UDP/DNS query with six malformed-response rejections and bidirectional PCAP verification | Verified — [UDP run 41663291781](https://github.com/Rsan0948/franc/actions/runs/41663291781) on commit `277d258` |
| 2026-11-03 | PIT/IDT and ring-0 assembly preemption with independent Franc rational stacks | Verified — [preemption run 41663713370](https://github.com/Rsan0948/franc/actions/runs/41663713370) on commit `926b848`; not a Franc JIT task scheduler |
| 2026-11-03 | BIOS CPL3/INT80/supervisor page-fault one-shot experiment | Verified — [Ring 3 QEMU run 41664139626](https://github.com/Rsan0948/franc/actions/runs/41664139626) on commit `16e4777`; no general process isolation yet |
| 2026-11-03 | Real Franc JIT CPU preemption, two independent scalar-local/Rat-stack contexts, normal return/timeout | Verified — [QEMU integration run 41672001629](https://github.com/Rsan0948/franc/actions/runs/41672001629) on commit `e0e8bab`; bounded trusted ring-0 experiment, not a general scheduler |

| 2026-11-03 | BIOS E820 memory discovery, fixed allocator usable/reserved firmware gate | Verified — [QEMU run 41677382606](https://github.com/Rsan0948/franc/actions/runs/41677382606) on commit `4f9dec8`; UEFI memory-map handoff not implemented |
| 2026-11-03 | Two distinct sequential CPL3 user mappings with faulted A and survivor B | Verified — [QEMU run 41677382606](https://github.com/Rsan0948/franc/actions/runs/41677382606) on commit `4f9dec8`; **not** concurrent Franc Ring 3 process execution |

**Status definitions:** planned = no implementation; implemented/pending = code exists, gate unresolved; verified = successful relevant CI/QEMU test at that commit; partial = a subset works; blocked = a known failing gate. Update this log with test links and the exact result as work proceeds.

## Increment in progress: first native hardware timer

`stage4/interrupts.S` installs a 256-gate x86-64 IDT, remaps PIC IRQ0 to vector 32, programs a nominal 100 Hz PIT, and exposes `irq-start`, `irq-ticks`, and `irq-stop` through the Franc native ABI. A dedicated QEMU test measures real timer progress and verifies ticks stop after disabling interrupts. **This is a hardware interrupt foundation, not a preemptive scheduler:** it does not switch tasks, preserve per-process register contexts, use a per-CPU IRQ stack, handle recoverable exceptions, or implement Ring 3. Unexpected vectors deliberately fail closed. The dedicated [IRQ integration workflow](https://github.com/Rsan0948/franc/actions/runs/41652092184) passed: ticks advanced 148 to 287 and then stopped under CLI/masking. This validates hardware IRQ delivery and counter behavior only, not timer-driven task switching.

### Network acceptance update (2026-11-03)

The [network CI run 41652092097](https://github.com/Rsan0948/franc/actions/runs/41652092097) observed two completed e1000 TX descriptor slots, two received/released/rearmed RX descriptors, and successful basic IPv4 checksum and packet-size checks inside QEMU. **The full job failed** when the guest rejected the expected ICMP reply; packet/header diagnostics are underway. The ring proof is a partial result, not evidence that IPv4/ICMP/UDP are complete. No source-level claim substitutes for a full green network test.

### IPv4/ICMP acceptance update (2026-11-03)

[Network CI run 41654048287](https://github.com/Rsan0948/franc/actions/runs/41654048287) is fully green. It validates two Ethernet descriptor TX/RX cycles with ARP address learning, IPv4/ICMP checksum generation and independent packet capture, a successful native echo request/reply, rejection of a corrupted IPv4 header, and bounded packet lengths. A bug in one's-complement carry folding was identified from the host-captured ICMP frame and corrected. This is a tested **fixed 10.0.2.15 -> 10.0.2.2 QEMU path**, not DHCP/routing/fragmentation, UDP/TCP, or a general socket API.

### UDP increment

`stage4/udp.frac` sends a small UDP DNS A/IN query to the built-in QEMU resolver at `10.0.2.3:53`, with separately learned ARP, an IPv4 pseudoheader checksum, and strict receive address/length/response checks. The **optional** `FRANC_TEST_UDP=1` QEMU network check requires a real DNS reply, independent Ethernet packet capture, correct IP/UDP checksums, and successful RX descriptor reuse. The isolated [UDP integration run 41657019106](https://github.com/Rsan0948/franc/actions/runs/41657019106) **passed** on commit `375d8a5`, including QEMU guest validation and an independently captured outbound UDP query. Six malformed-response rejection/restoration cases and independent host-captured DNS reply checksum checks subsequently **passed** in [UDP run 41663291781](https://github.com/Rsan0948/franc/actions/runs/41663291781) on commit `277d258`. No general UDP socket API, external DNS client, routing, or TCP is claimed.

### Preemption proof milestone

`stage4/interrupts.S` now includes a ring-0 CPU context switching demo. IRQ0 saves and restores all 15 general-purpose registers and hardware IRET frames for the host plus two 16 KiB assembly-only worker stacks. The never-yielding workers require timer preemption to make independent progress. Their code deliberately avoids Franc rational global state and FPU/SIMD. This is **not yet the general Franc fiber scheduler**; kernel user processes, task-local state, nested IRQ handling and Ring 3 remain planned. The proof was independently **verified** by [preemption run 41657885632](https://github.com/Rsan0948/franc/actions/runs/41657885632) on commit `52c90c3`. This branch additionally saves the Franc `ds_ptr` on each IRQ switch, gives each demonstration worker a private rational stack, and has workers run the Franc `fr_push`/`fr_pop` ABI on every iteration. The private-rational-stack CPU preemption proof **passed** in [run 41663713370](https://github.com/Rsan0948/franc/actions/runs/41663713370) on commit `926b848`, including host stack preservation. It is still not an arbitrary Franc JIT scheduler. The dedicated gate is `FRANC_TEST_PREEMPT=1` in `.github/workflows/preempt.yml`.

### Experimental CPL3 isolation increment

The opt-in `stage4/ring3.S` probe establishes a BIOS/QEMU-only 64-bit GDT and TSS kernel stack, creates *one* 4 KiB read/execute user page and *one* 4 KiB read/write user stack at virtual addresses `0x40000000` and `0x40001000`, and leaves kernel identity mappings supervisor-only. It enters CPL3 through a five-field `iretq` frame, makes an `int $0x80` return to the kernel, then attempts a **non-destructive read** of supervisor-mapped kernel memory. The #PF handler must record a user-mode protection fault at `0x10000`, and normal Franc execution must continue afterward.

This is **not** a production Ring 3 process manager. It does not implement general syscall dispatch, arbitrary user executables, per-process CR3, ELF loading, signals, exception recovery for all traps, address-space reclamation, or FPU/SIMD task context switching. It refuses an unfamiliar CR3 layout and cannot run on UEFI. Its `ring3-probe` command is deliberately one-shot and the entire test is isolated behind `FRANC_TEST_RING3=1` and `.github/workflows/ring3.yml`. The independent [Ring 3 workflow 41664139626](https://github.com/Rsan0948/franc/actions/runs/41664139626) passed on commit `16e4777`: the guest executed CPL3 code, returned through INT80, trapped a supervisor-memory read in #PF, resumed the Franc REPL and produced its Franctxt tested-build artifact. These results verify only the bounded one-shot BIOS/QEMU proof, **not** a general process-isolation or recovery facility.


### Proposed next scheduler integration after the isolated context proof

1. Introduce a bounded, typed task-control record (state, code pointer, CPU saved frame, rational-stack base/cursor/limit, ownership and generation ID). Do not reuse the existing cooperative callback table as a preemptive TCB.
2. Add an explicitly opt-in Franc native JIT task launch ABI, with validated code pointers, independent 16 KiB CPU + rational stacks, bounded run/stop/finish rules and safe handling of accidental return. Preserve host REPL state, avoid concurrent JIT compilation and expose deterministic progress counters.
3. Replace globally shared mutable-register assumptions with an explicit task-local policy or per-task state storage. Add stack underflow/overflow checks and nesting/critical-section rules before claiming general Franc preemption.
4. Require a dedicated QEMU test where **two Franc-compiled never-yielding functions** advance under PIT interrupts while retaining distinct rational stack contents, preserving host state and rejecting invalid/finished task launches.
5. Later, integrate timer scheduling with process boundaries and the CPL3 fault/syscall experiment. No process/Ring 3 guarantees should be inferred from this ring-0 proof.

The current change does not introduce a new Franc primitive because editing the compiler's `stage4/aot.frac` requires atomically regenerating and pinning the Franc-generated bootstrap seed and Franctxt seed lock. Keep that as a separately verified integration step, rather than bypass the reproducible bootstrap contract.


### Native Franc JIT preemption — verified bounded kernel-task experiment

Development branch: `stage4-franc-jit-preemption` atop `stage4-udp-scheduler-integration`. This increment registers a bounded native `task-preempt-run` dictionary primitive at boot without modifying the committed Franc-generated AOT seed. The primitive accepts two distinct, exact dictionary-registered Stage 2 JIT entrypoints, requires a started hardware PIT and dispatches them with IRET-based timer switching among host and two 16 KiB private CPU/rational stacks. Every normal task return marks its slot complete; a 120-tick budget retires remaining runnable slots. Native stack push/pop bounds and cooperative host state restoration are checked.

Dedicated integration gate: `.github/workflows/preempt.yml` runs `FRANC_TEST_JIT_PREEMPT=1` to compile **two never-yielding Franc definitions inside QEMU** using `s2-eval`, verify both independent counters advance, ensure the host rational stack survives preemption, reject uninitialized/invalid/same-function launch, and test a third Franc word that returns normally. The old assembly-only proof remains separately exercised. [Preemption workflow 41671071760](https://github.com/Rsan0948/franc/actions/runs/41671071760) first verified the independent Franc JIT scheduling and normal task return on commit `0e47b22`. The stronger [workflow 41672001629](https://github.com/Rsan0948/franc/actions/runs/41672001629) verified independently persisted task-local scalars as well as the original acceptance on commit `e0e8bab`.

**Remaining limits:** only one CPU and two trusted ring-0 JIT workers; a fixed 120-tick batch instead of a permanently running scheduler; no per-task Franc named-register state, secure syscall boundary, FPU/SIMD context, guarded CPU stacks, arbitrary task cancellation or recoverable general CPU faults. Task code must avoid JIT compilation, shared named-register mutation and unsafe native primitives. Do **not** claim a general multi-process OS scheduler based on this proof.


### Explicit task-local scalar slots (verified in QEMU)

The JIT scheduler now exposes `task-local@` and `task-local!` for eight bounded 64-bit integer slots per worker. They reject indices outside 0..7 and host/unowned access; the 2x8 slots are cleared at each launch generation. Two QEMU-compiled never-yielding Franc workers separately increment their own slot zero and the host reads `task-local-a0` / `task-local-b0` for independent-state validation. This is explicit opt-in local state, **not** a transparent conversion of Franc's existing `:named-registers` into task-local values. The augmented [QEMU preemption run 41672001629](https://github.com/Rsan0948/franc/actions/runs/41672001629) passed on commit `e0e8bab`, including independent state, counters, generation resets, and invalid host access checks. Existing named registers still share their original storage; these new slots are the supported explicit task-local path for this restricted proof.


### P3 increment verified: BIOS E820 and sequential Ring 3 fault containment

The [isolated QEMU run 41677382606](https://github.com/Rsan0948/franc/actions/runs/41677382606) on commit `4f9dec8` verified a **real BIOS INT15h E820 map (seven entries)**, bound-checked read-only native memory inventory, and a 4KiB page allocator gate that requires its fixed eight MiB arena to be entirely covered by usable firmware RAM and not overlapped by reserved descriptors. The loader remains 512 bytes using a separate real-mode helper embedded at native kernel +5 and a precise 318-sector packed kernel layout. Franctxt's seed reservation and historical reference packers were updated accordingly.

The same run executed two **sequential assembly CPL3 contexts** backed by different physical code/stack pages at the same user virtual addresses. A faults on a supervisor-only read; the #PF handler records the fault and replaces both user PTEs, reloads CR3, then B executes 50,000 private-memory writes, completes through INT80, and the native Franc REPL resumes. The full proof is documented in [FRANCOS_PROCESS_ISOLATION.md](FRANCOS_PROCESS_ISOLATION.md).

This **does not complete the advertised general multi-process acceptance**. Real concurrent fault tolerance needs a separate TCB and CR3 per Ring 3 process, TSS RSP0 switching, timer-IRQ handoff through user/kernel privilege transitions, a restricted Franc runtime/syscall ABI for user code, and fault isolation for arbitrary user tasks. UEFI GetMemoryMap, guarded stacks and FPU/SIMD state are also still pending. Preserve this distinction in project status.

## FrancOS v1 paired Wave 1: generation-tagged frames and IDE/file surface

**Development PR:** [#6](https://github.com/Rsan0948/franc/pull/6).
**Release state:** Wave 1 remains **open** until both F1 and U1 criteria in
[the binding two-track roadmap](FRANCOS_V1_DUAL_TRACK_ROADMAP.md) pass.

### Track F1 — implemented partial, not process isolation

`stage4/page_owners.S` adds two explicit trusted-kernel page leases:
`proc-lease-begin` (owner -> generation),
`proc-lease-alloc` (owner generation -> zeroed physical page or 0),
`proc-lease-free` (owner generation page -> success),
and `proc-lease-end` (owner generation -> reclaimed count).
Pages are selected only by the existing BIOS E820-approved 8 MiB arena
allocator. The allocator's legacy `page-free` cannot release a tagged page
while its lease is active, and released pages are scrubbed. A stale lease
generation, foreign-owner page, out-of-range frame, double-free or inactive
owner is rejected. The generation counter does not wrap or silently
reissue an exhausted token.

**This is a kernel-side lifecycle/bookkeeping increment, not an access-control
boundary for privileged code.** It neither installs per-process CR3 page table
roots nor restricts identity-mapped memory from trusted Franc kernel code.
Do not advertise it as F1 acceptance, concurrent CPL3, or production process
isolation. Next F1 implementation should assign frames to two distinct,
reservation-aware process address-space roots, enforce supervisor/user PTE
permissions, and prove teardown and cross-process fault isolation in QEMU.

### Track U1/U2 — implemented partial, not an integrated shell

`lib/ide.frac` retains the existing native key-9 source IDE and adds:
cursor insert/delete, line navigation, bounded VGA edit viewport, dirty-state
and file-name storage, in-guest `FRANCFS1` directory listing, and open/new
file prompts. Tab/ESC provide PS/2 keyboard save/back fallbacks while
Ctrl-S/Ctrl-Q remain available over serial. It has a hard source limit
of 2047 bytes; source still runs in the trusted kernel.

**This is not the required v1 home/launcher or package lifecycle.** A
persistent shell with file launch/error states, more complete IDE visual
interaction and a manifest-hashed install/update/rollback/uninstall path
remain to be implemented and tested. See
[the native applications inventory](../stage4/apps/README.md).

### Verification and handoff

- `franctxt/tests/test_process_isolation_contract.py`: assembly symbols,
  owner lease declarations and raw-free guardrails
- `franctxt/tests/test_ide_contract.py`: static rejection of unmatched
  JIT source controls (which previously produced a generic unsupported
  token) and IDE reservation anchors
- `stage4/qemu_roadmap.py`: actual guest checks for lease misuse, generation
  renewal, reclamation, IDE cursor insertion/backspace/save/reload and
  VGA/serial directory listing
- `stage4/qemu_apps.py` and the existing native bootstrap, networking,
  CPL3 and preemption workflows: regression gates

**Status convention:** commits with source and tests are "implemented,
verification pending" until their exact CI execution passes. A passing
earlier image never proves newly edited code. This PR intentionally leaves
`stage4/bootstrap_seed.S` and `franctxt/seed.lock.franctxt` unchanged;
there is no new Franc kernel AOT source or named register declaration.

## Wave 1 integrated acceptance — 2026-11-03 (supersedes the earlier PR #6 status above)

**Status:** The paired Wave 1 **bounded BIOS/QEMU acceptance passed** on
commit `9d7ca5afc1125d2e7ca77754cbfb546c1e8775d9` in
[GitHub Actions run 41696093749](https://github.com/Rsan0948/franc/actions/runs/41696093749).
The user-facing screenshot artifacts and the exact tested-build identity are
[archived with that run](https://github.com/Rsan0948/franc/actions/runs/41696093749).
The clean native bootstrap workflow
[41696093927](https://github.com/Rsan0948/franc/actions/runs/41696093927)
also passed. This is **Wave 1's bounded acceptance**, not the full
seven-step FrancOS v1 release journey.

### F1: real independent address spaces and reclaim under the exact test

- `stage4/process_spaces.S` creates two independently allocated PML4/PDPT/
  PD/PT roots and separate user code/stack physical frames from the approved
  E820 8MiB arena using generation-tagged owner leases.
- A CPL3 context attempts to read B's kernel-supervisor-only physical frame,
  faults, and cannot cross the boundary. B executes separately under its own
  CR3, advances and returns; all 12 frames are scrubbed and reclaimed.
- The QEMU gate proves distinct roots (`0x7000000` and `0x7006000`),
  fault recovery, exact reclamation, and return to the Franc REPL.
  It does **not** prove general concurrent Franc-language user programs or
  public syscall capabilities; the user examples here remain sequential,
  minimal assembly snippets. Wave 2/3 implement the missing runtime.
- The kernel still assumes BIOS/QEMU RAM; UEFI GetMemoryMap and production
  guard pages/memory protection are outside the bounded claim.

### U1: real Home, files and app navigation in the guest

- `stage4/kernel.frac` now boots to a VGA/serial `FrancOS HOME` with an
  arrow-selected 1–9 app list, direct lazy-loading app shortcuts, file UI
  `z`, package UI `m`, REPL `r`, help, and Esc/back paths.
- `stage3/storage.frac` adds bounded delete and rename; the Home file
  surface supports keyboard-only create/open/rename/delete with errors.
  A real QEMU test creates and renames source, cold-boots a second guest to
  verify persistence, deletes it and cold-boots a third guest to verify
  absence. This is **not** a journaled power-loss-safe filesystem.
- The 320x200 BIOS VGA raster now uses correctly ordered
  `vc-glyph` arguments. A previous QEMU screenshot exposed garbled glyphs
  despite correct serial output; the fix was regenerated/pinned into the
  Franc self-hosted seed and verified by comparing the Home's first glyph
  against the compiled font. Five real Home/selection/Files/Packages/IDE
  framebuffer captures from the passing run were reviewed for legibility.
- Original apps and the native IDE remain accessible. The existing package
  UI exposes the **bounded source** manager, not the Wave 3 offline manifest,
  dependencies, update or rollback requirement.

### Handoff into Wave 2

Work has begun in
[`francos-v1-wave2-ring3-scheduler-ide`](https://github.com/Rsan0948/franc/tree/francos-v1-wave2-ring3-scheduler-ide)
([PR #7](https://github.com/Rsan0948/franc/pull/7)). Its F2 milestone
includes IRQ0-preempted CPL3 assembly contexts, private CR3/TSS kernel-stack
switching, bounded retirement and A-fault/B-survivor checks. The first F2-only
[QEMU run 41693664594](https://github.com/Rsan0948/franc/actions/runs/41693664594)
passed. This is **not yet Franc-compiled userland or a complete syscall ABI**.
The U2 side builds the IDE's line home/end, forward delete, full-buffer
feedback and compile/run a newly defined `main`; its expanded QEMU gate
must pass on the same updated branch before claiming full Wave 2 acceptance.

**Release discipline:** Do not mark any additional Wave completed or tag v1
based on this section. Each requires the paired gates in
[the binding v1 contract](FRANCOS_V1_DUAL_TRACK_ROADMAP.md).
