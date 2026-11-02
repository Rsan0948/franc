#!/usr/bin/env python3
"""First AOT bridge: compile Franc syntax into relocatable x86-64 GNU assembly.

No C compilation or C object is involved in the generated kernel. The bootstrap
compiler is currently Python; replacing it with a Franc-written compiler is the
remaining *build self-hosting* milestone, tracked explicitly in README.md.
"""
from __future__ import annotations
import argparse
import re
from pathlib import Path

OPS = { '+':'fr_add','-':'fr_sub','*':'fr_mul','/':'fr_div',
    'dup':'fr_dup','drop':'fr_drop','swap':'fr_swap','over':'fr_over',
    '.':'fr_dot','emit':'fr_emit','type':'fr_type','cr':'fr_cr',
    'pixel':'fr_pixel','clearfb':'fr_clear',
    'key':'fr_key','key?':'fr_keyq', 'depth':'fr_depth',
    'neg':'fr_neg','abs':'fr_abs', 'floor':'fr_floor',
    'b@':'fr_bfetch','b!':'fr_bstore',
    'io8@':'fr_inb','io8!':'fr_outb',
}

class CompilerError(Exception): pass

def lex(line):
    result=[]; i=0
    while i<len(line):
        if line[i].isspace(): i+=1;continue
        if line[i]=='\\': break
        if line[i]=='"':
            j=i+1; out=[]
            while j<len(line) and line[j]!='"':
                if line[j]=='\\' and j+1<len(line):
                    j+=1;out.append({'n':'\n','r':'\r','t':'\t','0':'\0'}.get(line[j],line[j]))
                else:out.append(line[j])
                j+=1
            if j==len(line):raise CompilerError('unterminated string')
            result.append(('string',''.join(out)));i=j+1;continue
        j=i
        while j<len(line) and not line[j].isspace() and line[j]!='\\': j+=1
        result.append(('word',line[i:j]));i=j
    return result

def literal(tok):
    def parse_int(t):
        if not t: raise ValueError()
        sign = -1 if t.startswith('-') else 1
        if t[:1] in '-+':t=t[1:]
        base=10
        if t.startswith('$'):base=16;t=t[1:]
        if t.startswith('#'):base=2;t=t[1:]
        return sign*int(t,base)
    try:
        if '/' in tok:
            a,b=tok.split('/',1)
            n,d=parse_int(a),parse_int(b)
        elif '.' in tok:
            whole,part=tok.split('.',1)
            sign=-1 if whole.startswith('-') else 1
            n=parse_int(whole)*(10**len(part))+sign*int(part)
            d=10**len(part)
        else:n,d=parse_int(tok),1
        for v in (n,d):
            if v < -(1<<63) or v >= (1<<63):raise ValueError()
        return n,d
    except (ValueError,TypeError):return None

def ident(tok):
    return 'f_'+''.join('_%02x'%ord(ch) if not ch.isalnum() else ch for ch in tok)

