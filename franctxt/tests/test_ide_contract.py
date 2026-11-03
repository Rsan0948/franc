"""Host-side guard against unmatched Franc IDE controls.

The native JIT reports unmatched `then` as a generic unsupported token;
this check catches editor grammar drift before expensive QEMU boot tests.
Actual execution and persistence still require the QEMU integration suite.
"""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[2]


def scan_words(source: str):
    """Franc whitespace tokens with quoted strings excluded, no line comments."""
    for line_number, line in enumerate(source.splitlines(), 1):
        if not line or line.lstrip().startswith("\\"):
            continue
        # Strings are quoted and are tokens; their spaces and control words
        # must never be confused with source-language control operators.
        stripped = re.sub(r'"[^"]*"', ' "" ', line)
        yield line_number, stripped.split()


class NativeIdeControls(unittest.TestCase):
    def test_each_ide_definition_has_matching_if_and_then(self):
        source = (ROOT / "lib/ide.frac").read_text()
        found = []
        for number, words in scan_words(source):
            if not words or words[0] != "def":
                continue
            name = words[1]
            found.append(name)
            depth = 0
            for token in words[2:]:
                if token in {"if", "if0", "ifnz"}:
                    depth += 1
                elif token == "else":
                    self.assertGreater(depth, 0, f"{name} line {number}: orphan else")
                elif token == "then":
                    self.assertGreater(depth, 0, f"{name} line {number}: orphan then")
                    depth -= 1
            self.assertEqual(depth, 0, f"{name} line {number}: unclosed conditional")
        self.assertIn("ide-edit", found)
        self.assertIn("ide-main", found)
        self.assertIn("ide-screen", found)

    def test_native_ide_stays_inside_declared_4096_byte_reservation(self):
        source = (ROOT / "lib/ide.frac").read_text()
        self.assertIn("def ide-buffer $6b00000", source)
        # Source occupies first 2048 bytes, while UI control and stable
        # filename scratch reside in the same existing 4KiB IDE page.
        self.assertIn("ide-buffer 2050 +", source)
        self.assertIn("ide-buffer 2064 +", source)
        self.assertNotIn("ide-buffer 4096 +", source)


if __name__ == "__main__":
    unittest.main()
