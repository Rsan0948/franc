# Contributing to FrancOS

FrancOS is a self-hosting operating system and programming language, built
entirely by AI with Rubén Sánchez providing design direction and taste oversight.
Contributions help improve the language, apps, system, and developer experience.

## Get started

The native BIOS build uses GNU binutils, Make, sh/bash, awk, dd, and QEMU
x86-64. Python 3 runs host tests and build-identity checks. From x86-64 Linux:

```sh
python3 -m franctxt.build preflight
make os
make os-proof
python3 stage4/qemu_home.py build/out/francos-bios.img
```

`make os-proof` boots and rebuilds two additional generations inside QEMU,
then compares their output. See the [build guide](docs/BUILD_AND_TEST.md)
for graphical launch, UEFI, and focused app tests.

## Work in the active source tree

The canonical directories are `boot/`, `compiler/`, `runtime/`, `kernel/`,
`drivers/`, `system/`, `apps/native/`, and `lib/`. Edit these sources directly.
`build/app_sources.list` orders the app bundle; `build/seed_sources.list`
orders kernel inputs. Kernel-input changes require regenerating the bootstrap
seed and Franctxt lock together and verifying reproducible generations.

Historical stage paths provide compatibility aliases; `archive/stages/`
preserves the original snapshots. The [architecture guide](docs/REPO_ARCHITECTURE.md)
explains source ownership. For structural changes, run:

```sh
python3 tools/verify_architecture_layout.py
make os-proof
```

## Submit a pull request

- Describe the user-visible behavior, implementation, and relevant test results.
- Keep kernel, compiler, UI, and repository changes in reviewable increments.
- Test graphical changes with keyboard journeys and framebuffer captures.
- Exercise affected behavior in a booted guest and record the commit tested.
- Keep credentials and private data out of source, logs, and screenshots.
- Describe hardware and execution support using the targets actually tested.

Published tags preserve their tested source and artifacts. Further development
receives a new commit and release identity.

For numerical behavior, see the
[mathematical foundation](docs/MATHEMATICAL_FOUNDATION.md). For privilege and
trust boundaries, see the [security policy](SECURITY.md).
