"""AOT compiler unit checks, independent from the host C compiler."""
import importlib.util, tempfile
from pathlib import Path
spec=importlib.util.spec_from_file_location('franc_aot',Path(__file__).with_name('compiler.py'))
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
assert m.lex('def a "foo bar" type ; \\ comment')==[('word','def'),('word','a'),('string','foo bar'),('word','type'),('word',';')]
assert m.literal('$FF/$10')==(255,16)
assert m.literal('#1010')==(10,1)
assert m.literal('-0.25')==(-25,100)
assert m.literal('a') is None
with tempfile.TemporaryDirectory() as t:
    p=Path(t)/'kernel.frac'
    p.write_text('def sq dup * ;\ndef boot 2 sq 0 if0 "yes" type else "no" type then ;\n')
    asm=m.compile_program([p]);assert 'call f_sq' in asm
    assert 'jnz ctrl_' in asm
    assert 'call fr_type' in asm
    p.write_text('def boot unknown ;\n')
    try:m.compile_program([p]);raise AssertionError('unknown must be rejected')
    except m.CompilerError: pass
print('PASS: lexing, rational parsing, branch lowering, unknown-word rejection')
