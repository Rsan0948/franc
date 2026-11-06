"""Real keyboard + framebuffer regressions for BIOS and UEFI integration.

Usage: python3 tests/qemu_native_integration.py IMAGE [ESP CODE VARS]
Uses only the existing QEMU monitor, guest runner and PPM decoder.
"""
from pathlib import Path
import importlib.util
import os
import shutil
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'stage4'))
sys.path.insert(0, str(ROOT))
spec = importlib.util.spec_from_file_location('home_runner', ROOT/'stage4/qemu_home.py')
home = importlib.util.module_from_spec(spec)
spec.loader.exec_module(home)
from tools.qemu_visual import parse_ppm

image = Path(sys.argv[1]).resolve()
uefi = len(sys.argv) == 5
captures = ROOT/'build/out/integration-captures'/('uefi' if uefi else 'bios')
captures.mkdir(parents=True, exist_ok=True)
with tempfile.TemporaryDirectory(prefix='franc-integration-') as temp:
    work = Path(temp)
    disk = work/'guest.img'
    shutil.copyfile(image, disk)
    extra = []
    if uefi:
        esp, code, variables = map(lambda x: Path(x).resolve(), sys.argv[2:])
        shutil.copyfile(variables, work/'vars.fd')
        extra = ['-drive',f'file={esp},format=raw,if=virtio,readonly=on',
                 '-drive',f'if=pflash,format=raw,unit=0,readonly=on,file={code}',
                 '-drive',f'if=pflash,format=raw,unit=1,file={work / "vars.fd"}']
    guest = home.Guest(disk, work, 'integration', extra)
    def ps2(key, marker, timeout=180):
        time.sleep(.35)
        start = len(guest.out)
        guest.hmp('sendkey '+key)
        return guest.expect(marker, start, timeout)
    def frame(name):
        time.sleep(.8)
        destination = captures/(name+'.ppm')
        destination.unlink(missing_ok=True)
        guest.hmp(f'screendump {destination}')
        deadline=time.monotonic()+12
        while not destination.exists() and time.monotonic()<deadline:
            time.sleep(.1)
        return parse_ppm(destination.read_bytes())
    try:
        guest.expect('Franc> ',timeout=180)
        before = frame('home')
        ps2('2','New note',300)
        ps2('ret','Title (1-19')
        guest.line('Integration','Notes | edit')
        guest.line('integration notes','integration notes')
        ps2('ctrl-s','SAVED |')
        ps2('esc','Notes | read')
        ps2('esc','Notes | saved notes')
        guest.expect('Integration.txt',len(guest.out)-500,30)
        ps2('down','> Integration.txt')
        ps2('ret','integration notes')
        after = frame('notes')
        assert before != after, 'Notes view did not reach graphical framebuffer'
        ps2('esc','Notes | saved notes')
        ps2('esc','Franc> ')
        print('PASS: Notes list, new note, save/reopen/read and PS/2 Esc',flush=True)
        ps2('1','FracCalc | Enter:')
        guest.line('7','ans: 7')
        guest.line('123456','ans: 123456')
        ps2('up',b'> 123456')
        ps2('up',b'> 7')
        result=guest.line('','ans: 7')
        assert b'723456' not in result,result
        frame('calculator-history')
        ps2('esc','Franc> ')
        print('PASS: real PS/2 history recall and Esc',flush=True)
        ps2('4','PICTURE READY',240)
        w,h,pixels=frame('crosshair')
        if uefi:
            x,y=32+160*2,112+100*2
        else:
            scale=w//320
            x,y=160*scale,100*scale
        at=(y*w+x)*3
        assert pixels[at:at+3] == b'\xff\xff\xff', (w,h,pixels[at:at+3])
        ps2('spc','Franc> ')
        print('PASS: crosshair persists in actual active framebuffer until a key',flush=True)
        ps2('9','ide> ',240)
        guest.key('i','line> ')
        guest.line('def main 4242 . ;','ide> ')
        guest.key('e','Ctrl-R trusted run')
        ps2('ctrl-r','RUN COMPLETE')
        frame('ide-after-run')
        ps2('esc','ide> ')
        ps2('esc','Franc> ')
        print('PASS: physical Ctrl-R builds and runs IDE program',flush=True)
    finally:
        (captures/'serial.log').write_bytes(guest.out)
        guest.close()
