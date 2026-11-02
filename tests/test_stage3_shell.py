"""Franc-owned shell executes through its self-recompiled Franc JIT."""
from pathlib import Path
import subprocess
ROOT = Path(__file__).resolve().parents[1]
bootstrap = (ROOT/'stage2/compiler.frac').read_text()
shell = (ROOT/'lib/calc.frac').read_text() + '\n' + (ROOT/'stage3/shell.frac').read_text()
program = (bootstrap + '\n' + shell + '\n'
    + 'os-boot\n1/3 1/6 +\ndef trip dup dup + + ;\n7 trip\n'
    + '0 if0 9 else 11 then\n'
    + '3 begin dup neg while 1 - repeat\n\x1b\n')
result = subprocess.run([str(ROOT/'frac')], input=program, text=True,
                        capture_output=True, timeout=20)
assert result.returncode == 0, (result.returncode, result.stderr, result.stdout[-1800:])
assert not result.stderr, result.stderr
for expected in ('FrancOS Stage 3 | shell written in Franc',
                 '1/2\n', '21\n', '9\n', '0\n'):
    assert expected in result.stdout, (expected, result.stdout[-1600:])
print('PASS Stage 3 shell: self-recompiled Franc JIT, arithmetic, definition, control flow and Escape')
