"""Check the freestanding x86-64 IDT/PIC/PIT ABI without executing privileged CPU instructions."""
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]


class InterruptContract(unittest.TestCase):
    def test_native_symbols_reside_in_executable_code(self):
        with tempfile.TemporaryDirectory(prefix="franc-irq-") as tmp:
            obj = Path(tmp) / "runtime.o"
            subprocess.run(["as", "--64", "-o", str(obj), "stage4/runtime.S"],
                           cwd=ROOT, check=True, capture_output=True, text=True)
            lines = subprocess.check_output(["objdump", "-t", str(obj)], text=True).splitlines()
            for name in ("fr_irq_start", "fr_irq_ticks", "fr_irq_stop"):
                hits = [s for s in lines if s.strip().endswith(name)]
                self.assertEqual(len(hits), 1, name)
                self.assertIn(".text", hits[0])
            self.assertGreater(obj.stat().st_size, 4096)

    def test_idt_pic_pit_and_iret_are_explicit(self):
        code = (ROOT / "stage4/interrupts.S").read_text()
        for token in ("lidt", "iretq", "outb %al,$0x20", "outb %al,$0x43",
                      "fr_irq_idt: .skip 4096", "movw %cs,%dx",
                      "fr_irq_timer:", "fr_irq_fault:"):
            self.assertIn(token, code)
        self.assertIn("jmp fr_push", code)
        self.assertIn('.include "stage4/interrupts.S"',
                      (ROOT / "stage4/runtime.S").read_text())


if __name__ == "__main__":
    unittest.main()
