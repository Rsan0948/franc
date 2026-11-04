"""Compatibility import for Stage 4 QEMU suites during module migration."""
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from tools.qemu_visual import (
    parse_ppm,assert_nonblank,assert_accent_rail,assert_content_area,
)
