"""Check the launcher refreshes code while retaining the existing user slots.

A subprocess substitutes only the QEMU process; the real launcher's file
refresh, lock and cleanup paths run against a disposable disk.
"""
from pathlib import Path
import os, subprocess, sys, tempfile
ROOT=Path(__file__).resolve().parents[1]
image=ROOT/'build/out/francos-bios.img'
assert image.is_file(), 'Build the native image before this launcher test'
with tempfile.TemporaryDirectory(prefix='franc-launcher-') as temp:
    work=Path(temp)
    qemu=work/'qemu'
    qemu.write_text('#!'+sys.executable+'\n'+'''
from pathlib import Path
import os,sys
arg=next(a for a in sys.argv if a.startswith('file=') and 'if=ide' in a)
disk=Path(arg[5:].split(',')[0])
with disk.open('r+b') as f:
    if os.environ.get('WRITE_NOTE'):
        name=b'Persistence.txt';text=b'Saved from launcher'
        f.seek(129*512+64);f.write(name+b'\\0'*(24-len(name))+len(text).to_bytes(2,'little')+b'\\0'*6)
        f.seek(144*512);f.write(text+b'\\0')
        f.seek(0);f.write(b'\\xab')
    else:
        f.seek(144*512);assert f.read(19)==b'Saved from launcher'
''')
    qemu.chmod(0o755)
    env=dict(os.environ,XDG_DATA_HOME=str(work),QEMU=str(qemu))
    launcher=['sh',str(ROOT/'tools/run_francos.sh'),'bios']
    r=subprocess.run(launcher,env=dict(env,WRITE_NOTE='1'),capture_output=True,text=True)
    assert r.returncode==0,(r.stdout,r.stderr)
    disk=work/'francos/disk.img';assert disk.is_file()
    r=subprocess.run(launcher,env=env,capture_output=True,text=True)
    assert r.returncode==0,(r.stdout,r.stderr)
    current=disk.read_bytes();fresh=image.read_bytes()
    assert current[0]==fresh[0]
    assert current[129*512:129*512+64]==fresh[129*512:129*512+64]
    assert current[136*512:144*512]==fresh[136*512:144*512]
    assert current[144*512:144*512+19]==b'Saved from launcher'
    assert not Path(str(disk)+'.lock').exists()
    lock=Path(str(disk)+'.lock');lock.mkdir();(lock/'pid').write_text(str(os.getpid()))
    r=subprocess.run(launcher,env=env,capture_output=True,text=True)
    assert r.returncode!=0 and disk.read_bytes()==current
    (lock/'pid').unlink();lock.rmdir()
    # An invalid/truncated disk is retained, not silently replaced.
    disk.write_bytes(b'old disk')
    r=subprocess.run(launcher,env=env,capture_output=True,text=True)
    assert r.returncode!=0 and disk.read_bytes()==b'old disk'
    assert not lock.exists()
print('PASS: launcher preserves notes across code refresh, updates metadata, locks sessions and retains damaged disks')
