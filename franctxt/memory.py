"""Static QEMU memory-reservation verifier for FrancOS native builds.

Fail early if two trusted kernel subsystems reserve overlapping addresses.
This is NOT a replacement for e820/UEFI GetMemoryMap or page-table/Ring3
enforcement on real hardware. Native stage4 still assumes 128MiB QEMU RAM.
"""
from pathlib import Path
from . import FranctxtError, canonical, parse


class MemoryLayoutError(FranctxtError):
    pass


# Every fixed reservation must match its actual code declaration, not merely
# appear somewhere in a comment or an unrelated buffer constant.
ANCHORS = {
    "heap": ("stage4/runtime.S", "fr_heap_next:"),
    "bignumarena": ("lib/bignum.frac", "def bn-base"),
    "bignumstate": ("lib/bignum.frac", "def bn-state"),
    "bignumprint": ("lib/bignum.frac", "def bn-print"),
    "tasks": ("stage4/tasks.frac", "def task-base"),
    "ide": ("lib/ide.frac", "def ide-buffer"),
    "net": ("stage4/net.frac", "def net-txdesc"),
    "franctxt": ("lib/franctxt.frac", "def ft-value-buffer"),
    "pages": ("stage4/runtime.S", "fr_page_alloc:"),
    "lite": ("lib/litetofrac.frac", "def lite-put"),
}
MAX_RAM = 128 * 1024 * 1024


def validate_layout(state: dict, root: Path | None = None) -> list[tuple[str, int, int]]:
    if state.get("schema") != "francos.memory-map.v1":
        raise MemoryLayoutError("unsupported memory-map profile")
    size = state.get("memory.ram-bytes")
    if type(size) is not int or size != MAX_RAM:
        raise MemoryLayoutError("memory-map must match the current 128 MiB QEMU target")
    keys = set()
    for key in state:
        if key.startswith("region."):
            parts = key.split(".")
            if len(parts) != 3 or parts[2] not in ("base", "size"):
                raise MemoryLayoutError(f"invalid region key: {key}")
            keys.add(parts[1])
    required = set(ANCHORS) | {"seed", "source", "jit", "float"}
    if not required <= keys:
        raise MemoryLayoutError(f"missing reserved memory regions: {sorted(required - keys)}")
    spans = []
    for name in sorted(keys):
        base = state.get(f"region.{name}.base")
        length = state.get(f"region.{name}.size")
        if (type(base) is not int or type(length) is not int or
                base < 0 or base % 4096 != 0 or length <= 0 or
                base + length > size):
            raise MemoryLayoutError(f"invalid/out-of-bounds region: {name}")
        spans.append((name, base, base + length))
    by_address = sorted(spans, key=lambda span: span[1])
    for prev, nxt in zip(by_address, by_address[1:]):
        if prev[2] > nxt[1]:
            raise MemoryLayoutError(
                f"overlapping FrancOS physical memory: {prev[0]} and {nxt[0]}"
            )
    if root:
        for name, (path, prefix) in ANCHORS.items():
            source = (root / path).read_text("utf-8")
            if prefix == "fr_page_alloc:":
                fragment = source.split(prefix, 1)[1].split(
                    ".global fr_page_free", 1)[0]
            else:
                fragment = next((line for line in source.splitlines()
                                 if line.startswith(prefix)), "")
            base = state[f"region.{name}.base"]
            if not any(token in fragment for token in (
                f"0x{base:08x}", f"0x{base:x}", "$" + format(base, "x")
            )):
                raise MemoryLayoutError(
                    f"{name} source no longer contains reserved base "
                    f"0x{base:x}; update code and memory.franctxt in sync"
                )
    return spans


def check_memory_map(root: Path) -> list[tuple[str, int, int]]:
    path = root / "franctxt/memory.franctxt"
    raw = path.read_bytes()
    state = parse(raw)
    if canonical(state) != raw:
        raise MemoryLayoutError("memory.franctxt must be canonically encoded")
    return validate_layout(state, root)
