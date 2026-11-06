# Franc documentation

Franc is a stack-based language with exact rational arithmetic. FrancOS brings
its native compiler, kernel, drivers, and applications together in a
self-hosting operating system.

## Get started

- [Build and run](BUILD_AND_TEST.md): toolchain setup, BIOS/UEFI launch,
  persistent disks, and verification commands.
- [Apps and libraries](../apps/native/README.md): calculator, Notes, graphics,
  source editor, keyboard controls, and reusable libraries.
- [Screenshots](screenshots/README.md): guest captures and their source records.

## Language and formats

- [Mathematical foundation](MATHEMATICAL_FOUNDATION.md): the rational model,
  exceptional values, numerical bounds, and library examples.
- [Franctxt](../franctxt/README.md): typed configuration, canonical documents,
  content identities, and signature tools.

## System development

- [Architecture](REPO_ARCHITECTURE.md): active subsystems, source ownership,
  ordered manifests, and historical compatibility paths.
- [UEFI adapter](../boot/uefi/README.md): firmware handoff and graphics setup.
- [UI design](FRANCUI_DESIGN.md): interaction principles and display backends.
- [Contributing](../CONTRIBUTING.md): development and pull-request workflow.
- [Security](../SECURITY.md): execution model, trust boundaries, and reporting.

## Development records

These documents record particular milestones and their acceptance criteria:

- [Stage 4 bootstrap history](STAGE4_DEV_HISTORY.md)
- [Stage 4+ implementation](STAGE4_PLUS_ROADMAP.md)
- [Process isolation](FRANCOS_PROCESS_ISOLATION.md)
- [V1 release contract](FRANCOS_V1_DUAL_TRACK_ROADMAP.md) and [acceptance record](FRANCOS_V1_RELEASE_CANDIDATE.md)
- [V1.1 release notes](RELEASE_NOTES_V1_1.md)
- [Integration validation](INTEGRATION_FIX_VALIDATION.md)
- [Self-hosting and parity plan](SELF_HOSTING_AND_PARITY_PLAN.md)
- [Earlier project history](HISTORY_FROM_README_2026.md)
- [Original stage snapshots](../archive/README.md)

[Open-source launch checklist](OPEN_SOURCE_LAUNCH.md) · [Release media](RELEASE_MEDIA.md)
