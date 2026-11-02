"""Exercise real Frac JIT graphics words and rational demo code with hosted framebuffer."""
from pathlib import Path
import subprocess
import tempfile
import sys

ROOT=Path(__file__).resolve().parents[1]
LIBS=''.join((ROOT/'lib'/f'{name}.frac').read_text() for name in
             ('fixpt','cf','approx','iv','trans','graphics','ford','spiro'))

# Output is noisily prefixed with prompt markers; explicit `.` exposes results.
def run(commands, image=False, stage2=False):
    with tempfile.TemporaryDirectory() as temp:
        p=subprocess.run([str(ROOT/'frac')],input=LIBS+'\n'+((ROOT/'stage2/compiler.frac').read_text() if stage2 else '')+'\n'+commands+'\n',
                         text=True,capture_output=True,cwd=temp,timeout=15)
        data=(Path(temp)/'franc-frame.ppm').read_bytes() if image and (Path(temp)/'franc-frame.ppm').exists() else None
    return p.returncode,p.stdout.replace('Frac> ','').strip(),p.stderr,data

cases=[
    ('pixel roundtrip','0 clearfb\n10 20 14 pixel\n10 20 pixel@ .','14'),
    ('coordinate truncation','0 clearfb\n21/2 41/2 12 pixel\n10 20 pixel@ .','12'),
    ('out of bounds reads','0 clearfb\n500 20 14 pixel\n500 20 pixel@ .','0'),
    ('clear frame','3 clearfb\n140 90 pixel@ .','3'),
    ('line drawing','0 clearfb\n0 100 319 100 15 line\n160 100 pixel@ .','15'),
    ('rectangle clipping','0 clearfb\n-5 -5 10 10 11 fillrect\n0 0 pixel@ .','11'),
    ('unchanged exterior','0 clearfb\n0 0 3 3 11 fillrect\n100 100 pixel@ .','0'),
    ('crosshair library','crosshair\n160 100 pixel@ .','15'),
    ('Ford certificate neighbor','1 2 1 3 tangent? .','1'),
    ('Ford certificate not neighbor','1 3 1 5 tangent? .','0'),
    ('pi convergents neighbor','355 113 22 7 tangent? .','1'),
    ('Ford midpoint circle','2 fordland\n160 175 pixel@ .','3'),
    ('direct Stage 2 graphics word','"3 4 12 pixel" s2-compile s2-run\n3 4 pixel@ .','12'),
]
# two checks below don't rely on any human interpretation of screenshots.
def check_image(source, minimum_colored):
    code,out,err,data=run(source+'\nscreenshot',image=True)
    assert code==0 and not err,(out,err)
    assert data and data.startswith(b'P6\n320 200\n255\n'), 'invalid PPM output'
    pixels=data.split(b'\n',3)[3]
    assert len(pixels)==320*200*3, len(pixels)
    count=sum(1 for i in range(0,len(pixels),3) if pixels[i:i+3]!=b'\0\0\0')
    assert count>=minimum_colored,(count,minimum_colored)
    return count

def main():
    failures=[]
    for name,src,expected in cases:
        try:
            code,out,err,_=run(src,stage2=(name=='direct Stage 2 graphics word'))
            assert code==0 and out==expected and not err,(code,out,err)
            print('PASS',name)
        except Exception as exc:
            failures.append((name,str(exc)))
            print('FAIL',name,exc)
    for name,src,count in [('Ford landscape','20 fordland',5000),
                           ('rational spirograph','spiro-demo',50)]:
        try:
            found=check_image(src,count)
            print('PASS',name,found,'colored pixels')
        except Exception as exc:
            failures.append((name,str(exc)))
            print('FAIL',name,exc)
    print(f'{len(cases)+2-len(failures)}/{len(cases)+2} graphics tests passed')
    return bool(failures)
if __name__=='__main__':sys.exit(main())
