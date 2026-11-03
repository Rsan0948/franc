# FrancOS v1 — two-track release contract

**Status:** Proposed release scope, not a claim that the following work is complete.  
**Authority:** This document defines the FrancOS v1 finish line. [FRANCOS_NEXT_MILESTONES.md](FRANCOS_NEXT_MILESTONES.md) remains the detailed engineering backlog and [stage4/apps/README.md](../stage4/apps/README.md) remains the as-built app inventory.  
**Target:** A cohesive, single-user **experimental x86-64 Franc operating system in QEMU**. It is not a production-secure, broadly portable replacement for a general-purpose OS.

## Release principle

**FrancOS is not v1-complete with only a good kernel, and it is not v1-complete with only a beautiful shell.** Two equally binding tracks must converge:

- **Track F — Fundamentals and networking:** native boot/self-hosting, physical and virtual memory, actual Franc user processes, preemptive task control, a narrow syscall boundary, fault containment, storage and the networking capabilities required by the OS.
- **Track U — User experience and applications:** usable application launcher/shell, full-screen source IDE, native file workflow, an actual package lifecycle, consistent graphical/text UI, dependable built-in apps and visible error/recovery states.

Each integration wave must ship a testable increment from **both** tracks. Never declare a wave complete if its user-facing half has been deferred. Do not add random new subsystems to make up for unfinished acceptance tests.

## What exists today — verified building blocks, not the finished interface

| Area | Implemented/proved | Exact boundary |
| --- | --- | --- |
| Native language & boot | Franc-compiled/self-hosted generations 2–3 reproduce byte-for-byte, BIOS and OVMF kernel boot, native JIT/REPL | GNU assembler/linker still used; UEFI graphical path absent |
| Scheduling | Timer-preempted *ring-0* Franc JIT code, private CPU/rational stacks and eight explicit scalar locals per worker | Fixed two-worker/120-tick experiment; not concurrent Ring 3 processes; named registers remain shared |
| Memory and isolation | Bounded BIOS E820 inventory, firmware-validated fixed 8 MiB allocator, separate physical user pages, expected CPL3 fault of A followed by successful B execution | A and B execute sequentially using assembly snippets, not isolated concurrently scheduled Franc apps |
| Networking | e1000 DMA, ARP, IPv4/ICMP, bounded native UDP/DNS exchange in QEMU | No general socket abstraction, TCP/HTTP or production network service |
| Application access | Native app menu, interactive Franc REPL, calculator, editor, Stern–Brocot explorer, crosshair/Ford/spirograph and demos; 12 original libraries bundled | Menu is keyboard/command-driven, and currently loaded Franc source runs with kernel privilege |
| IDE | `lib/ide.frac` supports insert/delete/append, save/reopen, JIT compile and menu key `9`; QEMU checks this workflow | 2,047-byte file cap, no true cursor-addressed full-screen view, scrollable edit viewport or diagnostics |
| Packages | `lib/pkg.frac` can `pkg-install`, `pkg-load`, `pkg-list` using persistent FRANCFS1 source slots | 12 slots of <=2,047 bytes each; no package manifest/version/dependency model, remove/update/rollback, or remote repository |
| Language libraries | Partial bignum/IEEE-754 bit interpretation/FrancLite expression support | Not general signed bignum, full floating arithmetic or statement-language compiler |
| Visual environment | Franc VGA framebuffer, 8x8 text and demos with native pixel checks | BIOS 320x200/40-column text environment; not a windowing desktop, no general UEFI GOP UI |

