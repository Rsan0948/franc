# Historical FrancOS stages — source archive

This directory preserves the original files from the Stage 1–4 development
layout at the time of the architecture migration.

- **stage1/** — early BIOS, hosted runtime and legacy image tests
- **stage2/** — Franc native compiler prototype
- **stage3/** — Franc-written storage, console and device prototypes
- **stage4/** — native self-hosting kernel, BIOS/UEFI adapters, QEMU tests and launch groundwork

These are **historical snapshots**, not an alternative authoritative OS
kernel. Do not fix bugs by editing this archive. See the canonical live
source tree in [docs/REPO_ARCHITECTURE.md](../docs/REPO_ARCHITECTURE.md).

Some old stage paths remain as deliberate compatibility links or test
wrappers so pinned seed identities and historical tests can still run.
Stage snapshots remain unchanged and are also independently available
under the immutable released Git tags.

Modern development entrypoint: **make os** / **make os-proof**.
