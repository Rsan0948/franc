"""Native guest failure-path acceptance on a disposable FRANCFS1 disk."""
from pathlib import Path
import importlib.util
import shutil
import sys
import tempfile
import time
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'stage4'))
spec=importlib.util.spec_from_file_location('home_runner',ROOT/'stage4/qemu_home.py')
home=importlib.util.module_from_spec(spec);spec.loader.exec_module(home)
output=ROOT/'build/out/failure-captures';output.mkdir(parents=True,exist_ok=True)
with tempfile.TemporaryDirectory(prefix='franc-failures-') as temp:
    work=Path(temp);disk=work/'guest.img';shutil.copyfile(sys.argv[1],disk)
    g=home.Guest(disk,work,'failures')
    try:
        g.expect('Franc> ')
        g.key('l','APPS READY',300);g.expect('Franc> ',len(g.out)-100,30)
        g.key('r','Frac> ')
        g.line('"good" "def main 42 . ;" save','Frac> ')
        start=len(g.out)
        g.line('"good" launch .','1\nFrac> ')
        assert b'42\n' in g.out[start:]
        start=len(g.out)
        g.line('"missing" launch .','0\nFrac> ')
        g.line('"plain" "def other 7 ;" save','Frac> ')
        g.line('"plain" launch .','0\nFrac> ')
        g.line('"bad" "def main invalid-integration-token ;" save','Frac> ')
        g.line('"bad" launch .','0\nFrac> ')
        assert b'42\n' not in g.out[start:], bytes(g.out[start:])
        print('PASS: real guest refuses missing, main-less and malformed app launches',flush=True)
        definition=('def fill 0 :ide-i begin ide-i 12 - while '
          'ide-buffer 3500 + 102 b! ide-buffer 3501 + ide-i 48 + b! '
          'ide-buffer 3502 + 0 b! ide-buffer 3500 + "x" fs-save drop '
          'ide-i 1 + :ide-i repeat ;')
        g.line(definition,'Frac> ')
        g.line('fill','Frac> ')
        g.line('"extra" "x" fs-save .','0\nFrac> ')
        g.line('"notes.frac" edit-line','Edit RAM source: notes.frac')
        g.expect('> ',len(g.out)-100,30)
        g.line('retain these notes','SAVE FAILED')
        time.sleep(1)
        g.hmp(f'screendump {output / "notes-full-disk.ppm"}')
        g.key('x','Frac> ')
        g.line('calc-buffer type cr','retain these notes\nFrac> ')
        print('PASS: real guest full directory is reported by Notes and edit buffer survives',flush=True)
    finally:
        (output/'serial.log').write_bytes(g.out);g.close()
