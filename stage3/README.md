# Stage 3 — Franc-authored kernel shell and bootstrap

The interactive operating-system control loop lives in
[`shell.frac`](shell.frac). On BIOS boot, the minimal C/assembly substrate sets
up the CPU, console, storage, memory and primitive functions, and compiles the
first generation of Franc compiler definitions. The Franc `os-boot` word then:

1. Compiles `compiler.frac` **using its own Franc compiler**.
2. Compiles `shell.frac` with that newly generated compiler.
3. Resolves and executes the new native `os-main` shell word.
4. Compiles subsequent interactive input using Franc `s2-eval` rather than
   C `eval`, including new definitions, rational arithmetic and branches.
   `load`/`launch` are now Franc-authored policies which compile saved source
   through `s2-source`; the native storage service supplies source bytes.
5. Allows Esc to return to the C diagnostic console.

The kernel's high-level shell, compilation policy, application code, graphic
programs and demos are Franc code. The hardware/runtime substrate (BIOS boot,
page tables, native primitive arithmetic, keyboard/serial/VGA/ATA drivers,
heap and executable-code allocation) **remains C/assembly**. The project
therefore does *not* claim a pure-Franc kernel or zero native bootstrap code.

Verification: `make test` proves the hosted self-compiled shell; the private
GitHub workflow builds the boot image and uses `stage1/qemu_smoke.py` and
`stage1/qemu_persistence.py` to test the real guest. A successful host build
alone does not prove the new QEMU boot path.
