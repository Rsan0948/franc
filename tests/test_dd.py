"""Two-component bounded rational expansion: no false double-double promises."""
from pathlib import Path
import subprocess
ROOT=Path(__file__).resolve().parents[1]
LIB=(ROOT/'lib/dd.frac').read_text()
CASES={
  'split sum beyond single Rat':('9000000000000000000 0 0 1/10 dd+ .s', '9000000000000000000 1/10'),
  'split addition':('3 1/10 2 1/100 dd+ .s', '5 11/100'),
  'split subtraction':('3 1/10 2 1/100 dd- .s', '1 9/100'),
  'split negation':('3 1/10 dd-neg .s', '-3 -1/10'),
  'split multiplication':('3 1/10 2 1/100 dd* .s', '6 231/1000'),
  'integer scaling':('3 1/10 2 dd-int* .s', '6 1/5'),
  'collapse when representable':('3 1/10 dd-collapse .', '31/10'),
  'safe component display':('3 1/10 dd.', '3\n1/10'),
}
def main():
    failed=[]
    for name,(code,expect) in CASES.items():
        p=subprocess.run([str(ROOT/'frac')],input=LIB+'\n'+code+'\n',text=True,capture_output=True,timeout=10)
        output=p.stdout.replace('Frac> ','')
        ok=p.returncode==0 and not p.stderr and expect in output
        print(('PASS' if ok else 'FAIL'),name)
        if not ok:failed.append((name,p.stderr,output[-500:]))
    if failed:print(failed)
    print(f'{len(CASES)-len(failed)}/{len(CASES)} dd tests passing')
    return bool(failed)
if __name__=='__main__':raise SystemExit(main())
