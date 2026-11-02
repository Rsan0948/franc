"""Stage 2: verify that Franc-authored code emits and runs real x86-64 functions.

The Stage 0 compiler only bootstraps stage2/compiler.frac. The expressions in
CASES are compiled by s2-compile (which is itself Franc source), not the C
compiler. The test suite also checks Franc-to-Franc self-recompilation of the compiler.
"""
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LOADER = (ROOT / 'stage2/compiler.frac').read_text()
EXE = str(ROOT / 'frac')

CASES = [
    ('plus signed decimal', '"+0.25 0.25 +" s2-compile s2-run .', '1/2'),
    ('exact decimal arithmetic', '"0.1 0.2 +" s2-compile s2-run .', '3/10'),
    ('negative decimal', '"-0.125 1/8 +" s2-compile s2-run .', '0'),
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
    ('if negative', '"3 5 - if 11 else 22 then" s2-compile s2-run .', '11'),
    ('if nonnegative', '"5 3 - if 11 else 22 then" s2-compile s2-run .', '22'),
    ('if0', '"0 if0 13 else 9 then" s2-compile s2-run .', '13'),
    ('ifnz', '"1 ifnz 17 then" s2-compile s2-run .', '17'),
    ('nested conditional', '"1 ifnz 2 ifnz 33 else 44 then else 55 then" s2-compile s2-run .', '33'),
    ('begin while repeat', '"3 begin dup neg while 1 - repeat" s2-compile s2-run .', '0'),
    ('begin again exit', '"5 begin dup if0 exit then 1 - again" s2-compile s2-run .', '0'),
    ('control inside def', '"def under3 dup 3 - if 99 else 77 then ;" s2-compile drop\n"2 under3 nip ." s2-compile s2-run', '99'),

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
    # Stage 0 cannot escape a nested quote within its own quoted literal.
    # Build this Stage 2 source into its writable memory buffer.
    nested_string_source = '"hello" type'
    nested_string_test = ('s2-line-buffer :a ' +
        ' '.join(f'a {i} + {ord(ch)} !' for i, ch in enumerate(nested_string_source)) +
        f' a {len(nested_string_source)} + 0 ! a s2-compile s2-run')
    extra = [
      ('native strings', nested_string_test, 'hello'),
      ('recompile compiler from Franc source twice',
       's2-self-source s2-source .\ns2-self-source s2-source .\n"40 2 +" s2-compile s2-run .',
       '29\n29\n42'),
      ('newly native-compiled compiler defines and calls code',
       's2-self-source s2-source drop\n"def increment 1 + ;" s2-compile drop\n"41 increment" s2-compile s2-run .',
       '42'),
      ('newly native-compiled compiler control flow',
       's2-self-source s2-source drop\n"0 if0 42 else 3 then" s2-compile s2-run .',
       '42'),
    ]
    for name, source, expected in extra:
        code, actual, err = run(source)
        if code or actual != expected or err:
            print(f'FAIL {name}: expected={expected!r} actual={actual!r} code={code} err={err!r}')
            fails += 1
        else:
            print(f'PASS {name}')
    print(f'\n{len(CASES)+len(extra)-fails}/{len(CASES)+len(extra)} Stage 2 tests passed')
    return int(bool(fails))

if __name__ == '__main__':
    raise SystemExit(main())