def compile_program(sources):
    defs=[];main=[]
    for filename in sources:
        for number,line in enumerate(Path(filename).read_text().splitlines(),1):
            toks=lex(line)
            if not toks:continue
            if toks[0]==('word','def'):
                if len(toks)<4 or toks[1][0]!='word' or toks[-1]!=('word',';'):
                    raise CompilerError(f'{filename}:{number}: def must be on one line and end in ;')
                defs.append((toks[1][1],toks[2:-1],filename,number))
            else:
                main.append((toks,filename,number))
    labels={name:ident(name) for name,_,_,_ in defs}
    if len(labels)!=len(defs):raise CompilerError('duplicate definitions')
    if 'boot' not in labels:raise CompilerError('define a boot word as the kernel entry point')
    usedregs={}
    for _,ts,_,_ in defs:
        for kind,v in ts:
            if kind=='word' and v.startswith(':'):usedregs[v[1:]]=None
    for ts,_,_ in main:
        for kind,v in ts:
            if kind=='word' and v.startswith(':'):usedregs[v[1:]]=None
    chunks=['.code64','.text','.global franc_entry','franc_entry:', '  call f_boot','  ret']
    literal_strings=[]; counter=[0]
    def uid(): counter[0]+=1;return counter[0]
    def make(lines, toks, filename, number):
        control=[]
        for kind,token in toks:
            if kind=='string':
                name=f'string_{uid()}'
                literal_strings.append((name,token))
                lines.extend([f'  leaq {name}(%rip), %rdi','  movq $1, %rsi','  call fr_push'])
                continue
            if token.startswith(':'):
                k=token[1:]
                if not k:raise CompilerError('empty register')
                usedregs[k]=None
                lines.extend([f'  leaq reg_{ident(k)}(%rip), %rdi','  call fr_reg_set'])
            elif token in usedregs:
                lines.extend([f'  leaq reg_{ident(token)}(%rip), %rdi','  call fr_reg_get'])
            elif token in ('if','if0','ifnz','while'):
                if token=='while' and (not control or control[-1][0]!='begin'):
                    raise CompilerError(f'{filename}:{number}: while requires begin')
                tag=f'ctrl_{uid()}'
                lines.extend(['  call fr_condition', '  testq %rax, %rax'])
                # Franc if: negative; if0: zero; ifnz: nonzero.
                jump={'if':'jns','while':'jns','if0':'jnz','ifnz':'jz'}[token]
                lines.append(f'  {jump} {tag}')
                control.append((token,tag))
            elif token=='begin':
                tag=f'ctrl_{uid()}';lines.append(f'{tag}:');control.append(('begin',tag))
            elif token=='else':
                if not control or control[-1][0] not in ('if','if0','ifnz'):
                    raise CompilerError('else without if')
                _,target=control.pop();end=f'ctrl_{uid()}'
                lines.extend([f'  jmp {end}',f'{target}:'])
                control.append(('else',end))
            elif token=='then':
                if not control or control[-1][0] not in ('if','if0','ifnz','else'):
                    raise CompilerError('then without if')
                _,target=control.pop();lines.append(f'{target}:')
            elif token=='again':
                if not control or control[-1][0]!='begin':raise CompilerError('again without begin')
                _,start=control.pop();lines.append(f'  jmp {start}')
            elif token=='repeat':
                if len(control)<2 or control[-1][0]!='while' or control[-2][0]!='begin':
                    raise CompilerError('repeat requires begin ... while')
                _,end=control.pop();_,start=control.pop()
                lines.extend([f'  jmp {start}',f'{end}:'])
            elif token=='exit':lines.append('  jmp .Lreturn_'+str(number)) # replaced below, per definition
            elif token in OPS:lines.append('  call '+OPS[token])
            elif token in labels:lines.append('  call '+labels[token])
            elif (v:=literal(token)) is not None:
                lines.extend([f'  movabsq ${v[0]}, %rdi',f'  movabsq ${v[1]}, %rsi','  call fr_push'])
            else:raise CompilerError(f'{filename}:{number}: unknown word {token}')
        if control:raise CompilerError(f'{filename}:{number}: unclosed {control}')
    for name,toks,filename,number in defs:
        body=[f'{labels[name]}:', '  pushq %rbp','  movq %rsp, %rbp']
        # Every entry has ABI-aligned stack before calls; nested defs do too.
        make(body,toks,filename,number)
        body=[line.replace('.Lreturn_'+str(number),f'.Lreturn_{ident(name)}') for line in body]
        body.extend([f'.Lreturn_{ident(name)}:', '  popq %rbp','  ret'])
        chunks.extend(body)
    if main:raise CompilerError('top-level expressions unsupported in kernel AOT; put them in boot')
    chunks.append('.section .rodata')
    for name,st in literal_strings:
        chunks.append(f'{name}:')
        chunks.extend(f'  .byte {b}' for b in st.encode('utf-8')+b'\x00')
    chunks.extend(['.bss','.balign 16'])
    for k in usedregs:chunks.extend([f'reg_{ident(k)}:', '  .zero 16'])
    chunks.append('.section .note.GNU-stack,"",@progbits')
    return '\n'.join(chunks)+'\n'

def main():
    p=argparse.ArgumentParser();p.add_argument('src',nargs='+',type=Path);p.add_argument('-o','--out',required=True,type=Path)
    a=p.parse_args();a.out.write_text(compile_program(a.src))
if __name__=='__main__':main()
