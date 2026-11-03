# FrancOS v1 — Wave 4 initial paired implementation

**Status: Started, not complete.** The complete acceptance contract is [FRANCOS_V1_DUAL_TRACK_ROADMAP.md](FRANCOS_V1_DUAL_TRACK_ROADMAP.md). Wave 3 is now accepted and merged to `main` ([PR #14](https://github.com/Rsan0948/franc/pull/14), 17/17 green suites). This Wave 4 draft [PR #15](https://github.com/Rsan0948/franc/pull/15) has been retargeted to `main` and its dedicated initial networking/VGA QEMU suite passed. The full v1 consolidation and release test have **not** been performed.

## F4 — bounded service API

New `lib/services.frac` exposes bounded, explicit return-code contracts over the *existing* Franc e1000/ARP/IPv4/UDP and FRANCFS1 drivers: `svc-storage-ready`, `svc-storage-load`, `svc-net-open`, `svc-net-ready`, `svc-dns-poll`, `svc-dns-request` and `svc-net-info`.

The DNS helper may not hide network initialization or assume a peer is configured. It distinguishes invalid state, failed TX, bad response and expired poll budget. Its receive loop always consumes a ready descriptor, and refuses zero or over-limit budgets. Native QEMU test sends a second DNS request after the normal UDP/PCAP proof and verifies the response, with malformed network frames already covered by the earlier independent packet tests. No TCP/HTTP, TLS or a public package repository is claimed.

## U4 — shared VGA/serial interaction primitives

New `lib/ui.frac` provides a common top bar and high-contrast divider, key help, error, success and status text, all through `vc-type` (so every visible string also appears on serial for headless users). The verified native package UI now uses that rendering contract, including an explicit fail-closed message rather than a numeric or silent failure. No mouse or compositor is required.

The first Wave 4 screenshot gate opens Home/Files/Packages/IDE by keyboard, verifies the new package header and captures the actual framebuffer. The existing editor remains fully reachable.

## Remaining release-blocking Wave 4 work

- Bring **Home, Files, IDE, Packages, status/errors and the terminal** under one consistent layout and focus/keyboard contract. Do not edit kernel-seed source without regenerating the pinned Franc bootstrap seed and its Franctxt lock and proving generations 2 and 3.
- Complete a single end-to-end QEMU interaction journey: make/edit/reboot/run a Franc user program, offline dependency install/update/rollback/uninstall, A fault with B surviving and a replacement task, bounded network success/error and representative calculator/drawing app. Capture every named VGA screen and prove same-build digests.
- Keep persistent package transactions/recovery robust under interruption, with precise limitations of FRANCFS1 directory-sector writes. Do not advertise crash-atomicity where it is not proven.
- Verify BIOS framebuffer and serial fallback; UEFI GOP remains out of scope.

**Boundaries:** The existing trusted JIT/REPL may still execute developer source in CPL0. The package pathway itself must use audited Franc-emitted CPL3 bytes, and it must not silently invoke CPL0 source execution on install.
