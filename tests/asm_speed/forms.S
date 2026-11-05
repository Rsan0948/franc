/* Instruction forms the kernel itself does not use, compared with GNU as. */
.text
.code64
forms64:
  rolq $3,%rax
  rorl %cl,%ebx
  rclb $1,%al
  rcrw $2,%cx
  sarl %edx
  shlb %cl,(%rax)
  shrq $1,8(%rbx)
  mulq %rbx
  mull (%rcx)
  divb %bl
  idivw %cx
  negb %al
  notw (%rdi)
  imull %ecx
  imulq $1000,%rbx,%rcx
  imulw $3,%ax
  imulq (%rax),%rbx
  imull $5,(%rbx),%edx
  testb $1,%al
  testw $0x1234,%ax
  testl $1,%ebx
  testq $1,(%rax)
  testb %al,(%rbx)
  testq (%rax),%rbx
  xchgl %eax,%ebx
  xchgb %al,%bl
  xchgq %rbx,(%rax)
  xchgw %ax,%cx
  pushq (%rax)
  popq 8(%rbx)
  pushq $1000
  pushq $-1
  popq %r15
  pushw %ax
  popw %bx
  push %fs
  pop %gs
  movb $1,%al
  movb $1,%r9b
  movb $1,(%rax)
  movw $1,%cx
  movw $1,(%rax)
  movl $1,%r10d
  movl $0xffffffff,%eax
  movq $-1,%rax
  movq $0x100000000,%rax
  movq $1,(%rax)
  movb %sil,%al
  movb %dil,(%rax)
  movb (%rax),%bpl
  movb %ah,%al
  movzbw %al,%bx
  movzbl (%rax),%ecx
  movzwl %ax,%ebx
  movzbq %r8b,%r9
  movzwq (%r12),%r13
  leal (%rax,%rbx,2),%ecx
  leaq 8(%rsp),%rax
  leaq (%r12),%rbx
  leaq (%r13),%rbx
  leaq (%rbp),%rax
  leaq 0x1000(,%rcx,4),%rax
  leaq 1000(%rax,%r9,8),%rdx
  leaq (%rax,%rax),%rax
  movq 0x1000,%rax
  movl %eax,0x2000
  addb $1,%al
  addb $1,%bl
  addw $1000,%ax
  addw $1000,%bx
  addl $1000,%eax
  addq $-129,%rcx
  addq $127,%rcx
  addq $128,%rax
  orb (%rax),%bl
  andl %ecx,(%rax)
  xorw %cx,(%rdx)
  sbbq $0,%rax
  adcb %al,%bl
  andl $0xffffffff,%ecx
  cmpw $0xffff,%ax
  shldq $4,%rax,%rbx
  shrdl %cl,%eax,%ebx
  btl $3,%eax
  btsq %rax,(%rbx)
  btrw $2,%cx
  bswapl %r9d
  bswapq %r9
  inb $0x60,%al
  inw $0x60,%ax
  inl $0x60,%eax
  inw %dx,%ax
  outw %ax,$0x60
  outl %eax,%dx
  int $3
  int $0x80
  std
  stosw
  stosl
  movsw
  movsq
  lodsb
  rep movsq
  nop
  call *%r10
  call *(%rax)
  jmp *%rax
  jmp *8(%rbx,%rcx,8)
  loop 1f
1: jno 1b
  jp 1b
  jnp 1b
  jl 1b
  jge 1b
  jle 1b
  jg 1b
  js 2f
2:
  lidt (%rax)
  lgdt 8(%rbx)
  ltr (%rax)
  movw %ds,%ax
  movq %rax,%cr3
  movq %r9,%cr4
  movq %cr2,%r10
  movw (%rax),%ds
  movabsq $0x8000000000000000,%rax
  movabs $0xffffffffffffffff,%r12
.code32
forms32:
  pushl %eax
  popl %ebx
  incl %ecx
  decw %dx
  movl %eax,0x1234
  movb 0x1234,%al
  movl (%edi,%esi,4),%eax
  movw (%ebx),%ax
  jmp 3f
3: call 3b
  movl $1,%eax
  jc 3b
  leal 8(%esp),%eax
  addl $1000,%eax
.code16
forms16:
  movw (%bx),%ax
  movb 5(%bp),%al
  movw 1000(%si),%cx
  movl (%di),%eax
  movl %eax,0x10
  movl (%ebx),%eax
  call 4f
4: jmp 4b
  jne 4b
  lret
.code64
.data
  .word 0x1234,-1
  .short 7
  .long 'A',1+2*3
  .quad 0x8000000000000000
  .ascii "a\n\t\"\\"
  .asciz "end"
  .skip 3,0x41
  .balign 8
far_table:
  .quad forms64+8,forms16
  .long far_table-forms_end_of_data
forms_end_of_data:
.bss
  .skip 10
  .balign 16
.comm shared_cell,16,16
