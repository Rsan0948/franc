"""Check that native MMIO ABI symbols cannot disappear in a discarded section.

The first MMIO linker failure had its global entry points accidentally
assembled into .note.GNU-stack. This check catches that immediately,
without booting QEMU or waiting for the two-generation Franc bootstrap.
"""
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]


class MmioContract(unittest.TestCase):
    def test_mmio_entry_points_in_executable_text(self):
        with tempfile.TemporaryDirectory(prefix="franc-mmio-abi-") as temp:
            output = Path(temp) / "runtime.o"
            subprocess.run(
                ["as", "--64", "-o", str(output), "stage4/runtime.S"],
                cwd=ROOT, check=True, capture_output=True,
            )
            symbols = subprocess.check_output(
                ["objdump", "-t", str(output)], text=True,
            ).splitlines()
            for symbol in ("fr_mmio32_fetch", "fr_mmio32_store"):
                matching = [line for line in symbols if line.strip().endswith(symbol)]
                self.assertEqual(len(matching), 1, symbol)
                self.assertIn(".text", matching[0], matching[0])
                self.assertNotIn(".note.GNU-stack", matching[0], matching[0])

    def test_bios_identity_map_and_pci_aperture(self):
        bios = (ROOT / "stage4/boot.S").read_text()
        net = (ROOT / "stage4/net.frac").read_text()
        self.assertIn("movl $128,%ecx", bios)
        self.assertIn("134217728 :net-mmio", net)
        self.assertIn("0 net-slot 0 16 pci-read", net)
        self.assertNotIn("net-iobase net-reg io32!", net)


if __name__ == "__main__":
    unittest.main()
