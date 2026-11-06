"""Notes library / familiar app entry flows on an actual disposable guest.

Usage: python3 tests/qemu_app_qol.py IMAGE [ESP CODE VARS]
"""
from pathlib import Path
import importlib.util, os, shutil, sys, tempfile, time
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'stage4'))
spec=importlib.util.spec_from_file_location('home_runner',ROOT/'stage4/qemu_home.py')
home=importlib.util.module_from_spec(spec);spec.loader.exec_module(home)
uefi=len(sys.argv)==5
out=ROOT/'build/out/qol-captures'/('uefi' if uefi else 'bios');out.mkdir(parents=True,exist_ok=True)
with tempfile.TemporaryDirectory(prefix='franc-qol-') as temp:
 work=Path(temp);disk=work/'guest.img';shutil.copyfile(sys.argv[1],disk)
 extra=['-display','cocoa'] if os.environ.get('FRANC_SHOW_GUEST') else []
 if uefi:
  esp,code,variables=map(lambda x:Path(x).resolve(),sys.argv[2:]);shutil.copyfile(variables,work/'vars.fd')
  extra+=['-drive',f'file={esp},format=raw,if=virtio,readonly=on','-drive',f'if=pflash,format=raw,unit=0,readonly=on,file={code}','-drive',f'if=pflash,format=raw,unit=1,file={work / "vars.fd"}']
 g=home.Guest(disk,work,'first',extra)
 def key(k,marker,timeout=180):
  time.sleep(.35);start=len(g.out);g.hmp('sendkey '+k);return g.expect(marker,start,timeout)
 def capture(name):
  time.sleep(1);p=out/(name+'.ppm');p.unlink(missing_ok=True);g.hmp('screendump '+str(p))
  deadline=time.monotonic()+10
  while not p.exists() and time.monotonic()<deadline:time.sleep(.1)
 def create(title,text):
  key('n','Title (1-19');g.line(title,'Notes | edit')
  g.line(text,text);key('ctrl-s','SAVED |');key('esc','Notes | read');key('esc','Notes | saved notes')
 try:
  g.expect('Franc> ')
  segment=key('2','New note',300)
  assert b'kernel.franctxt' not in segment
  create('Work','Remember the report')
  create('Shopping','Milk and bread')
  g.expect('Shopping.txt',len(g.out)-800,30);capture('01-notes-list')
  key('down','> Work.txt');key('ret','Remember the report');capture('02-note-read')
  key('e','Notes | edit');g.line('More details','More details');key('ctrl-s','SAVED |')
  key('esc','Notes | read');g.expect('More details',len(g.out)-1000,30)
  key('esc','Notes | saved notes')
  key('n','Title (1-19');g.line('Work','A note with that title exists');key('spc','Notes | saved notes')
  key('n','Title (1-19');g.line('Discard','Notes | edit');g.line('Do not save','Do not save')
  key('esc','Notes | read');key('esc','Unsaved changes');capture('03-unsaved-confirm')
  segment=key('d','Notes | saved notes');assert b'Discard.txt' not in segment
  key('esc','Franc> ')
  segment=key('8','DEMO READY');assert b'5 squared = 25\n' in segment and b'5 factorial = 120\n' in segment,segment[-1000:]
  capture('04-demo-results');key('esc','Franc> ')
  key('7','MATH READY');capture('05-math-results');key('esc','Franc> ')
  g.key('r','Frac> ');g.line('depth . fp .','0\n6\nFrac> ');key('esc','Franc> ')
  key('9','ide> ');capture('06-ide-start')
  assert b'Source IDE | command menu' in g.out[-1600:]
  g.key('q','Franc> ')
  (out/'first.serial.log').write_bytes(g.out);g.close()
  g=home.Guest(disk,work,'cold',extra);g.expect('Franc> ')
  key('2','Shopping.txt',300);capture('07-notes-after-reboot')
  key('down','> Work.txt');key('ret','More details');capture('08-reopened-after-reboot')
  print('PASS: multiple named notes, read/edit, duplicate prevention, discard and cold reopening',flush=True)
  print('PASS: Demo/Math retain results and IDE opens to a titled command screen',flush=True)
 finally:
  (out/'serial.log').write_bytes(g.out);g.close()
