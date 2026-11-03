# FrancOS v1 — Wave 4 completed (F4 + U4)

**Accepted on November 3, 2026:** [Wave 4 PR #15](https://github.com/Rsan0948/franc/pull/15), source head `a92563aca5d2b0cdc6979d53b02503c005ffb16f`. All **14/14 GitHub Actions suites passed**; merged to `main` as `1b0d101957d8736a8910696aec53194560dbe462`. This closes all four paired waves. The exact-main release tag is gated separately; see [the release record](FRANCOS_V1_RELEASE_CANDIDATE.md).

## F4: reusable native networking and persistence

`lib/services.frac` provides bounded e1000/ARP/IPv4/UDP/DNS and FRANCFS1 operations with explicit error states and no infinite polling. QEMU PCAP verifies real NIC traffic, malformed replies and timeout behavior. Persisted IDE files and verified package state survive cold reboot. The test also simulates an interrupted inactive package-bank update, proving that the previous verified version remains selectable; arbitrary torn-sector writes are not claimed crash-atomic.

## U4: consistent user-facing OS

`lib/ui.frac` defines a keyboard-first VGA/serial title, divider, help, error, success and status vocabulary shared by IDE, Packages and network diagnostics alongside the pinned Home/Files screens. The on-device editor supports bounded multiline cursor editing and a visible isolated-CPL3 run option. The GUI package manager offers offline install, versions, pinned dependencies, update/rollback/uninstall and fault-contained user launch. Calculator and drawing demos remain launchable without hidden REPL commands.

## Single persistent-disk seven-stage acceptance — verified

The [Wave 4 QEMU journey](https://github.com/Rsan0948/franc/actions/runs/41734417319) cold-boots one BIOS image, launches Home/Calculator/graphics, edits multiline Franc in the on-screen IDE via real keyboard and PS/2 cursor movement, saves and reopens after reboot, executes audited Franc-compiled CPL3 code in independent process spaces, faults A while B survives, reclaims frames and launches a replacement. From the visible Packages UI it installs an app with dependency, runs it, upgrades and rolls it back, rejects invalid uninstall, removes both packages and verifies cold-boot persistence. It also checks bounded network failure, live DNS traffic and independent host-side PCAP evidence, and captures **18 real nonblank VGA screenshots** (all inspected).

The [separate Wave 3 package workflow](https://github.com/Rsan0948/franc/actions/runs/41734417375), native bootstrap, BIOS/UEFI, prior waves, apps, Franctxt and networking all passed on the same PR head. The main-branch release workflow will rebuild and retest the main-commit-specific image before publishing any experimental v1 tag.

**Boundaries:** The native trusted JIT remains CPL0. Only the narrow compiler form `def main N count fault|again ;` with `N=1..255` is admitted to CPL3. Packages are two fixed IDs with small sources and trusted local manifests, not an online repository. No filesystem journaling, TCP/TLS, UEFI graphics, general hardware portability or production security is claimed.
