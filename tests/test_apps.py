"""Black-box tests for FracCalc, in-session source editor, and Stern-Brocot explorer."""
from pathlib import Path
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[1]
LIBRARY_ORDER=('fixpt','cf','approx','iv','trans','graphics','ford','spiro','calc','edit','walk')
LIBS=''.join((ROOT/'lib'/f'{name}.frac').read_text() for name in LIBRARY_ORDER)

def run(source, graphics=False):
    import tempfile
    with tempfile.TemporaryDirectory() as temp:
        proc=subprocess.run([str(ROOT/'frac')],input=LIBS+source,text=True,
                            capture_output=True,timeout=20,cwd=temp)
        frame=Path(temp)/'franc-frame.ppm'
        data=frame.read_bytes() if graphics and frame.exists() else None
    return proc.returncode,proc.stdout,proc.stderr,data

cases=[
    ('history arrows restore typed draft',
     'calc-main\n7\n123456\n99\x1b[A\x1b[A\x1b[B\x1b[B\n\x1b',
     ('ans: 99\n',)),

    ('history recall terminates shorter expression',
     'calc-main\n7\n123456\n\x1b[A\x1b[A\n\x1b',
     ('> 7\nans: 7\n> Frac>',)),

    ('dynamic evaluation and dictionary mutation',
     '"1/3 1/6 +" eval .\n"def twice dup + ;" eval\n7 twice .\n',
     ('Frac> 1/2\n','Frac> 14\n')),
    ('RAM save/load and independent backup',
     '"test" "def twice dup + ;" save\n"test" "backup" copy\n"test" "def thrice dup dup + + ;" save\n"test" load\n9 thrice .\n"backup" load\n9 twice .\n',
     ('Frac> 27\n','Frac> 18\n')),
    ('byte-addressable app buffer',
     'calc-buffer 255 b!\ncalc-buffer b@ .\ncalc-buffer 10 + 65 b!\ncalc-buffer 10 + b@ .\n',
     ('Frac> 255\n','Frac> 65\n')),
    ('left/right Farey invariants',
     'walk-reset\nwalk-check .\nwalk-left\nwk-p wk-q / .\nwalk-check .\nwalk-right\nwk-p wk-q / .\nwalk-check .\nwalk-left\nwk-p wk-q / .\nwalk-check .\n',
     ('Frac> 1/2\n','Frac> 2/3\n','Frac> 3/5\n')),
    ('edge neighbors have infinite bounds',
     'walk-reset\nwk-l wk-m / .\nwk-u wk-v / .\nwalk-check .\n',
     ('Frac> 0\n','Frac> ∞\n','Frac> 1\n')),
    ('calculate expression, define word, and use it',
     'calc-main\n1/3 1/6 +\ndef twice dup + ;\n7 twice\nans 2 *\n\x1b',
     ('ans: 1/2\n','ans: 14\n','ans: 28\n')),
    ('calculator edit/backspace',
     'calc-main\n12\n2\x08\x083\n\x1b',
     ('ans: 12\n','ans: 3\n')),
    ('calculator up-arrow history',
     'calc-main\n1/3\n1/4\n\x1b[A\n\x1b',
     ('ans: 1/3\n','ans: 1/4\n')),
    ('RAM editor replaces source, original backup remains',
     '"foo" "def twice dup + ;" save\n"foo" "backup" copy\n"foo" edit-line\ndef triple dup dup + + ;\n"foo" load\n9 triple .\n"backup" load\n9 twice .\n',
     ('Edit RAM source: foo\n','Frac> 27\n','Frac> 18\n')),
    ('interactive walk events and certificate',
     'walk-main\n\x1b[D\x1b[C\x1b[D\x1b',
     ('current: 1/2\n','current: 2/3\n','current: 3/5\n','certified: 1\n')),
    ('session files enumeration',
     '"foo" "7" save\n"bar" "8" save\nfiles\n',
     ('foo\n','bar\n')),
]

def main():
    bad=[]
    for name,commands,expected in cases:
        try:
            code,out,err,_=run(commands)
            assert code==0,(code,err)
            assert not err,err
            for needle in expected:
                assert needle in out,(needle,out[-750:])
            print('PASS',name)
        except Exception as e:
            print('FAIL',name,repr(e));bad.append(name)
    try:
        code,out,err,frame=run('walk-reset\nwalk-left\nwalk-render\nscreenshot\n',graphics=True)
        assert code==0 and not err,(code,err)
        assert frame and frame.startswith(b'P6\n320 200\n255\n')
        assert 'current: 1/2' in out
        print('PASS walker graphics screenshot')
    except Exception as e:
        print('FAIL walker graphics screenshot',repr(e));bad.append('walker screenshot')
    print(f'{len(cases)+1-len(bad)}/{len(cases)+1} app checks passing')
    return bool(bad)

if __name__=='__main__':sys.exit(main())
