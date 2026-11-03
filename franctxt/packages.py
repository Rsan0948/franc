"""FrancOS Wave 3: trusted *offline* package manifest and transaction planner.

This is host-side validation/packing, NOT a kernel package manager, code
execution path, network fetch, or claim of transactional disk writes.
Native FRANCFS1 currently has 12 slots, 2 reserved; this planner's limits
match the actual on-disk source format. No untrusted package is executed.
"""
from __future__ import annotations

from dataclasses import dataclass
import hashlib
import re
from typing import Mapping

from . import FranctxtError, canonical, digest, parse

NAME = re.compile(r"[a-z][a-z0-9-]{0,30}\\Z", re.ASCII)
VERSION = re.compile(r"(?:0|[1-9][0-9]*)\\.(?:0|[1-9][0-9]*)\\.(?:0|[1-9][0-9]*)\\Z", re.ASCII)
FILENAME = re.compile(r"[a-z][a-z0-9._-]{0,22}\\Z", re.ASCII)
HASH = re.compile(r"sha256:[0-9a-f]{64}\\Z", re.ASCII)
MAX_FILES = 4
MAX_DEPS = 4
MAX_FILE_BYTES = 2047
MAX_SLOTS = 10
RESERVED = frozenset(("kernel.franctxt", "system.franctxt"))


class PackageError(FranctxtError):
    pass


def _name(value: object, *, file: bool = False) -> str:
    if not isinstance(value, str):
        raise PackageError("package ID / filename must be a string")
    rule = FILENAME if file else NAME
    if not rule.fullmatch(value) or value in RESERVED or ".." in value:
        raise PackageError(f"invalid package {'file' if file else 'ID'}: {value!r}")
    return value


def _version(value: object) -> str:
    if not isinstance(value, str) or not VERSION.fullmatch(value):
        raise PackageError(f"noncanonical package version: {value!r}")
    return value


def _count(doc: Mapping, key: str, limit: int) -> int:
    n = doc.get(key)
    if type(n) is not int or not 0 <= n <= limit:
        raise PackageError(f"invalid {key}: {n!r}")
    return n


@dataclass(frozen=True)
class Package:
    identifier: str
    version: str
    depends: tuple[tuple[str, str], ...]
    files: tuple[tuple[str, int, str], ...]
    entry: str | None
    manifest: bytes

    @property
    def key(self) -> tuple[str, str]:
        return self.identifier, self.version


def read_manifest(raw: bytes) -> Package:
    data = parse(raw)
    if canonical(data) != raw:
        raise PackageError("package manifest must be canonical Franctxt v1")
    if data.get("schema") != "francos.package.v1":
        raise PackageError("wrong package schema")
    identifier = _name(data.get("package.id"))
    version = _version(data.get("package.version"))
    ndeps = _count(data, "package.dependency-count", MAX_DEPS)
    nfiles = _count(data, "package.file-count", MAX_FILES)
    if nfiles == 0:
        raise PackageError("a package must own at least one file")
    deps = []
    for i in range(ndeps):
        name = _name(data.get(f"package.dependency.{i}.id"))
        dep_version = _version(data.get(f"package.dependency.{i}.version"))
        if name == identifier:
            raise PackageError("self dependency")
        if any(k == name for k, _ in deps):
            raise PackageError("duplicate dependency")
        deps.append((name, dep_version))
    files = []
    for i in range(nfiles):
        name = _name(data.get(f"package.file.{i}.name"), file=True)
        size = data.get(f"package.file.{i}.bytes")
        sha = data.get(f"package.file.{i}.sha256")
        if type(size) is not int or not 1 <= size <= MAX_FILE_BYTES:
            raise PackageError(f"bad file size for {name}")
        if not isinstance(sha, str) or HASH.fullmatch(sha) is None:
            raise PackageError(f"bad SHA-256 for {name}")
        if any(x[0] == name for x in files):
            raise PackageError("duplicate filename")
        files.append((name, size, sha))
    entry = data.get("package.entry")
    if entry is not None:
        entry = _name(entry, file=True)
        if entry not in {f[0] for f in files}:
            raise PackageError("entrypoint must be an installed file")
    required = {
        "schema", "package.id", "package.version",
        "package.dependency-count", "package.file-count", "package.entry",
    }
    for i in range(ndeps):
        required |= {f"package.dependency.{i}.id", f"package.dependency.{i}.version"}
    for i in range(nfiles):
        required |= {f"package.file.{i}.name", f"package.file.{i}.bytes",
                     f"package.file.{i}.sha256"}
    if set(data) != required:
        raise PackageError("unknown, missing or noncontiguous manifest fields")
    return Package(identifier, version, tuple(deps), tuple(files), entry, raw)


