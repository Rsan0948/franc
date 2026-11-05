"""Franctxt-driven FrancOS build authority (host-side orchestration).

The Franc kernel/compiler and the clean self-hosting rebuild remain Python/C
free. This tool *verifies* tracked source and binary identities; it never
generates native kernel machine code or signs releases.
"""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path, PurePosixPath
import re
import sys

from . import FranctxtError, canonical, digest, parse, validate_kernel
from .memory import check_memory_map

ROOT = Path(__file__).resolve().parents[1]
SEED_SOURCE_LIST = "stage4/seed_sources.list"
APP_SOURCE_LIST = "stage4/app_sources.list"
SPEC_PATH = "franctxt/build.franctxt"
LOCK_PATH = "franctxt/seed.lock.franctxt"
SEED_PATH = "stage4/bootstrap_seed.S"
REGISTRY_PATH = "stage4/apps/registry.frac"
COMPILER_PATH = "stage2/compiler.frac"
AOT_PATH = "stage4/aot.frac"
APP_MARKER = 1024 * 512
DICTIONARY_ENTRIES = 4096
APP_START = 1025 * 512
KEY_RE = re.compile(r"(?<![A-Za-z0-9_-]):([a-z][a-z0-9-]*)")
STR_RE = re.compile(r'"(?:\\.|[^"\\])*"')
DEF_RE = re.compile(r"^def ", re.M)


class BuildAuthorityError(FranctxtError):
    pass


def sha256(data: bytes) -> str:
    return "sha256:" + hashlib.sha256(data).hexdigest()


def full_path(root: Path, path: str) -> Path:
    if (not path or PurePosixPath(path).is_absolute()
            or ".." in PurePosixPath(path).parts or "\\" in path):
        raise BuildAuthorityError(f"unsafe source path: {path!r}")
    file = (root / path).resolve()
    if not file.is_relative_to(root.resolve()) or not file.is_file():
        raise BuildAuthorityError(f"missing or escaping build input: {path!r}")
    return file


def listed_sources(root: Path, list_path: str) -> list[str]:
    lines = full_path(root, list_path).read_text("ascii").splitlines()
    names = [s.strip() for s in lines if s.strip() and not s.lstrip().startswith("#")]
    if not names or len(names) != len(set(names)):
        raise BuildAuthorityError(f"{list_path}: no source files or duplicate entries")
    for name in names:
        if not name.endswith(".frac"):
            raise BuildAuthorityError(f"unexpected source type: {name}")
        full_path(root, name)
    return names


def packed_apps(root: Path) -> bytes:
    return b"".join(full_path(root, p).read_bytes() + b"\n"
                    for p in listed_sources(root, APP_SOURCE_LIST)) + b"\0"


def seed_inputs_sha(root: Path) -> str:
    h = hashlib.sha256()
    h.update(b"francos-seed-inputs/v1\0")
    for name in listed_sources(root, SEED_SOURCE_LIST):
        h.update(name.encode("ascii") + b"\0")
        h.update(hashlib.sha256(full_path(root, name).read_bytes()).digest())
    return "sha256:" + h.hexdigest()


def expected_seed_lock(root: Path) -> bytes:
    entries = {
        "schema": "francos.seed-lock.v1",
        "seed.aot-sha256": sha256(full_path(root, AOT_PATH).read_bytes()),
        "seed.assembly-sha256": sha256(full_path(root, SEED_PATH).read_bytes()),
        "seed.compiler-sha256": sha256(full_path(root, COMPILER_PATH).read_bytes()),
        "seed.inputs-sha256": seed_inputs_sha(root),
        "seed.registry-sha256": sha256(full_path(root, REGISTRY_PATH).read_bytes()),
        "seed.source-count": len(listed_sources(root, SEED_SOURCE_LIST)),
        "seed.source-list-sha256": sha256(
            full_path(root, SEED_SOURCE_LIST).read_bytes()
        ),
    }
    return canonical(entries)


def check_build_spec(root: Path) -> dict:
    spec = parse(full_path(root, SPEC_PATH).read_bytes())
    required = {
        "schema": "francos.build-authority.v1",
        "system.name": "FrancOS",
        "build.abi": "franc-rat16-v1",
        "build.arch": "x86_64",
        "build.native-seed-required": True,
        "build.seed-list": SEED_SOURCE_LIST,
        "build.app-list": APP_SOURCE_LIST,
        "memory.ram-mib": 128,
    }
    for key, value in required.items():
        if spec.get(key) != value or type(spec.get(key)) is not type(value):
            raise BuildAuthorityError(f"build specification mismatch: {key}")
    return spec


