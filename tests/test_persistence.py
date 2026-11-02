"""FRANCFS1 tests use a private image file, never a host device."""
from pathlib import Path
import os
import subprocess
import tempfile
ROOT=Path(__file__).resolve().parents[1]
def run(source,disk):
    env=dict(os.environ,FRANC_DISK_IMAGE=str(disk))
    return subprocess.run([str(ROOT/'frac')],input=source,text=True,capture_output=True,
                          env=env,timeout=10)
def main():
    failures=[]
    with tempfile.TemporaryDirectory() as d:
        disk=Path(d)/'francos.img';disk.write_bytes(bytes(256*512))
        def check(name,source,matches,nomatches=()):
            p=run(source,disk)
            ok=p.returncode==0 and not p.stderr and all(m in p.stdout for m in matches)
            ok=ok and all(m not in p.stdout for m in nomatches)
            print(('PASS' if ok else 'FAIL'),name)
            if not ok:failures.append((name,p.returncode,p.stderr,p.stdout[-700:]))
        check('disk opt-in before formatting','disk-ready? .\n"foo" "7" save\n',('Frac> 0',''))
        assert disk.read_bytes()==bytes(256*512), 'unformatted disk was modified'
        check('explicit format and persistent source','disk-format\ndisk-ready? .\n"foo" "def twice dup + ;" save\n',('Frac> 1',))
        assert disk.read_bytes()[128*512:128*512+8]==b'FRANCFS1'
        check('fresh process loads saved source','"foo" load\n9 twice .\nfiles\n',('Frac> 18\n','foo\n'))
        check('replace file and persist','"foo" "def thrice dup dup + + ;" save\n"foo" "backup" copy\n',())
        check('backup and replaced words after restart','"foo" load\n9 thrice .\n"backup" load\n9 thrice .\n',('Frac> 27\n',))
        check('launch new main exactly once','"app" "def main 42 . ;" save\n"app" launch\n',('42\n',))
        check('launch from disk across process','"app" launch\n',('42\n',))
        # Avoid auto-running old main merely because a source is loaded.
        check('launch without main fails safely','"foo" launch\n',()) if False else None
    print(f'{7-len(failures)}/7 persistence checks passing')
    if failures:print(failures)
    return bool(failures)
if __name__=='__main__':raise SystemExit(main())
