"""Structural guardrails for BIOS E820 and the experimental two-process
CPL3 fault-containment test. Only QEMU proves actual privilege boundaries.
This is sequential execution, not yet preemptive Ring 3 scheduling.
"""
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]


class ProcessIsolationContract(unittest.TestCase):
    def test_native_asm_compiles_and_exports_entrypoints(self):
        with tempfile.TemporaryDirectory(prefix="franc-proc-") as tmp:
            for source, output in (("stage4/runtime.S", "runtime.o"),
                                   ("stage4/boot.S", "boot.o")):
                subprocess.run(
                    ["as", "--64", "-o", str(Path(tmp) / output), source],
                    cwd=ROOT, check=True, capture_output=True, text=True)
            table = subprocess.check_output(
                ["objdump", "-t", str(Path(tmp) / "runtime.o")], text=True)
            for name in ("fr_e820_count", "fr_e820_base", "fr_e820_length",
                         "fr_e820_type", "fr_proc_probe",
                         "fr_proc_state_a", "fr_proc_state_b",
                         "fr_proc_b_steps", "fr_proc_survivor_ok"):
                rows = [row for row in table.splitlines()
                        if row.strip().endswith(name)]
                self.assertEqual(len(rows), 1, name)
                self.assertIn(".text", rows[0])

    def test_bounded_e820_discovery_and_fail_closed_unknown(self):
        boot = (ROOT / "stage4/boot.S").read_text()
        core = (ROOT / "stage4/e820.S").read_text()
        self.assertIn("call e820_capture", boot)
        for token in ("movl $0xe820,%eax", "movl $0x534d4150,%edx",
                      "cmpw $48,%bp", "movl $0x30323845,0x4ff0"):
            self.assertIn(token, boot)
        for token in ("cmpl $0x30323845,0x4ff0",
                      "movzwq 0x4ff4,%rcx", "cmpq $48,%rcx",
                      "cmpq %rcx,%rax"):
            self.assertIn(token, core)

    def test_distinct_user_physical_frames_and_fault_recovery(self):
        ring = (ROOT / "stage4/ring3.S").read_text()
        for token in (
            "fr_proc_b_codepage: .skip 4096",
            "fr_proc_b_stack: .skip 4096",
            "fr_proc_b_code:",
            "movabsq $0x40001000,%rdi",
            ".Lproc_after_fault:",
            "fr_proc_b_codepage(%rip),%rax",
            "fr_proc_b_stack(%rip),%rax",
            "movq %rax,fr_ring3_pt(%rip)",
            "movq %rax,fr_ring3_pt+8(%rip)",
            "movq %rax,%cr3",
            "cmpl $50000,fr_proc_b_stack(%rip)",
            "movq $0,fr_ring3_pt(%rip)",
            "movq $0,fr_ring3_pt+8(%rip)",
            "fr_proc_survivor_ok:"
        ):
            self.assertIn(token, ring)


if __name__ == "__main__":
    unittest.main()
