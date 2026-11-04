# Contributing to FrancOS

FrancOS is a small experimental operating system and programming language.
The main release baseline is `francos-v1.0-experimental`; current development
must not rewrite that tag.

## Getting started

Required for the native BIOS build: GNU assembler, linker and objcopy,
make, sh/bash, awk, dd and QEMU x86-64. Python 3 is used for host tests only.
From a supported x86-64 Linux development environment:

```sh
python3 -m franctxt.build preflight
make -f stage4/Makefile.native native-proof
python3 stage4/qemu_home.py stage4/native_seed.img
```

The full native proof boots and rebuilds two additional generations in QEMU.
Do not substitute a source-level test for guest execution.

For a focused change, run relevant unit and QEMU suites and record the exact
commit tested. Native application sources are listed in
`stage4/app_sources.list`. Kernel inputs are listed in
`stage4/seed_sources.list`; changing them requires an explicit
reproducible bootstrap seed and Franctxt lock repin.

## Pull requests

- Explain what behavior changes, what does not, and the tests performed.
- Keep kernel, compiler, UI and repository moves in reviewable increments.
- Preserve serial fallback and actual framebuffer tests for graphical changes.
- Keep private data and credentials out of commits, tests and screenshots.
- Avoid claiming production security or compatibility with untested hardware.
- For architectural questions, see `docs/REPO_ARCHITECTURE.md` and
  `docs/FRANCOS_V1_RELEASE_CANDIDATE.md`.

The project may remain private until its maintainer elects to publish it.
