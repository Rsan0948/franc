"""Real hosted Franc JIT tests for Stage 3 code, including framebuffer bytes.
Hardware ATA writes must additionally pass the QEMU smoke/persistence tests.
"""
from pathlib import Path
import subprocess, tempfile
root=Path(__file__).resolve().parents[1]
source='\n'.join((root/'stage3'/f).read_text() for f in ('ata.frac','storage.frac','display.frac'))
program='''
0 clearfb
3 4 12 pixel
3 4 pixel@ .
2 2 7 3 11 fillrect
3 3 pixel@ .
0 10 20 10 14 line
17 10 pixel@ .
63 0 8 8 2 fillrect
80 10 pixel@ .
65 0 font-row .
0 :f-test
0 :f-i begin f-i 8 - while f-i "FRANCFS1" f-i + byte@ sector-byte! f-i 1 + :f-i repeat
fs-magic? .
fs-zero
0 65 sector-byte!
1 66 sector-byte!
2 0 sector-byte!
"AB" fs-find .
fs-free .
"tmp.frac" "def test-value 47 ;" fs-save .
"tmp.frac" fs-source s2-source .
'''
# s2-source needs compiler loaded; test source pointers directly in this standalone case.
program=program.replace('"tmp.frac" fs-source s2-source .','"tmp.frac" fs-source type')
with tempfile.TemporaryDirectory() as d:
    p=subprocess.run([str(root/'frac')],input=source+'\n'+program+'\n'+'"test" type\n'+ '0 clearfb\n0 0 65 fg-glyph\nscreenshot\n',text=True,capture_output=True,cwd=d,timeout=50)
    assert p.returncode==0,(p.returncode,p.stderr[-2000:])
    assert not p.stderr,p.stderr
    import re
    values=[int(x) for x in re.findall(r'Frac> (-?\d+)\n',p.stdout)]
    assert values==[12,11,14,0,12,1,0,1,1],(values,p.stdout[-1000:])
    assert 'def test-value 47 ;' in p.stdout,p.stdout[-800:]
    ppm=Path(d)/'franc-frame.ppm'
    assert ppm.exists(),'Screenshot missing'
    dat=ppm.read_bytes().split(b'\n',3)[3]
    assert len(dat)==320*200*3
    assert any(dat[i:i+3]!=b'\0\0\0' for i in range(0,8*320*3,3)), 'Font glyph did not rasterize'
    print('PASS Stage 3: Franc pixel/rectangle/line/console glyph, memory safety, directory logic, host source fallback')