def pin_seed(root: Path) -> str:
    check_build_spec(root)
    lock = expected_seed_lock(root)
    (root / LOCK_PATH).write_bytes(lock)
    return digest(lock)


def check_seed(root: Path) -> str:
    check_build_spec(root)
    lock_path = root / LOCK_PATH
    if not lock_path.is_file():
        raise BuildAuthorityError("missing Franctxt seed.lock: run AOT seed pinning")
    observed = lock_path.read_bytes()
    expected = expected_seed_lock(root)
    if observed != expected:
        old = parse(observed)
        new = parse(expected)
        changed = [key for key in sorted(set(old) | set(new))
                   if old.get(key) != new.get(key)]
        raise BuildAuthorityError(
            "STALE BOOTSTRAP SEED: Franctxt lock disagrees with current "
            f"sources or bootstrap assembly ({', '.join(changed)}). "
            "Regenerate the native seed through the C-free AOT workflow "
            "and pin both seed and lock in one commit."
        )
    return digest(observed)


def declared_registers(code: str) -> set[str]:
    # Strip source comments and quoted text, including colons in strings.
    trimmed = "\n".join(STR_RE.sub('""', line.split("\\", 1)[0])
                        for line in code.splitlines())
    return set(KEY_RE.findall(trimmed))


def check_app_registers(root: Path) -> set[str]:
    """The JIT creates variables as it meets them, so what can run out is dictionary space."""
    declared = declared_registers(full_path(root, REGISTRY_PATH).read_text())
    words = 0
    for name in listed_sources(root, SEED_SOURCE_LIST):
        code = full_path(root, name).read_text()
        declared |= declared_registers(code)
        words += len(DEF_RE.findall(code))
    required = set()
    for name in listed_sources(root, APP_SOURCE_LIST):
        code = full_path(root, name).read_text()
        required |= declared_registers(code)
        words += len(DEF_RE.findall(code))
    # A variable takes two entries: one to read it and one to set it.
    entries = words + 2 * len(declared | required)
    if entries > DICTIONARY_ENTRIES:
        raise BuildAuthorityError(
            f"NATIVE DICTIONARY OVERFLOW: kernel and app bundle need {entries} "
            f"entries of {DICTIONARY_ENTRIES}. Raise S2_DICT_ENTRIES and pin seed."
        )
    return required


def disk_files(image: bytes) -> dict[str, bytes]:
    if image[128 * 512:128 * 512 + 8] != b"FRANCFS1":
        raise BuildAuthorityError("FRANCFS1 header missing")
    entries = {}
    for slot in range(12):
        pos = (129 * 512) + (slot * 32)
        entry = image[pos:pos + 32]
        filename = entry[:24].split(b"\0", 1)[0]
        if not filename:
            continue
        try:
            name = filename.decode("ascii")
        except UnicodeError as exc:
            raise BuildAuthorityError("invalid FRANCFS1 filename") from exc
        length = int.from_bytes(entry[24:26], "little")
        if not (0 < length <= 2047) or name in entries:
            raise BuildAuthorityError(f"invalid FRANCFS1 record {name!r}")
        start = (136 + slot * 4) * 512
        data = image[start:start + length]
        if len(data) != length:
            raise BuildAuthorityError(f"truncated FRANCFS1 file {name}")
        entries[name] = data
    return entries


