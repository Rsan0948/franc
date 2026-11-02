"""Black-box smoke tests of the Frac source libraries on the x86-64 JIT.

All outputs are from the real emitted machine code, not a Python reimplementation.
Only documented approximation tolerances are asserted, never fake rigor.
"""
import subprocess
import sys
from pathlib import Path
from fractions import Fraction

ROOT = Path(__file__).resolve().parents[1]
PRELUDE = ''.join((ROOT / 'lib' / f'{name}.frac').read_text()
                  for name in ('fixpt', 'cf', 'approx', 'iv', 'trans'))

CASES = [
    ('floor positive', '5/2 floor .', '2'),
    ('floor negative', '-5/2 floor .', '-3'),
    ('ceil negative', '-5/2 ceil .', '-2'),
    ('trunc negative', '-5/2 trunc .', '-2'),
    ('default resolution', 'eps .', '1/1000000'),
    ('fixed precision', '3 fix-precision\n1/3 fix .', '333/1000'),
    ('exact fixed-point error', '3 fix-precision\n1/3 fix 1/3 - .', '-1/3000'),
    ('continued fractions', '355/113 cf .s', '3 7 16 \n16'),
    ('cf of integer', '7 cf .s', '7 \n7'),
    ('loop while/repeat', 'def sum3 0 :sum 3 :idx begin 0 idx - while sum idx + :sum idx 1 - :idx repeat sum ;\nsum3 .', '6'),
    ('integer sqrt', '7 isqrt .', '2'),
    ('square root of four', '4 sqrt .', '2'),
    ('min', '3 5 min .', '3'),
    ('max', '3 5 max .', '5'),
    ('exp(0)', '0 exp .', '1'),
    ('sin(0)', '0 sin .', '0'),
    ('sin(pi/6)', 'pi 6 / sin .', '1/2'),
    ('cos(0)', '0 cos .', '1'),
    ('atan(0)', '0 atan .', '0'),
    ('interval plus', '1 2 3 4 iv+ .s', '4 6 \n6'),
    ('interval multiply', '1 2 3 4 iv* .s', '3 8 \n8'),
    ('negative log is bottom', '-2 log .', '⊥'),
]
APPROX = [
    ('pi', 'pi .', Fraction('3.141592653589793'), Fraction(1, 100000)),
    ('e', 'e .', Fraction('2.718281828459045'), Fraction(1, 100000)),
    ('ln 2', '2 log .', Fraction('0.693147180559945'), Fraction(1, 100000)),
    ('exp 1', '1 exp .', Fraction('2.718281828459045'), Fraction(1, 100000)),
    ('sqrt 2', '2 sqrt .', Fraction('1.414213562373095'), Fraction(1, 100000)),
    ('atan 1', '1 atan .', Fraction('0.785398163397448'), Fraction(1, 100000)),
]

def run(source):
    p = subprocess.run([str(ROOT / 'frac')], input=PRELUDE + '\n' + source + '\n',
                       text=True, capture_output=True, timeout=4)
    return p.returncode, p.stdout.replace('Frac> ', '').strip(), p.stderr

def main():
    passed = 0
    for name, src, expected in CASES:
        try:
            code, out, err = run(src)
        except subprocess.TimeoutExpired:
            print(f'FAIL {name}: timeout'); continue
        if code == 0 and out == expected and not err:
            print(f'PASS {name}'); passed += 1
        else:
            print(f'FAIL {name}: expected={expected!r} got={out!r} code={code} err={err!r}')
    for name, src, expected, tolerance in APPROX:
        try:
            code, out, err = run(src)
            got = Fraction(out)
            good = code == 0 and not err and abs(got - expected) <= tolerance
        except (subprocess.TimeoutExpired, ValueError, ZeroDivisionError):
            good = False; out = 'error / timeout'
        if good:print(f'PASS {name}'); passed += 1
        else:print(f'FAIL {name}: value={out!r}, target={expected}, tol={tolerance}')
    print(f'\n{passed}/{len(CASES)+len(APPROX)} library checks passed')
    return 0 if passed == len(CASES)+len(APPROX) else 1

if __name__ == '__main__':sys.exit(main())
