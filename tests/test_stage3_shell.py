"""Stage 3 shell prototype: Franc-controlled REPL on hosted runtime.

This does not establish a Franc-native kernel or self-hosting compiler.
"""
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
boot = (ROOT / 'lib/calc.frac').read_text() + '\n' + (ROOT / 'stage3/shell.frac').read_text()
script = boot + '\nos-main\n1/3 1/6 +\ndef trip dup dup + + ;\n7 trip\n\x1b\n'
result = subprocess.run([str(ROOT / 'frac')], input=script, text=True, capture_output=True, timeout=8)
assert result.returncode == 0, (result.returncode, result.stderr)
assert not result.stderr, result.stderr
assert 'FrancOS shell (Franc-written)' in result.stdout, result.stdout
assert '1/2\n' in result.stdout, result.stdout
assert '21\n' in result.stdout, result.stdout
print('PASS Franc-owned hosted shell: arithmetic, definitions, escape')
