"""Stage 2: verify that Franc-authored code emits and runs real x86-64 functions.

The Stage 0 compiler only bootstraps stage2/compiler.frac. The expressions in
CASES are compiled by s2-compile (which is itself Franc source), not the C
compiler. This is partial self-hosting, not full compiler replacement.
"""
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LOADER = (ROOT / 'stage2/compiler.frac').read_text()
EXE = str(ROOT / 'frac')

CASES = [
    ('integer add', '"2 3 +" s2-compile s2-run .', '5'),
    ('integer subtract', '"9 4 -" s2-compile s2-run .', '5'),
    ('negative literal', '"-12 4 +" s2-compile s2-run .', '-8'),
    ('dup multiply', '"4 dup *" s2-compile s2-run .', '16'),
    ('divide', '"12 2 /" s2-compile s2-run .', '6'),
    ('nested rational', '"1/3 1/6 +" s2-compile s2-run .', '1/2'),
    ('binary prefix', '"#1010 2 *" s2-compile s2-run .', '20'),
    ('hex prefix', '"$FF $10 /" s2-compile s2-run .', '255/16'),
    ('mixed-base rational', '"$FF/$10" s2-compile s2-run .', '255/16'),
    ('two wheel infinites', '"1/0 1/0 +" s2-compile s2-run .', '⊥'),
    ('wheel infinity', '"1/0 1 +" s2-compile s2-run .', '∞'),
    ('bottom literal', '"0/0" s2-compile s2-run .', '⊥'),
    ('floor', '"-7/2 floor" s2-compile s2-run .', '-4'),
    ('power', '"2 5 ^" s2-compile s2-run .', '32'),
    ('modulus', '"50 3 %" s2-compile s2-run .', '2'),
    ('new native definition', '"def sq dup * ;" s2-compile drop\n"5 sq" s2-compile s2-run .', '25'),
    ('new native cube', '"def cube dup dup * * ;" s2-compile drop\n"4 cube" s2-compile s2-run .', '64'),
    ('multiple references', '"def seven 7 ;" s2-compile drop\n"seven seven +" s2-compile s2-run .', '14'),
    ('dictionary shadowing', '"def + drop drop 42 ;" s2-compile drop\n"5 3 +" s2-compile s2-run .', '42'),
]


def run(program):
    proc = subprocess.run(
        [EXE], input=LOADER+'\n'+program+'\n', text=True,
        capture_output=True, timeout=8,
    )
    actual = proc.stdout.replace('Frac> ', '').strip()
    return proc.returncode, actual, proc.stderr


def main():
    fails = 0
    for name, source, expected in CASES:
        code, actual, err = run(source)
        if code or actual != expected or err:
            print(f'FAIL {name}: expected={expected!r} actual={actual!r} code={code} err={err!r}')
            fails += 1
        else:
            print(f'PASS {name}')
    print(f'\n{len(CASES)-fails}/{len(CASES)} Stage 2 tests passed')
    return int(bool(fails))

if __name__ == '__main__':
    raise SystemExit(main())
