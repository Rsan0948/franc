"""Exercise shared native app sources against the existing hosted Franc ABI."""
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]

def run(source):
    result = subprocess.run([str(ROOT / 'frac')], input=source, text=True,
                            capture_output=True, timeout=40)
    assert result.returncode == 0, (result.returncode, result.stderr)
    return result

# Use the native load/launch implementations with the hosted source store.
loader = (ROOT / 'compiler/native/compiler.frac').read_text()
loader += '\ndef fs-source source ;\n'
loader += '\n'.join(line for line in
    (ROOT / 'apps/native/native-compat.frac').read_text().splitlines()
    if line.startswith(('def load ', 'def launch '))) + '\n'
result = run(loader + '\n'.join([
    '"good" "def main 42 . ;" save', '"good" launch .',
    '"missing" launch .', '"plain" "def other 7 ;" save',
    '"plain" launch .', '"bad" "def main invalid-integration-token ;" save',
    '"bad" launch .', '']))
assert result.stdout.count('42\n') == 1, result.stdout[-1500:]
assert result.stdout.count('0\n') == 3, result.stdout[-1500:]
assert not result.stderr, result.stderr
print('PASS: missing, main-less and malformed native apps never execute old main')

# Notes must report a real capacity failure, retaining the edited bytes.
source = (ROOT / 'lib/calc.frac').read_text() + (ROOT / 'lib/edit.frac').read_text()
source += ''.join(f'"f{i}" "old" save\n' for i in range(12))
result = run(source + '"notes" edit-line\nkeep this text\nx\ncalc-buffer type\n')
assert 'SAVE FAILED' in result.stdout and 'keep this text' in result.stdout, result.stdout
assert result.stdout.count('keep this text') >= 2, result.stdout
assert 'RAM store full' in result.stderr, result.stderr
print('PASS: Notes reports full storage and retains edited text')

# Run the native adapter's line raster, not the hosted C line primitive.
line = next(s for s in (ROOT/'apps/native/native-compat.frac').read_text().splitlines()
            if s.startswith('def line '))
result = run(line + '\n0 clearfb\n0 100 319 100 15 line\n160 100 pixel@ .\n'
             '160 0 160 199 15 line\n160 99 pixel@ .\n160 199 pixel@ .\n')
assert result.stdout.count('15\n') == 3, result.stdout[-600:]
assert not result.stderr, result.stderr
print('PASS: native horizontal and vertical lines reach midpoint and endpoint')
