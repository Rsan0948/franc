"""Real guest IDE output pane, shell prompt and two-level Escape acceptance.
Usage: python3 tests/qemu_ide_output.py IMAGE [ESP CODE VARS]
"""
from pathlib import Path
import importlib.util,shutil,sys,tempfile,time
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'stage4'))
spec=importlib.util.spec_from_file_location('home_runner',ROOT/'stage4/qemu_home.py')
home=importlib.util.module_from_spec(spec);spec.loader.exec_module(home)
uefi=len(sys.argv)==5
out=ROOT/'build/out/ide-output-captures'/('uefi' if uefi else 'bios');out.mkdir(parents=True,exist_ok=True)
with tempfile.TemporaryDirectory(prefix='franc-ide-output-') as temp:
 work=Path(temp);disk=work/'guest.img';shutil.copyfile(sys.argv[1],disk);extra=[]
 if uefi:
  esp,code,variables=map(lambda x:Path(x).resolve(),sys.argv[2:]);shutil.copyfile(variables,work/'vars.fd')
  extra=['-drive',f'file={esp},format=raw,if=virtio,readonly=on','-drive',f'if=pflash,format=raw,unit=0,readonly=on,file={code}','-drive',f'if=pflash,format=raw,unit=1,file={work / "vars.fd"}']
 g=home.Guest(disk,work,'pane',extra)
 def key(k,marker,timeout=160):
  time.sleep(.35);start=len(g.out);g.hmp('sendkey '+k);return g.expect(marker,start,timeout)
 def capture(name):
  time.sleep(1);p=out/(name+'.ppm');p.unlink(missing_ok=True);g.hmp('screendump '+str(p))
  deadline=time.monotonic()+12
  while (not p.exists() or p.stat().st_size<1000) and time.monotonic()<deadline:time.sleep(.1)
  from qemu_visual import parse_ppm
  return parse_ppm(p.read_bytes())
 def append(source):
  g.key('i','line> ');g.line(source,'ide> ');g.key('e','OUTPUT |')
 try:
  g.expect('Franc> ');g.key('9','ide> ',300)
  append('def main 42 . ;')
  before=capture('01-before-run')
  result=key('ctrl-r','RUN COMPLETE')
  assert b'42\n' in result and b'OUTPUT |' in result,result[-1000:]
  after=capture('02-output-and-source');assert before!=after
  # The source is still active: Ctrl-T evaluates in the same dictionary.
  key('ctrl-t','console> ');g.line('5 6 +','11\n');capture('03-shell-result')
  key('ctrl-t','console> ');g.line('ide-cursor .','15\n')
  key('ctrl-t','console> ');g.line('ide-buffer type','def main 42 . ;\n')
  # Real editor keys replace 42 with 99 without leaving the editor.
  key('ctrl-a','OUTPUT |')
  for _ in range(9):key('right','OUTPUT |')
  key('ctrl-d','OUTPUT |');key('ctrl-d','OUTPUT |')
  key('9','OUTPUT |');key('9','OUTPUT |')
  result=key('ctrl-r','RUN COMPLETE');assert b'99\n' in result,result[-1200:]
  capture('04-edit-and-rerun')
  key('ctrl-l','No output yet.')
  key('esc','ide> ')
  # Compile errors appear in the pane and do not execute the old main.
  g.key('x','ide> ');append('def main invalid-output-token ;')
  result=key('ctrl-r','COMPILE FAILED')
  assert b'RUN COMPLETE' not in result and b'99\n' not in result,result
  capture('05-compile-error');key('esc','ide> ')
  g.key('x','ide> ')
  append('def main 0 begin dup 1000 - while dup . 1 + repeat drop ;')
  result=key('ctrl-r','OUTPUT [truncated]');capture('06-bounded-long-output')
  key('ctrl-t','console> ');g.line('2 3 +','5\n')
  key('esc','ide> ');key('esc','Franc> ')
  print('PASS: IDE run/source/cursor retention, shell, edits/rerun, errors and bounded output',flush=True)
  print('PASS: Esc editor -> IDE commands -> Home',flush=True)
 finally:
  (out/'serial.log').write_bytes(g.out);g.close()
