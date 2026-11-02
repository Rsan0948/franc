"""End-to-end library smoke tests executed by native JIT code (not mocked)."""
import math
import subprocess
from fractions import Fraction
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
PRELUDE=''.join((ROOT/'lib'/f'{name}.frac').read_text() for name in ('fixpt','cf','approx','iv','trans'))
EXE=str(ROOT/'frac')


def run(source):
    p=subprocess.run([EXE],input=PRELUDE+'6 fix-precision\n'+source+'\n',
                     text=True,capture_output=True,timeout=4)
    assert p.returncode==0,(p.returncode,p.stderr)
    assert p.stderr=='', p.stderr
    # Everything before the first user expression is prompts for definitions.
    return p.stdout.replace('Frac> ', '').strip()


def rational(s):
    return Fraction(s)

cases=[
    ('floor negative','-3/2 floor .', '-2'),
    ('floor positive','3/2 floor .','1'),
    ('ceil negative','-3/2 ceil .','-1'),
    ('fixed point','1/3 fix .','333333/1000000'),
    ('exact rounding delta','1/3 fix 1/3 - .','-1/3000000'),
    ('precision setting','3 fix-precision 1/3 fix .','333/1000'),
    ('continued fraction 22/7','22/7 cf .s','3 7 \n7'),
    ('continued fraction 355/113','355/113 cf .s','3 7 16 \n16'),
    ('integer sqrt','7 isqrt .','2'),
    ('min','3 5 min .','3'),
    ('max','3 5 max .','5'),
    ('interval addition','1 2 3 4 iv+ .s','4 6 \n6'),
    ('interval subtraction','1 2 3 4 iv- .s','-3 -1 \n-1'),
    ('interval multiplication','1 2 3 4 iv* .s','3 8 \n8'),
    ('interval division','1 2 3 4 iv/ .s','1/4 2/3 \n2/3'),
    ('while repeat','def sum3 0 :s 3 :i begin 0 i - while s i + :s i 1 - :i repeat s ;\nsum3 .','6'),
]
for name,src,expect in cases:
    actual=run(src)
    assert actual==expect,f'{name}: {actual!r} != {expect!r}'
    print('PASS',name)

approximations=[
    ('square root 2','2 sqrt .',math.sqrt(2),0.000003),
    ('pi','pi .',math.pi,0.00006),
    ('e','e .',math.e,0.00003),
    ('exp(1)','1 exp .',math.e,0.00005),
    ('log(2)','2 log .',math.log(2),0.00005),
    ('log(1/2)','1/2 log .',math.log(.5),0.00005),
    ('sin(pi/6)','pi 6 / sin .',0.5,0.00006),
    ('sin(0)','0 sin .',0,0.00001),
    ('cos(0)','0 cos .',1,0.00006),
    ('cos(1)','1 cos .',math.cos(1),0.00006),
    ('atan(1)','1 atan .',math.atan(1),0.00006),
    ('atan(1/2)','1/2 atan .',math.atan(.5),0.00006),
]
for name,src,expect,limit in approximations:
    actual=run(src)
    value=float(rational(actual))
    assert abs(value-expect)<=limit,f'{name}: {actual} vs {expect} (tolerance {limit})'
    print('PASS',name,actual)

print(f'{len(cases)+len(approximations)}/{len(cases)+len(approximations)} library checks passed')
