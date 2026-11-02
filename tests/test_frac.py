"""Black-box tests against the actual x86-64-emitting Frac binary."""
import subprocess
import sys
from pathlib import Path

EXE = str(Path(__file__).resolve().parents[1] / 'frac')

# (name, source; expected stdout after stripping REPL prompts, optional stderr substring)
CASES = [
    ('cross-multiply', '1/3 1/6 +', '1/2'),
    ('multiplication', '1/3 3 *', '1'),
    ('decimal is exact', '0.1 0.2 +', '3/10'),
    ('negative fraction', '-1/6', '-1/6'),
    ('reduce numerator', '8/12', '2/3'),
    ('signed denominator', '1/-2', '-1/2'),
    ('zero denominator', '1/0', '∞'),
    ('zero over zero', '0/0', '⊥'),
    ('infinity plus finite', '1/0 1 +', '∞'),
    ('infinity plus infinity', '1/0 1/0 +', '⊥'),
    ('infinity times zero', '1/0 0 *', '⊥'),
    ('infinity times infinity', '1/0 1/0 *', '∞'),
    ('divide by zero', '1 0 /', '∞'),
    ('zero divide zero', '0 0 /', '⊥'),
    ('negative repeating', '-1/6 ~', '-0.1(6)'),
    ('repeating 7', '1/7 ~', '0.(142857)'),
    ('terminating expansion', '5/4 ~', '1.25'),
    ('one half expansion', '1/2 ~', '0.5'),
    ('wheel expansion', '1/0 ~', '∞'),
    ('bottom expansion', '0/0 ~', '⊥'),
    ('base 16', '255 16 ~', 'FF'),
    ('base 2', '255 2 ~', '11111111'),
    ('base 36', '35 36 ~', 'Z'),
    ('percent', '50 %', '1/2'),
    ('modulo', '50 3 %', '2'),
    ('modulo with negatives', '-7 3 %', '2'),
    ('hex literal', '$FF', '255'),
    ('binary literal', '#1010', '10'),
    ('mixed base numerator denominator', '$FF/$10', '255/16'),
    ('mixed binary and hex arithmetic', '#11/$10 #1/$11 +', '67/272'),
    ('c-style hex convenience', '0x90', '144'),
    ('power', '2 5 ^', '32'),
    ('bounded overflow returns bottom', '9223372036854775807 2 *', '⊥'),
    ('negative power', '2 -2 ^', '1/4'),
    ('absolute', '-3 abs', '3'),
    ('negate', '3 neg', '-3'),
    ('inverse', '4 inv', '1/4'),
    ('swap', '1 2 swap', '1'),
    ('nip', '1 2 nip', '2'),
    ('2dup', '1 2 2dup .s', '1 2 1 2 \n2'),
    ('register storage', '22/7 :r\nr r *', '484/49'),
    ('user-defined word', 'def sq dup * ;\n5 sq', '25'),
    ('recursion factorial', 'def fact dup 1 - if drop 1 else dup 1 - fact * then ;\n5 fact', '120'),
    ('recursion fibonacci', 'def fib dup 2 - if drop 1 else dup 1 - fib swap 2 - fib + then ;\n10 fib', '89'),
    ('dictionary shadowing operator', 'def + 42 ;\n1/3 1/6 +', '42'),
    ('dictionary shadows literal', 'def 1 2 ;\n1', '2'),
    ('dictionary shadows compiler word', 'def if 77 ;\nif', '77'),
    ('dictionary shadows def', 'def def 7 ;\ndef', '7'),
    ('negative conditional', '3 5 - if "lt" type then', 'lt'),
    ('zero conditional', '3 3 - if0 "eq" type then', 'eq'),
    ('nonzero conditional', '3 5 - ifnz "diff" type then', 'diff'),
    ('false conditional', '5 3 - if "should not print" type then', ''),
    ('else conditional', '5 3 - if "bad" type else "gt" type then', 'gt'),
    ('string spaces', '"hello world" type', 'hello world'),
    ('quote and byte fetch', "def sq dup * ;\n'sq @ .", '72'),
    ('quote and byte rewrite', "def sq dup * ;\n'sq $90 !\n'sq @ .", '144'),
    ('early exit', 'def early 7 exit 99 ;\nearly', '7'),
    ('nested definitions calling earlier', 'def sq dup * ;\ndef cube dup sq * ;\n4 cube', '64'),
]

def run(source):
    p = subprocess.run([EXE], input=source+'\n', text=True,
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                       timeout=6)
    output=p.stdout.replace('Frac> ', '').strip()
    return p.returncode, output, p.stderr

def main():
    failed = 0
    for name, source, expected in CASES:
        code, output, err=run(source)
        if code != 0 or output != expected or err:
            failed += 1
            print(f'FAIL {name}: expected={expected!r} got={output!r} code={code} stderr={err!r}')
        else: print(f'PASS {name}')
    # Deliberately broken control structure must not result in an invalid jump.
    for name, source, fragment in [
        ('unmatched then', 'then', 'then without matching if'),
        ('unmatched else', 'else', 'else without matching if'),
        ('unclosed if', '1 if 7', 'unclosed control structure'),
        ('unknown word', 'thisisnotaword', 'unknown word'),
        ('malformed definition rolled back', 'def broken no_such_word ;\nbroken', 'unknown word: broken'),
    ]:
        code, output, err=run(source)
        if code or fragment not in err:
            failed += 1
            print(f'FAIL {name}: code={code} stderr={err!r}')
        else: print(f'PASS {name}')
    print(f'\n{len(CASES)+4-failed}/{len(CASES)+4} passed')
    return int(failed != 0)

if __name__ == '__main__': sys.exit(main())
