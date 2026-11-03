"""Structural F2 guard: actual CPL3 IRQ transitions need a QEMU test too."""
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]


class UserSchedulerContract(unittest.TestCase):
    def test_native_irq_switching_and_trap_retirement_symbols(self):
        irq = (ROOT / "stage4/interrupts.S").read_text()
        ring = (ROOT / "stage4/ring3.S").read_text()
        source = (ROOT / "stage4/user_scheduler.S").read_text()
        runtime = (ROOT / "stage4/runtime.S").read_text()
        self.assertIn('je fr_user_timer_tick', irq)
        self.assertIn('je fr_user_page_fault', ring)
        self.assertIn('je fr_user_int80', ring)
        self.assertIn('.include "stage4/user_scheduler.S"', runtime)
        for name in ("fr_user_timer_tick:", "fr_user_dispatch:",
                     "fr_user_page_fault:", "fr_user_int80:",
                     "fr_user_frame:", "fr_user_sched_probe:",
                     "fr_user_sched_fault_probe:"):
            self.assertIn(name, source)
        self.assertIn("fr_ring3_tss+4(%rip)", source)
        self.assertIn("movq %rdx,%cr3", source)
        self.assertIn("call fr_lease_alloc", (ROOT / "stage4/process_spaces.S").read_text())
        with tempfile.TemporaryDirectory(prefix="franc-f2-") as tmp:
            obj = Path(tmp) / "runtime.o"
            subprocess.run(["as", "--64", "-o", str(obj),
                            "stage4/runtime.S"], cwd=ROOT, check=True,
                           capture_output=True, text=True)
            symbols = subprocess.check_output(["objdump", "-t", str(obj)],
                                              text=True)
            for name in ("fr_user_sched_probe", "fr_user_sched_fault_probe",
                         "fr_user_timer_tick", "fr_user_int80"):
                self.assertIn(name, symbols)


if __name__ == "__main__":
    unittest.main()
