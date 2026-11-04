#!/usr/bin/env python3
"""Ensure the standard-layout FrancOS build owns all active native source.

Historical stage paths may remain as symlinks for pinned seeds and existing
CI, but the authoritative source bytes live under subsystem directories.
All checks are read-only and safe to run without building QEMU images.
"""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
MOVED = {
    "stage2/compiler.frac": "compiler/native/compiler.frac",
    "stage3/ata.frac": "drivers/storage/ata.frac",
    "stage3/storage.frac": "drivers/storage/storage.frac",
    "stage4/boot.S": "boot/bios/boot.S",
    "stage4/bootstrap_seed.S": "compiler/bootstrap_seed.S",
    "stage4/runtime.S": "runtime/abi.S",
    "stage4/font.S": "drivers/video/font.S",
    "stage4/font8x8.bin": "drivers/video/font8x8.bin",
    "stage4/gop_console.S": "drivers/video/gop_console.S",
    "stage4/display.frac": "drivers/video/console.frac",
    "stage4/keyboard.frac": "drivers/input/keyboard.frac",
    "stage4/e820.S": "kernel/memory/e820.S",
    "stage4/page_owners.S": "kernel/memory/page_owners.S",
    "stage4/process_spaces.S": "kernel/process/process_spaces.S",
    "stage4/ring3.S": "kernel/process/ring3.S",
    "stage4/user_compiled.S": "kernel/process/user_compiled.S",
    "stage4/user_scheduler.S": "kernel/scheduler/user_scheduler.S",
    "stage4/scheduler.S": "kernel/scheduler/scheduler.S",
    "stage4/interrupts.S": "kernel/interrupts/interrupts.S",
    "stage4/aot.frac": "compiler/aot.frac",
    "stage4/bundle.frac": "compiler/bundle.frac",
    "stage4/repl.frac": "system/repl.frac",
    "stage4/upgrade.frac": "system/upgrade.frac",
    "stage4/kernel.frac": "kernel/main.frac",
    "stage4/tasks.frac": "kernel/scheduler/tasks.frac",
    "stage4/fibers.frac": "kernel/scheduler/fibers.frac",
    "stage4/net.frac": "drivers/network/net.frac",
    "stage4/pci.frac": "drivers/network/pci.frac",
    "stage4/ip.frac": "drivers/network/ip.frac",
    "stage4/udp.frac": "drivers/network/udp.frac",
    "stage4/apps/registry.frac": "apps/native/registry.frac",
    "stage4/apps/native-compat.frac": "apps/native/native-compat.frac",
    "stage4/apps/native-programs.frac": "apps/native/native-programs.frac",
    "stage4/kernel.ld": "kernel/kernel.ld",
    "stage4/uefi/loader.c": "boot/uefi/loader.c",
    "stage4/uefi/uefi.h": "boot/uefi/uefi.h",
}
APP_ALIASES = {
    "stage4/apps/native-compat.frac": "apps/native/native-compat.frac",
    "stage4/apps/native-programs.frac": "apps/native/native-programs.frac",
    "stage4/pci.frac": "drivers/network/pci.frac",
    "stage4/tasks.frac": "kernel/scheduler/tasks.frac",
    "stage4/net.frac": "drivers/network/net.frac",
    "stage4/ip.frac": "drivers/network/ip.frac",
    "stage4/udp.frac": "drivers/network/udp.frac",
    "stage4/fibers.frac": "kernel/scheduler/fibers.frac",
}
KERNEL_ALIASES = {
    "stage3/ata.frac": "drivers/storage/ata.frac",
    "stage3/storage.frac": "drivers/storage/storage.frac",
    "stage4/display.frac": "drivers/video/console.frac",
    "stage4/keyboard.frac": "drivers/input/keyboard.frac",
    "stage2/compiler.frac": "compiler/native/compiler.frac",
    "stage4/repl.frac": "system/repl.frac",
    "stage4/upgrade.frac": "system/upgrade.frac",
    "stage4/aot.frac": "compiler/aot.frac",
    "stage4/bundle.frac": "compiler/bundle.frac",
    "stage4/apps/registry.frac": "apps/native/registry.frac",
    "stage4/kernel.frac": "kernel/main.frac",
}


def manifest(path):
    return [line.strip() for line in (ROOT / path).read_text().splitlines()
            if line.strip() and not line.lstrip().startswith("#")]


def check():
    for historical, canonical in MOVED.items():
        old = ROOT / historical
        new = ROOT / canonical
        if not old.is_symlink() or not new.is_file():
            raise AssertionError(f"Source ownership not migrated: {historical} -> {canonical}")
        if old.resolve() != new.resolve():
            raise AssertionError(f"Stage alias diverged: {historical}")
        if new.is_symlink():
            raise AssertionError(f"Active source must be an ordinary file: {canonical}")
        archived = ROOT / "archive" / "stages" / historical
        if not archived.is_file():
            raise AssertionError(f"Missing archived milestone: {archived}")
        if old.read_bytes() != new.read_bytes():
            raise AssertionError(f"Legacy alias bytes changed: {historical}")
    for old_list,new_list,map_ in (
        ("stage4/seed_sources.list", "build/seed_sources.list", KERNEL_ALIASES),
        ("stage4/app_sources.list", "build/app_sources.list", APP_ALIASES),
    ):
        original = manifest(old_list)
        current = manifest(new_list)
        if [map_.get(path,path) for path in original] != current:
            raise AssertionError(f"Canonical source manifest order changed: {new_list}")
        if len(original) != len(set(original)):
            raise AssertionError(f"Duplicate native sources: {old_list}")
        for old,new in zip(original,current):
            if (ROOT / old).read_bytes() != (ROOT / new).read_bytes():
                raise AssertionError(f"Bundle content changed: {old} vs {new}")
    for path in ("build/Makefile.native","build/bootstrap.sh","build/pack_image.sh",
                 "build/source_pack.sh","boot/uefi/Makefile",
                 "kernel/kernel.ld","compiler/bootstrap_seed.S"):
        if not (ROOT / path).is_file():
            raise AssertionError(f"Missing primary native build source: {path}")
    print(f"PASS: {len(MOVED)} canonical FrancOS source modules and both ordered "
          "manifests exactly match the historical bootstrap-compatible views")
    print("PASS: original stage snapshots retained under archive/stages")
    print("NOTE: stage compatibility aliases are intentional until historical "
          "QEMU tests are ported; build/Makefile.native is the new live entrypoint")


if __name__ == "__main__":
    try:
        check()
    except (AssertionError, OSError) as exc:
        print(f"ARCHITECTURE ERROR: {exc}", file=sys.stderr)
        sys.exit(1)