def verify_image(root: Path, image_file: Path, kernel_file: Path) -> dict:
    check_seed(root)
    check_app_registers(root)
    check_memory_map(root)
    image = image_file.read_bytes()
    kernel = kernel_file.read_bytes()
    files = disk_files(image)
    try:
        manifest = files["kernel.franctxt"]
        config = files["system.franctxt"]
    except KeyError as exc:
        raise BuildAuthorityError("native image lacks Franctxt manifest/config") from exc
    manifest_state = parse(manifest)
    config_state = parse(config)
    if canonical(manifest_state) != manifest or canonical(config_state) != config:
        raise BuildAuthorityError("noncanonical Franctxt persisted on disk")
    validate_kernel(config_state)
    required = {
        "schema": "francos.kernel-build.v1",
        "system.name": "FrancOS",
        "build.kernel-sha256": sha256(kernel),
        "build.config-sha256": digest(config),
        "build.memory-map-sha256": sha256(full_path(root, "franctxt/memory.franctxt").read_bytes()),
        "build.registry-sha256": sha256(full_path(root, REGISTRY_PATH).read_bytes()),
        "build.seed-assembly-sha256": sha256(full_path(root, SEED_PATH).read_bytes()),
        "build.runtime-sha256": sha256(full_path(root, "stage4/runtime.S").read_bytes()),
        "build.boot-sha256": sha256(image[:512]),
        "build.apps-sha256": sha256(packed_apps(root)),
    }
    for key, value in required.items():
        if manifest_state.get(key) != value:
            raise BuildAuthorityError(f"native image is inconsistent: {key}")
    if image[APP_MARKER:APP_MARKER + 8] != b"FRANCSRC":
        raise BuildAuthorityError("native app marker missing")
    packed = packed_apps(root)
    if image[APP_START:APP_START + len(packed)] != packed:
        raise BuildAuthorityError("packed native app bytes diverge from source list")
    if (len(kernel) < 1 or
            image[512:512 + min(len(kernel), 127 * 512)] !=
            kernel[:min(len(kernel), 127 * 512)]):
        raise BuildAuthorityError("image BIOS kernel segment does not match binary")
    return manifest_state


def build_report(root: Path, image: Path, kernel: Path,
                 tests: list[str]) -> bytes:
    manifest = verify_image(root, image, kernel)
    allowed = {"native", "aot", "uefi", "network", "portable", "bootstrap", "apps"}
    if not tests or len(set(tests)) != len(tests) or not set(tests) <= allowed:
        raise BuildAuthorityError("report requires unique known passed test names")
    fields = {
        "schema": "francos.tested-build.v1",
        "build.abi": "franc-rat16-v1",
        "build.apps-sha256": manifest["build.apps-sha256"],
        "build.config-sha256": manifest["build.config-sha256"],
        "build.image-sha256": sha256(image.read_bytes()),
        "build.kernel-sha256": sha256(kernel.read_bytes()),
        "build.seed-lock-sha256": digest((root / LOCK_PATH).read_bytes()),
        "build.source-revision": manifest["build.source-revision"],
    }
    for name in tests:
        fields["test." + name] = "passed"
    return canonical(fields)


def main(argv=None):
    cli = argparse.ArgumentParser(prog="python3 -m franctxt.build")
    cli.add_argument("command", choices=(
        "pin-seed", "check-seed", "check-apps", "check-memory", "preflight", "verify-image", "record"))
    cli.add_argument("--root", type=Path, default=ROOT)
    cli.add_argument("--image", type=Path)
    cli.add_argument("--kernel", type=Path)
    cli.add_argument("--output", type=Path)
    cli.add_argument("--passed", action="append", default=[])
    args = cli.parse_args(argv)
    root = args.root.resolve()
    try:
        if args.command == "pin-seed":
            print("PINNED: Franctxt seed identity " + pin_seed(root))
        elif args.command == "check-seed":
            print("PASS: fresh pinned Franc seed " + check_seed(root))
        elif args.command == "check-apps":
            count = len(check_app_registers(root))
            print(f"PASS: registry accounts for {count} native app register names")
        elif args.command == "check-memory":
            regs = check_memory_map(root)
            print(f"PASS: {len(regs)} nonoverlapping FrancOS physical reservations")
        elif args.command == "preflight":
            ident = check_seed(root)
            regs = check_app_registers(root)
            memory = check_memory_map(root)
            print(f"PASS: Franctxt preflight, {len(regs)} app registers and {len(memory)} safe reservations; {ident}")
        else:
            if args.image is None or args.kernel is None:
                raise BuildAuthorityError("--image and --kernel required")
            image = args.image if args.image.is_absolute() else root / args.image
            kernel = args.kernel if args.kernel.is_absolute() else root / args.kernel
            if args.command == "verify-image":
                state = verify_image(root, image, kernel)
                print("PASS: Franctxt native image matches seed, registry, "
                      "source bundle, bootloader, configuration and kernel")
                print("KERNEL " + state["build.kernel-sha256"])
                print("APPS " + state["build.apps-sha256"])
            elif args.command == "record":
                if args.output is None:
                    raise BuildAuthorityError("--output required")
                report = build_report(root, image, kernel, args.passed)
                output = args.output if args.output.is_absolute() else root / args.output
                output.write_bytes(report)
                print("PASS: generated tested-build record " + digest(report))
    except (BuildAuthorityError, FranctxtError, OSError, ValueError) as exc:
        print("FRANCTXT BUILD BLOCKED: " + str(exc), file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
