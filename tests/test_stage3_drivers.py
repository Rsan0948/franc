"""Test the actual Franc PS/2 decoder in hosted mode, without privileged I/O."""
from pathlib import Path
import subprocess
ROOT=Path(__file__).resolve().parents[1]
source=(ROOT/'stage3/drivers.frac').read_text()
program=source + '\n' + '''
2 dk-map .
13 dk-map .
14 dk-map .
16 dk-map .
30 dk-map .
44 dk-map .
57 dk-map .
42 dk-scancode .
30 dk-scancode .
170 dk-scancode .
30 dk-scancode .
224 dk-scancode .
75 dk-scancode .
203 dk-scancode .
1 dk-map .
hardware? .
'''
r=subprocess.run([str(ROOT/'frac')],input=program,text=True,capture_output=True,timeout=15)
assert r.returncode==0,(r.returncode,r.stderr)
assert not r.stderr,r.stderr
# The REPL prefixes each result with Frac>; definitions and input are silent.
import re
actual=[int(n) for n in re.findall(r'Frac> (-?\d+)\n',r.stdout)]
expected=[49,61,8,113,97,122,32,-1,65,-1,97,-1,1003,-1,0,0]
assert actual==expected,(actual,expected,r.stdout[-1100:])
print('PASS: Franc PS/2 scan map, Shift, E0 arrows, release and inert host port I/O')