Evidence: [native AOT/self-hosting](https://github.com/Rsan0948/franc/actions/runs/41678295866), [process fault survival](https://github.com/Rsan0948/franc/actions/runs/41678295360), [native app suite](https://github.com/Rsan0948/franc/actions/runs/41678295686), [UDP](https://github.com/Rsan0948/franc/actions/runs/41678295492). These are evidence for the **specific existing tests** only.

## Track F — fundamentals, networking and process correctness

### F1. Process-owned memory and lifecycle

Provide bounded task-control records (PID/generation, runnable/blocked/finished/faulted state, owner, limits); real per-process page-table roots and explicitly reserved mapped pages; private CPU and Franc stacks; safe zeroing/reclamation and invalid-PID handling. Use E820-authorized BIOS RAM, and never assume UEFI RAM is usable without a UEFI memory-map handoff.

**Exit test:** construct two independent address spaces, demonstrate that one cannot read/write the other or the kernel, reclaim/reuse frames without stale mappings, and prove no kernel/firmware reservation overlap.

### F2. Preemptive Ring 3 scheduler and constrained syscall ABI

Extend the proven timer handler to CPL3->CPL0 interrupt frames, per-task kernel-stack/TSS RSP0 selection, bounded critical sections and safe return/resume. Implement *only* the syscalls needed for v1: console/input, process control, bounded memory and file/package I/O. Reject invalid pointers, permissions and handles. Handle integer register/flags state correctly; save any enabled FPU/SIMD state or forbid such instructions until it is supported.

**Exit test:** two user contexts progress without yielding; process exit, invalid syscall and timeout cannot corrupt the kernel, host REPL or another task.

### F3. Actual Franc user programs and fault recovery

Define a bounded, auditable user-mode Franc ABI; do not simply point the current privileged JIT at CPL3. Separate trusted compiler/kernel helpers from executable user-code pages and task-local named-register state. The test processes must be **compiled from Franc source**, not only assembly stubs.

**Exit test:** A and B run as separately scheduled Franc programs. A triggers an illegal memory access while B is runnable; A is terminated and cleaned up, B continues from its saved state, and another Franc program can launch afterward.

### F4. Networking and persistent-service contracts needed for v1

Make the existing NIC/UDP/DNS functionality reusable through bounded, testable calls and errors, not one-off QEMU demo words. Keep storage and application/package operations crash-safe enough for the v1 workflow. Add a minimal **controlled repository transport only if an online package workflow is made a v1 gate**; do not silently claim HTTP/TLS, secure downloads or unrestricted networking.

**Exit test:** independent packet send/receive with bad-data/timeout cases and verified packet capture; file persistence after cold reboot; no networking failure can hang the UI or compromise the kernel. General TCP, web browsing and a public software registry are **not** core v1 requirements.

## Track U — usability, visual identity and applications

Track U is **not v2**. It must be planned, implemented, reviewed and regression-tested continuously alongside Track F.

### U1. One coherent shell, app launcher and file workflow

Turn the existing keyboard menu and REPL into a navigable FrancOS home surface with consistently named apps, visible selected item, status/help bar, keyboard shortcuts, error messages, back/exit behavior and task status. Add a user-facing file list/open/save/create/rename/delete workflow that surfaces capacity and failure states. Maintain serial/text fallback; use framebuffer rendering where BIOS provides it. Do not assume a mouse, GPU driver or compositor.

**Exit test:** using only QEMU keyboard/serial input, a fresh user can find and launch the IDE, calculator, graphics demos and package manager, find saved files and return to the launcher without learning private REPL word names. The existing apps remain launchable.

### U2. A real bounded source IDE

Evolve `lib/ide.frac` from a line-command buffer into an actual on-screen, keyboard-controlled multiline editor: cursor movements, insertion/deletion at the cursor, vertical/horizontal viewport or wrapped lines, load/save, file name/dirty state, readable compiler errors, and a visible compile/run command. Handle full buffers/invalid files without losing existing text. Expand the 2,047-byte persisted-source limit **through a deliberate storage change** before advertising larger files; don't merely enlarge the RAM buffer. Highlighting and an undo step are desirable, but basic editing correctness and persistence come first.

**Exit test:** launch IDE from home; create and edit a multi-line Franc program, move/edit in the middle, save it, reboot, reopen it, compile and run it. Verify bounds, error reporting, and persistence with automated keyboard interactions plus a visual reference capture.

### U3. A package manager with a genuine lifecycle

Extend `lib/pkg.frac` into an accessible native package UI/CLI with a canonical **Franctxt-compatible** package manifest: identity, version, dependencies, installed-file inventory and SHA-256 content identity. Support listing/searching a **bounded trusted local repository**, dependency-order install, duplicate/invalid dependency handling, update, uninstall, and rollback or safe failure without corrupting already installed source. Address the 12-file/2,047-byte limitation rather than claiming large packages fit today. Show installed versions and actionable errors. Distinguish *package storage* from *executing code*: packages must not automatically execute trusted-kernel words simply by being installed. Prefer running installed application code through the isolated Franc user-mode boundary when F3 is available.

**Exit test:** from the user interface, install a small app with a dependency from a bundled/local repository, verify each file's hash, launch it, upgrade it, demonstrate failure/rollback, uninstall it, and confirm state after cold reboot. This **offline-capable lifecycle is required for v1**; a public internet-backed repository, automatic updates and general dependency solving are not. Any remote fetch must pass its own network and trust checks before release.

### U4. Consistent visual system and OS demonstration

Define one style/interaction contract for home, files, IDE, packages, console and errors: 320x200 BIOS VGA as a **real**, legible, keyboard-first v1 target, not a throwaway pixel demo; predictable spacing, contrast, focus, shortcuts and status indicators. Keep the existing calculator and drawing demos usable and regression-tested. Provide text/serial behavior when graphics are unavailable; document that the current UEFI boot does not have GOP rendering.

**Exit test:** a full QEMU interaction/screenshot review of the home screen, IDE, package view, file browser, error dialog and representative app, plus keyboard-driven integration tests for each. No blank placeholder screen or hidden REPL command is acceptable as the *only* access to a headline v1 feature.

## Four paired integration waves: neither track gets to fall behind

| Wave | Fundamentals deliverable | User-facing deliverable | Wave is done only when... |
| --- | --- | --- | --- |
| 1. Own the state | F1 process records / address-space ownership | U1 launcher, file navigation and coherent status/errors | Protected storage and an understandable navigation flow both pass QEMU |
| 2. Run and edit | F2 IRQ-preempted Ring 3 entry/syscalls | U2 full-screen, persisted IDE | Two schedulable contexts **and** editor create/edit/save/reboot/compile work |
| 3. Ship software | F3 Franc compiled-user-mode execution and fault isolation | U3 package manifest/install/update/uninstall/rollback | A fault cannot kill B **and** an installed package can be managed and run |
| 4. Make it a system | F4 reusable minimal network/storage contracts | U4 cohesive UI and existing-app polish | Full end-to-end user journey passes, with no infrastructure/UX regression |

The waves are **order/acceptance contracts**, not claimed schedules or automatic commitments. Work can be split into smaller PRs, but do not close a wave on a kernel-only demonstration.

## The release-blocking v1 demo: one contiguous user journey

1. Cold-boot the C-free FrancOS kernel in BIOS/QEMU to a navigable home UI, with the apps accessible without the REPL.
2. Open the IDE, write a multi-line Franc program, edit existing text via cursor controls, save and close.
3. Reboot, browse files, reopen that source, compile and launch it as an isolated Franc user process.
4. Open Packages, install an application with a dependency from the trusted offline repository, verify identities, use it, upgrade/rollback and uninstall it. State survives reboot.
5. Start two Franc user applications; deliberately fault A while B is runnable; verify B continues, the kernel REPL/shell remains available and a replacement app launches.
6. Demonstrate the bounded networking capability, deliberate network failure behavior, calculator/graphics apps, and normal return to home.
7. Run all independent QEMU, native bootstrap, Franctxt, disk-integrity, scheduler, network and user-experience tests. Record the exact tested-build identity. Inspect the actual framebuffer/terminal screens, not only markers in a log.

**Release decision:** all seven steps and both tracks' wave gates pass on the same integrated branch and image -> tag `francos-v1.0-experimental`. Any missing step remains visibly **open**, regardless of unrelated new features. A passing structural test or historical CI run is not a substitute for a new integrated acceptance.

## Scope discipline: what deliberately waits

- **Not needed for v1:** a compositing desktop/window manager, mouse/USB stack, broad GPU drivers, secure boot, SMP, generic hardware support, a web browser, production TCP/HTTP/TLS stack, public signed package registry, automatic remote update service, full IEEE-754 numeric tower, general-purpose optimizer and full FrancLite statement language.
- **Still valuable after v1:** richer IDE diagnostics/highlighting/undo, package repository networking with verified authenticity, UEFI GOP, larger filesystem, broader language/runtime parity, more complex graphics and windowing. These are not abandoned, but are not prerequisites for the bounded QEMU v1 claim.
- **Do not downgrade the required UX:** a usable editor, package lifecycle, files, launcher and cohesive visual interaction **are v1 release blockers**. If F1–F4 finish first, the release stays open until U1–U4 also pass.
- **No endless feature list:** new ideas go to a post-v1 backlog unless an existing gate cannot work without them. Measure completeness by the user journey and QEMU evidence, not module count, commits or percent guesses.

## Evidence and ownership

The engineering source of truth is the authoritative `stage4-roadmap-foundations` branch. Preserve Franc-generated bootstrap seed and `franctxt/seed.lock.franctxt` integrity when changing the compiler; the UEFI firmware adapter may remain C, but the kernel/compiler/runtime must remain Franc and assembly. User-facing changes must be tested in a real guest, preferably with a deterministic keyboard script and reviewed framebuffer capture. Always mark work separately as *specified*, *implemented*, *QEMU-verified*, and *release-integrated*.

**Decision to revisit only if necessary:** an actual networked package repository. v1 requires a dependable, on-device *offline* package lifecycle, not a general-purpose internet distribution stack. If a network package fetch is added, constrain it to an explicit trusted endpoint/manifest and make transport+authenticity checks independently testable.
