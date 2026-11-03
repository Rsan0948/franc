"""Franctxt physical-region declaration tests (no QEMU required)."""
from pathlib import Path
import unittest

from franctxt import parse
from franctxt.memory import MemoryLayoutError, check_memory_map, validate_layout

ROOT = Path(__file__).resolve().parents[2]


class Layout(unittest.TestCase):
    def test_current_128m_map_and_source_anchors(self):
        regions = check_memory_map(ROOT)
        self.assertGreaterEqual(len(regions), 14)
        self.assertEqual(next(a for name, a, _ in regions if name == "net"),
                         0x06C00000)
        self.assertEqual(next(z - a for name, a, z in regions if name == "pages"),
                         8 * 1024 * 1024)

    def test_overlaps_and_limits_fail_closed(self):
        base = parse((ROOT / "franctxt/memory.franctxt").read_bytes())
        overlapping = dict(base)
        overlapping["region.net.base"] = overlapping["region.ide.base"]
        with self.assertRaisesRegex(MemoryLayoutError, "overlapping"):
            validate_layout(overlapping)
        outside = dict(base)
        outside["region.pages.base"] = 128 * 1024 * 1024
        with self.assertRaisesRegex(MemoryLayoutError, "out-of-bounds"):
            validate_layout(outside)
        bad_alignment = dict(base)
        bad_alignment["region.net.base"] += 1
        with self.assertRaisesRegex(MemoryLayoutError, "invalid/out-of-bounds"):
            validate_layout(bad_alignment)

    def test_layout_source_change_cannot_silently_drift(self):
        base = parse((ROOT / "franctxt/memory.franctxt").read_bytes())
        changed = dict(base)
        changed["region.net.base"] += 0x1000
        with self.assertRaisesRegex(MemoryLayoutError, "source no longer contains"):
            validate_layout(changed, ROOT)


if __name__ == "__main__":
    unittest.main()