def manifest_for(identifier: str, version: str, payloads: Mapping[str, bytes],
                 dependencies: tuple[tuple[str, str], ...] = (),
                 entry: str | None = None) -> Package:
    identifier, version = _name(identifier), _version(version)
    if not 1 <= len(payloads) <= MAX_FILES or len(dependencies) > MAX_DEPS:
        raise PackageError("files/dependencies exceed bounded native format")
    doc: dict = {
        "schema": "francos.package.v1",
        "package.id": identifier,
        "package.version": version,
        "package.dependency-count": len(dependencies),
        "package.file-count": len(payloads),
        "package.entry": entry,
    }
    for i, (name, depver) in enumerate(dependencies):
        doc[f"package.dependency.{i}.id"] = _name(name)
        doc[f"package.dependency.{i}.version"] = _version(depver)
    for i, (name, data) in enumerate(sorted(payloads.items())):
        _name(name, file=True)
        if not isinstance(data, bytes) or not 1 <= len(data) <= MAX_FILE_BYTES or b"\\0" in data:
            raise PackageError(f"invalid source data: {name}")
        doc[f"package.file.{i}.name"] = name
        doc[f"package.file.{i}.bytes"] = len(data)
        doc[f"package.file.{i}.sha256"] = "sha256:" + hashlib.sha256(data).hexdigest()
    package = read_manifest(canonical(doc))
    verify_payloads(package, payloads)
    return package


def verify_payloads(package: Package, payloads: Mapping[str, bytes]) -> bool:
    if set(payloads) != {name for name, _, _ in package.files}:
        raise PackageError("file inventory differs from manifest")
    for name, length, digest_expected in package.files:
        data = payloads[name]
        if not isinstance(data, bytes) or len(data) != length:
            raise PackageError(f"file size mismatch: {name}")
        if "sha256:" + hashlib.sha256(data).hexdigest() != digest_expected:
            raise PackageError(f"file digest mismatch: {name}")
    return True


@dataclass(frozen=True)
class InstallPlan:
    ordered: tuple[tuple[str, str], ...]
    installed: tuple[tuple[str, str], ...]
    files: tuple[str, ...]


def plan_install(repository: Mapping[tuple[str, str], tuple[Package, Mapping[str, bytes]]],
                 installed: Mapping[str, str], requested: tuple[str, str]) -> InstallPlan:
    """Pure plan, validated before one native file or installed record changes.

    Installed versions are pinned (no implicit update). Dependency recursion,
    cycles, conflicts, duplicate paths and the ten free slots fail closed.
    """
    root = (_name(requested[0]), _version(requested[1]))
    for identifier, version in installed.items():
        _name(identifier)
        _version(version)
    visiting: set[tuple[str, str]] = set()
    visited: set[tuple[str, str]] = set()
    ordered: list[tuple[str, str]] = []
    versions = dict(installed)
    paths: set[str] = set()
    for id_ver, pair in repository.items():
        package, sources = pair
        if package.key != id_ver:
            raise PackageError("repository key/manifest mismatch")
        verify_payloads(package, sources)

    def visit(key: tuple[str, str]) -> None:
        if key in visiting:
            raise PackageError("dependency cycle")
        if key in visited:
            return
        package_and_sources = repository.get(key)
        if package_and_sources is None:
            raise PackageError(f"missing dependency/package: {key}")
        package = package_and_sources[0]
        prior = versions.get(package.identifier)
        if prior is not None and prior != package.version:
            raise PackageError("installed version conflict; update must be explicit")
        visiting.add(key)
        for child in package.depends:
            visit(child)
        visiting.remove(key)
        visited.add(key)
        if prior is None:
            versions[package.identifier] = package.version
            ordered.append(key)

    visit(root)
    for identifier, version in versions.items():
        package = repository.get((identifier, version))
        if package is None:
            raise PackageError("installed inventory missing from trusted repository")
        for filename, _, _ in package[0].files:
            if filename in paths:
                raise PackageError("two packages claim one FRANCFS1 filename")
            paths.add(filename)
    # 2 reserved Franctxt files leave exactly 10 native slots.
    if len(paths) > MAX_SLOTS:
        raise PackageError("offline installation exceeds FRANCFS1 source slots")
    return InstallPlan(tuple(ordered), tuple(sorted(versions.items())), tuple(sorted(paths)))
