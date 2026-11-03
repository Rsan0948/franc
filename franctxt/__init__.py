"""Franctxt v1: portable, deterministic and bounded verifiable state.

Public API: parse, canonical, digest, validate_kernel, verify_parent.
No dynamic evaluation; no Franc runtime required.
Version 1 intentionally uses ASCII to keep the native FrancOS parser exact.
"""
from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
import hashlib
import re
from typing import Mapping, Union

HEADER = "franctxt 1"
DOMAIN = b"franctxt/1\0"
MAX_DOCUMENT_BYTES = 2047
MAX_KEY_BYTES = 63
MAX_VALUE_BYTES = 255
INT_MAX = (1 << 63) - 1
KEY = re.compile(r"[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*\Z", re.ASCII)
NUMBER = re.compile(r"-?(?:0|[1-9][0-9]*)\Z", re.ASCII)
RATIONAL = re.compile(r"(-?(?:0|[1-9][0-9]*))/([1-9][0-9]*)\Z", re.ASCII)
Value = Union[str, int, bool, Fraction, None]


class FranctxtError(ValueError):
    """Invalid Franctxt structure or value."""


def _ascii(text: str, what: str) -> bytes:
    try:
        data = text.encode("ascii")
    except UnicodeEncodeError as exc:
        raise FranctxtError(f"{what} must use ASCII in franctxt/1") from exc
    if any(c not in (9, 10, 13) and not 32 <= c <= 126 for c in data):
        raise FranctxtError(f"{what} contains forbidden control bytes")
    return data


def _check_key(key: str) -> None:
    if len(key) > MAX_KEY_BYTES or not KEY.fullmatch(key):
        raise FranctxtError(f"invalid key: {key!r}")


def _int(value: str) -> int:
    if not NUMBER.fullmatch(value):
        raise FranctxtError(f"invalid integer: {value!r}")
    result = int(value)
    if abs(result) > INT_MAX:
        raise FranctxtError("integer exceeds Franctxt v1 signed range")
    return result


def parse_value(text: str) -> Value:
    if text in ("true", "false"):
        return text == "true"
    if text == "null":
        return None
    if len(text) >= 2 and text[0] == '"' and text[-1] == '"':
        body = text[1:-1]
        if '"' in body or "\\" in body:
            raise FranctxtError("v1 string escape sequences are not defined")
        data = _ascii(body, "string")
        if any(c in (10, 13, 9) for c in data):
            raise FranctxtError("v1 strings must be single line")
        if len(data) > MAX_VALUE_BYTES:
            raise FranctxtError("string exceeds v1 limit")
        return body
    match = RATIONAL.fullmatch(text)
    if match:
        top, bottom = _int(match.group(1)), int(match.group(2))
        if bottom > INT_MAX:
            raise FranctxtError("rational denominator exceeds signed range")
        return Fraction(top, bottom)
    return _int(text)


def format_value(value: Value) -> str:
    if value is True:
        return "true"
    if value is False:
        return "false"
    if value is None:
        return "null"
    if isinstance(value, Fraction):
        if abs(value.numerator) > INT_MAX or value.denominator > INT_MAX:
            raise FranctxtError("rational exceeds signed range")
        return f"{value.numerator}/{value.denominator}"
    if isinstance(value, int):
        if abs(value) > INT_MAX:
            raise FranctxtError("integer exceeds signed range")
        return str(value)
    if isinstance(value, str):
        _ascii(value, "string")
        if len(value) > MAX_VALUE_BYTES or '"' in value or "\\" in value or any(ord(c) < 32 for c in value):
            raise FranctxtError("unsupported Franctxt v1 string")
        return '"' + value + '"'
    raise FranctxtError(f"unsupported value type: {type(value).__name__}")


def parse(source: str | bytes) -> dict[str, Value]:
    if isinstance(source, bytes):
        try:
            source = source.decode("ascii")
        except UnicodeDecodeError as exc:
            raise FranctxtError("Franctxt v1 accepts ASCII only") from exc
    if len(_ascii(source, "document")) > MAX_DOCUMENT_BYTES:
        raise FranctxtError("document exceeds native FrancOS 2047-byte limit")
    source = source.replace("\r\n", "\n")
    if "\r" in source:
        raise FranctxtError("bare CR line endings forbidden")
    lines = source.split("\n")
    if not lines or lines[0].strip() != HEADER:
        raise FranctxtError("expected franctxt 1 header on first line")
    entries: dict[str, Value] = {}
    for index, line in enumerate(lines[1:], 2):
        item = line.strip()
        if not item or item.startswith("#"):
            continue
        if "=" not in item:
            raise FranctxtError(f"line {index}: expected key = value")
        key, raw_value = (part.strip() for part in item.split("=", 1))
        _check_key(key)
        if key in entries:
            raise FranctxtError(f"line {index}: duplicate key {key!r}")
        try:
            entries[key] = parse_value(raw_value)
        except FranctxtError as exc:
            raise FranctxtError(f"line {index}: {exc}") from exc
    return entries


def canonical(entries: Mapping[str, Value]) -> bytes:
    ordered = sorted(entries)
    lines = [HEADER]
    for key in ordered:
        _check_key(key)
        lines.append(f"{key} = {format_value(entries[key])}")
    output = ("\n".join(lines) + "\n").encode("ascii")
    if len(output) > MAX_DOCUMENT_BYTES:
        raise FranctxtError("canonical document exceeds v1 limit")
    return output


def normalized(source: str | bytes) -> bytes:
    return canonical(parse(source))


def digest(source: str | bytes | Mapping[str, Value]) -> str:
    content = canonical(source) if isinstance(source, Mapping) else normalized(source)
    return "sha256:" + hashlib.sha256(DOMAIN + content).hexdigest()


def validate_kernel(entries: Mapping[str, Value]) -> None:
    """A deterministic profile; unknown keys are permitted for extensions."""
    required = {
        "schema": "francos.kernel.v1",
        "system.name": "FrancOS",
    }
    for key, value in required.items():
        if entries.get(key) != value:
            raise FranctxtError(f"kernel profile requires {key} = {value!r}")
    for key, lo, hi in [
        ("memory.page-size", 4096, 4096),
        ("memory.heap-size", 0, 4194304),
        ("scheduler.max-tasks", 0, 2),
    ]:
        value = entries.get(key)
        if type(value) is not int or not lo <= value <= hi:
            raise FranctxtError(f"kernel profile requires {lo} <= {key} <= {hi}")
    if entries.get("boot.default") not in ("bios", "uefi"):
        raise FranctxtError("boot.default must be bios or uefi")
    if type(entries.get("network.enabled")) is not bool:
        raise FranctxtError("network.enabled must be a boolean")
    if entries.get("network.driver") not in ("none", "e1000"):
        raise FranctxtError("unsupported network.driver")
    if entries["network.enabled"] and entries["network.driver"] == "none":
        raise FranctxtError("network.enabled requires an implemented network.driver")
    parent = entries.get("history.parent")
    if parent is not None and (
        not isinstance(parent, str) or
        re.fullmatch(r"sha256:[0-9a-f]{64}", parent) is None
    ):
        raise FranctxtError("history.parent must be null or sha256:<64 lowercase hex>")


def verify_parent(child: str | bytes, parent: str | bytes) -> bool:
    state = parse(child)
    return state.get("history.parent") == digest(parent)


@dataclass(frozen=True)
class Identity:
    canonical_sha256: str
    bytes: int


def identity(source: str | bytes) -> Identity:
    content = normalized(source)
    return Identity(digest(content), len(content))
