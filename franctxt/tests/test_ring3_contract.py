"""Structural test for the opt-in BIOS/CPL3 proof.

Only QEMU can establish actual CPL3 execution and page-fault isolation.
This catches accidental loss of the private user-only page mapping,
user GDT/TSS descriptors, explicit restricted syscall or page-fault gate.
"""
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]


class Ring3Contract(unittest.TestCase):
    def test_assembly_symbols_are_executable(self):
        with tempfile.TemporaryDirectory(prefix="franc-ring3-") as tmp:
            output = Path(tmp) / "runtime.o"
            subprocess.run(["as", "--64", "-o", str(output),
                            "stage4/runtime.S"], cwd=ROOT, check=True,
                           capture_output=True, text=True)
            symbols = subprocess.check_output(
                ["objdump", "-t", str(output)], text=True
            ).splitlines()
            for symbol in ("fr_ring3_probe", "fr_ring3_user_cpl",
                           "fr_ring3_fault_seen", "fr_ring3_fault_address",
                           "fr_ring3_fault_error"):
                match = [line for line in symbols if line.strip().endswith(symbol)]
                self.assertEqual(len(match), 1, symbol)
                self.assertIn(".text", match[0])

    def test_bios_only_user_mapping_and_tss(self):
        # fr_cpu_init in interrupts.S installs the TSS that ring3.S then uses.
        src = (ROOT / "stage4/ring3.S").read_text() + (ROOT / "stage4/interrupts.S").read_text()
        for token in (
            "cmpq $0x9000,%rax",          # no unverified UEFI CR3 layout
            "cmpq $0,8(%rbx)",          # no PDPT1 overwrite
            "orq $4,%rax",              # selective PML4 US
            "orq $5,%rax",              # user code RX (not writable)
            "orq $7,%rax",              # user stack RW
            "fr_ring3_pt: .skip 4096",  # four KiB leaf PTEs
            "movq %rax,fr_ring3_tss+4(%rip)",
            "movw $104,fr_ring3_tss+102(%rip)",
            "ltr %ax",
            "movl $0xee00,%edx",        # ring3-accessible int gate
            "movl $0x8e00,%edx",        # protected kernel fault gate
            "movq %cr2,%rax",          # real fault virtual address
            "testq $4,%rax",           # user-mode PF error bit
            "movzbl (%rax),%eax",       # read-only supervisor probe
            "pushq $0x2b",             # RPL3 user data
            "pushq $0x23",             # RPL3 user 64-bit code
            "iretq",
        ):
            self.assertIn(token, src)
        self.assertIn('.include "stage4/ring3.S"',
                      (ROOT / "stage4/runtime.S").read_text())


if __name__ == "__main__":
    unittest.main()
