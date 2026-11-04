/* Franc standalone experimental micro-runtime: x86-64 assembly only.
 * This is a C-free kernel, not yet the full Stage 3 primitive set.
 * SysV function ABI. Each Rat is 16 bytes {signed numerator, denominator}.
 */
.code64
.section .text.entry,"ax"
.global _kstart
.extern __bss_start
.extern __bss_end
.extern franc_entry
_kstart:
    /* Exactly five bytes: JMP rel32 over the real-mode BIOS helper.
     * The Stage 1 boot sector far-calls 0x1000:0005 while still in
     * real mode; UEFI/BIOS 64-bit entry continues at this JMP target.
     */
    .byte 0xe9
    .long .Lkstart64 - . - 4
    .code16
.Lbios_e820_entry:
    pushw %ds
    pushw %es
    pushw %di
    pushw %bp
    xorw %ax,%ax
    movw %ax,%ds
    movw %ax,%es
    movl $0,0x4ff0
    movw $0,0x4ff4
    movw $0x5000,%di
    xorw %bp,%bp
    xorl %ebx,%ebx
.Lbios_e820_next:
    movl $0,0(%di)
    movl $0,4(%di)
    movl $0,8(%di)
    movl $0,12(%di)
    movl $0,16(%di)
    movl $1,20(%di)
    movl $0xe820,%eax
    movl $0x534d4150,%edx
    movl $24,%ecx
    int $0x15
    jc .Lbios_e820_return
    cmpl $0x534d4150,%eax
    jne .Lbios_e820_return
    cmpw $20,%cx
    jb .Lbios_e820_return
    incw %bp
    cmpw $48,%bp
    ja .Lbios_e820_return
    addw $24,%di
    testl %ebx,%ebx
    jne .Lbios_e820_next
    movw %bp,0x4ff4
    movl $0x30323845,0x4ff0
.Lbios_e820_return:
    popw %bp
    popw %di
    popw %es
    popw %ds
    lret
    .code64
.Lkstart64:
    cld
    movabs $__bss_start,%rdi
    movabs $__bss_end,%rcx
    subq %rdi,%rcx
    xor %eax,%eax
    rep stosb
    /* UEFI passes a firmware-allocated GOP descriptor in r15, with
     * r14=GOPH. Copy it after BSS clearing into kernel-owned storage.
     * BIOS boot never sets the marker and leaves the descriptor empty. */
    cmpq $0x474F5048,%r14
    jne .Lno_uefi_gop
    testq %r15,%r15
    jz .Lno_uefi_gop
    movq %r15,%rsi
    leaq fr_gop_descriptor(%rip),%rdi
    movl $4,%ecx
    rep movsq
.Lno_uefi_gop:
    movabs $0x80000,%rsp
    /* init COM1 115200/8N1 */
    movw $0x3fb,%dx
    movb $0x80,%al
    outb %al,%dx
    movw $0x3f8,%dx
    movb $1,%al
    outb %al,%dx
    movw $0x3f9,%dx
    xor %eax,%eax
    outb %al,%dx
    movw $0x3fb,%dx
    movb $3,%al
    outb %al,%dx
    movw $0x3fa,%dx
    movb $0xc7,%al
    outb %al,%dx
    movabs $ds_stack,%rax
    movabs $ds_ptr,%rdx
    movq %rax,(%rdx)
    leaq franc_dict_initial(%rip),%rax
    movq (%rax),%rax
    movq %rax,fr_dict_head_ptr(%rip)
    /* Register the kernel scheduler in the mutable native JIT dictionary. */
    movq %rax,fr_task_dict_run(%rip)
    leaq fr_task_dict_top(%rip),%rax
    movq %rax,fr_dict_head_ptr(%rip)
    call franc_entry
.hang:
    cli
    hlt
    jmp .hang

.section .text,"ax"
/* Print AL to serial. Bounded poll, so a broken UART cannot hang boot. */
.global fr_putc
fr_putc:
    push %rax
    push %rcx
    push %rdx
    movw $0x3fd,%dx
    movl $100000,%ecx
.waittx:
    inb %dx,%al
    testb $0x20,%al
    jnz .sendtx
    loop .waittx
    jmp .txdone
.sendtx:
    movw $0x3f8,%dx
    movb 16(%rsp),%al
    outb %al,%dx
.txdone:
    movb 16(%rsp),%al
    call fr_gop_putchar
    pop %rdx
    pop %rcx
    pop %rax
    ret

/* Signed numerator rdi, denominator rsi; normalize using integer GCD. */
.global fr_push
fr_push:
    testq %rsi,%rsi
    jnz .finite
    testq %rdi,%rdi
    jz .write
    movq $1,%rdi
    jmp .write
.finite:
    /* Integer fast path: canonical denominator 1 needs no Euclidean GCD.
     * Avoids signed division on each literal and integer result.
     */
    cmpq $1,%rsi
    je .write
    testq %rdi,%rdi
    jnz .signfix
    movq $1,%rsi
    jmp .write
.signfix:
    testq %rsi,%rsi
    jns .gcd
    negq %rsi
    negq %rdi
.gcd:
    movq %rdi,%r8
    movq %rsi,%r9
    movq %r8,%rax
    testq %rax,%rax
    jns .gloop
    negq %rax
.gloop:
    movq %r9,%rcx
.gstep:
    testq %rcx,%rcx
    jz .gdone
    xorq %rdx,%rdx
    divq %rcx
    movq %rcx,%rax
    movq %rdx,%rcx
    jmp .gstep
.gdone:
    movq %rax,%rcx
    movq %r8,%rax
    cqto
    idivq %rcx
    movq %rax,%rdi
    movq %r9,%rax
    cqto
    idivq %rcx
    movq %rax,%rsi
.write:
    movq ds_ptr(%rip),%rax
    /* Check each task's dedicated 16 KiB rational stack before writing. */
    cmpq $2,fr_preempt_mode(%rip)
    jne .Ltask_push_ok
    movq fr_preempt_current(%rip),%rcx
    testq %rcx,%rcx
    jz .Ltask_push_ok
    cmpq $2,%rcx
    ja fr_task_abort_current
    decq %rcx
    shlq $14,%rcx
    leaq fr_preempt_data_stacks(%rip),%r8
    addq %rcx,%r8
    cmpq %r8,%rax
    jb fr_task_abort_current
    addq $16368,%r8
    cmpq %r8,%rax
    ja fr_task_abort_current
.Ltask_push_ok:
    movq %rdi,(%rax)
    movq %rsi,8(%rax)
    addq $16,%rax
    movq %rax,ds_ptr(%rip)
    ret

/* Pop -> rax=num, rdx=den. Underflow returns bottom. */
.global fr_pop
fr_pop:
    movq ds_ptr(%rip),%rcx
    leaq ds_stack(%rip),%r8
    cmpq $2,fr_preempt_mode(%rip)
    jne .Ltask_pop_floor
    movq fr_preempt_current(%rip),%r9
    testq %r9,%r9
    jz .Ltask_pop_floor
    cmpq $2,%r9
    ja fr_task_abort_current
    decq %r9
    shlq $14,%r9
    leaq fr_preempt_data_stacks(%rip),%r8
    addq %r9,%r8
    cmpq %r8,%rcx
    jbe fr_task_abort_current
.Ltask_pop_floor:
    cmpq %r8,%rcx
    jbe .underflow
    subq $16,%rcx
    movq %rcx,ds_ptr(%rip)
    movq (%rcx),%rax
    movq 8(%rcx),%rdx
    ret
.underflow:
    xorl %eax,%eax
    xorl %edx,%edx
    ret

.global fr_dup
fr_dup:
    movq ds_ptr(%rip),%rax
    movq -16(%rax),%rdi
    movq -8(%rax),%rsi
    jmp fr_push
.global fr_drop
fr_drop:
    subq $16,ds_ptr(%rip)
    ret
.global fr_swap
fr_swap:
    movq ds_ptr(%rip),%rax
    movq -16(%rax),%rcx
    movq -32(%rax),%rdx
    movq %rcx,-32(%rax)
    movq %rdx,-16(%rax)
    movq -8(%rax),%rcx
    movq -24(%rax),%rdx
    movq %rcx,-24(%rax)
    movq %rdx,-8(%rax)
    ret
.global fr_over
fr_over:
    movq ds_ptr(%rip),%rax
    movq -32(%rax),%rdi
    movq -24(%rax),%rsi
    jmp fr_push
.global fr_depth
fr_depth:
    movq ds_ptr(%rip),%rdi
    leaq ds_stack(%rip),%rax
    subq %rax,%rdi
    sarq $4,%rdi
    movq $1,%rsi
    jmp fr_push

/* Arithmetic. The 64-bit path serves finite operands whose products fit.
 * Exceptional operands and overflow go to fr_rat_exact, which decides the
 * result exactly, so overflow of an intermediate never loses a result that
 * fits. tests/arith/vectors.txt is the rule for every case.
 */
.macro ARITH name,operation
.global \name
\name:
    call fr_pop
    movq %rax,%r10
    movq %rdx,%r11
    call fr_pop
    movq %rax,%r8
    movq %rdx,%r9
    testq %r9,%r9
    jz .Lexact\@
    testq %r11,%r11
    jz .Lexact\@
    .ifc \operation,add
      imulq %r11,%rax
      jo .Lexact\@
      movq %rax,%rdi
      movq %r9,%rax
      imulq %r10,%rax
      jo .Lexact\@
      addq %rax,%rdi
      jo .Lexact\@
      movq %r9,%rsi
      imulq %r11,%rsi
      jo .Lexact\@
    .endif
    .ifc \operation,sub
      imulq %r11,%rax
      jo .Lexact\@
      movq %rax,%rdi
      movq %r9,%rax
      imulq %r10,%rax
      jo .Lexact\@
      subq %rax,%rdi
      jo .Lexact\@
      movq %r9,%rsi
      imulq %r11,%rsi
      jo .Lexact\@
    .endif
    .ifc \operation,mul
      imulq %r10,%rax
      jo .Lexact\@
      movq %rax,%rdi
      movq %r9,%rsi
      imulq %r11,%rsi
      jo .Lexact\@
    .endif
    .ifc \operation,div
      imulq %r11,%rax
      jo .Lexact\@
      movq %rax,%rdi
      movq %r9,%rsi
      imulq %r10,%rsi
      jo .Lexact\@
      /* A zero or negative denominator needs the sign and range rules. */
      testq %rsi,%rsi
      jle .Lexact\@
    .endif
    jmp fr_push
.Lexact\@:
    .ifc \operation,add
      xorl %ecx,%ecx
    .endif
    .ifc \operation,sub
      movl $1,%ecx
    .endif
    .ifc \operation,mul
      movl $2,%ecx
    .endif
    .ifc \operation,div
      movl $3,%ecx
    .endif
    jmp fr_rat_exact
.endm

/* Exact result of (r8/r9) op (r10/r11), op in ecx: 0 add, 1 sub, 2 mul, 3 div.
 * Forms the pair formulas in 128 bits, reduces, then range-checks. State stays
 * in registers and on this stack because preemptive tasks share this routine.
 * N is r13:r12 and D is r15:r14, each hi:lo.
 */
fr_rat_exact:
    pushq %rbx
    pushq %rbp
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    cmpq $2,%rcx
    je .Lexact_mul
    ja .Lexact_div
    movq %r8,%rax
    imulq %r11
    movq %rax,%r12
    movq %rdx,%r13
    movq %r10,%rax
    imulq %r9
    testq %rcx,%rcx
    jnz .Lexact_sub
    addq %rax,%r12
    adcq %rdx,%r13
    jmp .Lexact_den
.Lexact_sub:
    subq %rax,%r12
    sbbq %rdx,%r13
    jmp .Lexact_den
.Lexact_mul:
    movq %r8,%rax
    imulq %r10
    movq %rax,%r12
    movq %rdx,%r13
.Lexact_den:
    movq %r9,%rax
    imulq %r11
    movq %rax,%r14
    movq %rdx,%r15
    jmp .Lexact_canon
.Lexact_div:
    movq %r8,%rax
    imulq %r11
    movq %rax,%r12
    movq %rdx,%r13
    movq %r9,%rax
    imulq %r10
    movq %rax,%r14
    movq %rdx,%r15
.Lexact_canon:
    movq %r14,%rax
    orq %r15,%rax
    jnz .Lexact_finite_den
    /* Zero denominator: nonzero numerator is infinity, zero is bottom. */
    movq %r12,%rax
    orq %r13,%rax
    jz .Lexact_bottom
    movl $1,%edi
    xorl %esi,%esi
    jmp .Lexact_done
.Lexact_finite_den:
    movq %r12,%rax
    orq %r13,%rax
    jnz .Lexact_nonzero
    xorl %edi,%edi
    movl $1,%esi
    jmp .Lexact_done
.Lexact_nonzero:
    movq %r13,%rbx
    xorq %r15,%rbx             /* sign bit set: result is negative */
    testq %r13,%r13
    jns .Lexact_n_abs
    negq %r12
    adcq $0,%r13
    negq %r13
.Lexact_n_abs:
    testq %r15,%r15
    jns .Lexact_d_abs
    negq %r14
    adcq $0,%r15
    negq %r15
.Lexact_d_abs:
    /* Binary GCD of u=r9:r8 and v=r11:r10; rbp counts shared factors of 2. */
    movq %r12,%r8
    movq %r13,%r9
    movq %r14,%r10
    movq %r15,%r11
    xorl %ebp,%ebp
.Lexact_twos:
    movq %r8,%rax
    orq %r10,%rax
    testb $1,%al
    jnz .Lexact_u_odd
    shrdq $1,%r9,%r8
    shrq $1,%r9
    shrdq $1,%r11,%r10
    shrq $1,%r11
    incq %rbp
    jmp .Lexact_twos
.Lexact_u_odd:
    testb $1,%r8b
    jnz .Lexact_v_odd
    shrdq $1,%r9,%r8
    shrq $1,%r9
    jmp .Lexact_u_odd
.Lexact_v_odd:
    testb $1,%r10b
    jnz .Lexact_compare
    shrdq $1,%r11,%r10
    shrq $1,%r11
    jmp .Lexact_v_odd
.Lexact_compare:
    movq %r10,%rax
    movq %r11,%rdx
    subq %r8,%rax
    sbbq %r9,%rdx
    jnc .Lexact_ordered
    xchgq %r8,%r10
    xchgq %r9,%r11
    jmp .Lexact_compare
.Lexact_ordered:
    movq %rax,%r10
    movq %rdx,%r11
    orq %rdx,%rax
    jnz .Lexact_v_odd
.Lexact_scale:
    testq %rbp,%rbp
    jz .Lexact_reduce
    shldq $1,%r8,%r9
    shlq $1,%r8
    decq %rbp
    jmp .Lexact_scale
.Lexact_reduce:
    call fr_u128_quotient
    xchgq %r12,%r14
    xchgq %r13,%r15
    call fr_u128_quotient
    xchgq %r12,%r14
    xchgq %r13,%r15
    /* The reduced pair must fit: den <= 2^63-1, num in [-2^63, 2^63-1]. */
    testq %r15,%r15
    jnz .Lexact_bottom
    testq %r14,%r14
    js .Lexact_bottom
    testq %r13,%r13
    jnz .Lexact_bottom
    movq %r14,%rsi
    movq %r12,%rdi
    testq %rbx,%rbx
    js .Lexact_negative
    testq %rdi,%rdi
    js .Lexact_bottom
    jmp .Lexact_done
.Lexact_negative:
    movabsq $0x8000000000000000,%rax
    cmpq %rax,%rdi
    ja .Lexact_bottom
    negq %rdi
    jmp .Lexact_done
.Lexact_bottom:
    xorl %edi,%edi
    xorl %esi,%esi
.Lexact_done:
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbp
    popq %rbx
    jmp fr_push

/* r13:r12 /= r9:r8 by shift and subtract. Clobbers rax, rcx, rdx, rdi, rsi. */
fr_u128_quotient:
    xorl %edi,%edi
    xorl %esi,%esi
    movl $128,%ecx
.Lu128_step:
    shlq $1,%r12
    rclq $1,%r13
    rclq $1,%rdi
    rclq $1,%rsi
    movq %rdi,%rax
    movq %rsi,%rdx
    subq %r8,%rax
    sbbq %r9,%rdx
    jc .Lu128_next
    movq %rax,%rdi
    movq %rdx,%rsi
    orq $1,%r12
.Lu128_next:
    decl %ecx
    jnz .Lu128_step
    ret

ARITH fr_add,add
ARITH fr_sub,sub
ARITH fr_mul,mul
ARITH fr_div,div

.global fr_neg
fr_neg:
    call fr_pop
    negq %rax
    jo .Lunary_bottom
    movq %rax,%rdi
    movq %rdx,%rsi
    jmp fr_push
.Lunary_bottom:
    xorl %edi,%edi
    xorl %esi,%esi
    jmp fr_push
.global fr_abs
fr_abs:
    call fr_pop
    testq %rax,%rax
    jns .positive
    negq %rax
    jo .Lunary_bottom
.positive:
    movq %rax,%rdi
    movq %rdx,%rsi
    jmp fr_push
.global fr_floor
fr_floor:
    call fr_pop
    testq %rdx,%rdx
    jz .floorother
    movq %rdx,%rcx
    cqto
    idivq %rcx
    testq %rdx,%rdx
    jns .floornormal
    decq %rax
.floornormal:
    movq %rax,%rdi
    movq $1,%rsi
    jmp fr_push
.floorother:
    movq %rax,%rdi
    xorq %rsi,%rsi
    jmp fr_push

/* consume one Rat and return sign in rax: -1, 0, +1. */
.global fr_condition
fr_condition:
    call fr_pop
    testq %rdx,%rdx
    jz .condbottom
    testq %rax,%rax
    jz .condzero
    js .condneg
    movq $1,%rax
    ret
.condneg: movq $-1,%rax
    ret
.condzero: xorl %eax,%eax
    ret
.condbottom: xorl %eax,%eax
    ret

/* print unsigned integer in rdi; uses scratch digits */
fr_print_u:
    pushq %rbx
    movq %rdi,%rax
    movq $10,%rbx
    leaq printbuf+63(%rip),%r9
    movb $0,(%r9)
    testq %rax,%rax
    jnz .digits
    decq %r9
    movb $'0',(%r9)
    jmp .write_num
.digits:
    xorq %rdx,%rdx
    divq %rbx
    addb $'0',%dl
    decq %r9
    movb %dl,(%r9)
    testq %rax,%rax
    jnz .digits
.write_num:
    movzbl (%r9),%eax
    testb %al,%al
    jz .printed
    call fr_putc
    incq %r9
    jmp .write_num
.printed:
    popq %rbx
    ret
fr_print_s:
    testq %rdi,%rdi
    jns fr_print_u
    pushq %rdi
    movb $'-',%al
    call fr_putc
    popq %rdi
    negq %rdi
    jmp fr_print_u

.global fr_dot
fr_dot:
    call fr_pop
    pushq %rdx
    movq %rax,%rdi
    movq %rax,%r8
    movq %rdx,%r9
    testq %rdx,%rdx
    jnz .ratfinite
    testq %rax,%rax
    jz .ratnan
    leaq infmsg(%rip),%rdi
    jmp .ratstring
.ratnan:
    leaq nanmsg(%rip),%rdi
.ratstring:
    call fr_write_z
    jmp .ratdone
.ratfinite:
    call fr_print_s
    popq %rdx
    pushq %rdx
    cmpq $1,%rdx
    je .ratdone
    movb $'/',%al
    call fr_putc
    movq (%rsp),%rdi
    call fr_print_u
.ratdone:
    movb $10,%al
    call fr_putc
    popq %rdx
    ret
.global fr_cr
fr_cr:
    movb $10,%al
    jmp fr_putc
.global fr_emit
fr_emit:
    call fr_pop
    jmp fr_putc
.global fr_type
fr_type:
    call fr_pop
    movq %rax,%rdi
    jmp fr_write_z
fr_write_z:
    pushq %rbx
    movq %rdi,%rbx
.nextchar:
    movb (%rbx),%al
    testb %al,%al
    jz .endchar
    call fr_putc
    incq %rbx
    jmp .nextchar
.endchar:
    popq %rbx
    ret

.global fr_reg_get
fr_reg_get:
    movq (%rdi),%rax
    movq 8(%rdi),%rsi
    movq %rax,%rdi
    jmp fr_push
.global fr_reg_set
fr_reg_set:
    pushq %rdi
    call fr_pop
    popq %rcx
    movq %rax,(%rcx)
    movq %rdx,8(%rcx)
    ret

.global fr_pixel
fr_pixel:
    call fr_pop
    movq %rax,%r11
    call fr_pop
    movq %rax,%r10
    call fr_pop
    testq %rax,%rax
    js .pixelend
    cmpq $320,%rax
    jae .pixelend
    testq %r10,%r10
    js .pixelend
    cmpq $200,%r10
    jae .pixelend
    imulq $320,%r10,%r10
    addq %rax,%r10
    movb %r11b,0xa0000(%r10)
.pixelend:
    ret
.global fr_clear
fr_clear:
    call fr_pop
    movb %al,%dl
    movq $0xa0000,%rdi
    movl $64000,%ecx
    movb %dl,%al
    rep stosb
    ret

.global fr_bfetch
fr_bfetch:
    call fr_pop
    movzbq (%rax),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_bstore
fr_bstore:
    call fr_pop
    movq %rax,%r10
    call fr_pop
    movb %r10b,(%rax)
    call fr_gop_on_vga_write
    ret
.global fr_inb
fr_inb:
    call fr_pop
    movw %ax,%dx
    xorq %rax,%rax
    inb %dx,%al
    movq %rax,%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_outb
fr_outb:
    call fr_pop
    movq %rax,%r10
    call fr_pop
    movw %ax,%dx
    movb %r10b,%al
    outb %al,%dx
    ret
.global fr_keyq
fr_keyq:
    movw $0x3fd,%dx
    inb %dx,%al
    andq $1,%rax
    movq %rax,%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_key
fr_key:
    movw $0x3fd,%dx
.waitkey:
    inb %dx,%al
    testb $1,%al
    jz .waitkey
    movw $0x3f8,%dx
    inb %dx,%al
    movzbq %al,%rdi
    movq $1,%rsi
    jmp fr_push

.section .rodata
infmsg: .asciz "inf"
nanmsg: .asciz "NaN"
.section .bss
.balign 16
.global ds_stack
 ds_stack: .skip 16384
.global ds_ptr
 ds_ptr: .quad 0
printbuf: .skip 64
.section .note.GNU-stack,"",@progbits

/* Raw PIO bridge for the existing Franc-written ATA sector driver. */
.section .text,"ax"
.global fr_band
fr_band:
    call fr_pop
    movq %rax,%r10
    call fr_pop
    andq %r10,%rax
    movq %rax,%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_inw
fr_inw:
    call fr_pop
    movw %ax,%dx
    xorq %rax,%rax
    inw %dx,%ax
    movq %rax,%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_outw
fr_outw:
    call fr_pop
    movq %rax,%r10
    call fr_pop
    movw %ax,%dx
    movw %r10w,%ax
    outw %ax,%dx
    ret
.global fr_sector_buf
fr_sector_buf:
    leaq sector_data(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_sector_bfetch
fr_sector_bfetch:
    call fr_pop
    cmpq $512,%rax
    jae .bad_sector_read
    movzbq sector_data(%rax),%rdi
    movq $1,%rsi
    jmp fr_push
.bad_sector_read:
    xor %edi,%edi
    movq $1,%rsi
    jmp fr_push
.global fr_sector_bstore
fr_sector_bstore:
    call fr_pop
    movq %rax,%r10
    call fr_pop
    cmpq $512,%rax
    jae .bad_sector_write
    movb %r10b,sector_data(%rax)
.bad_sector_write:
    ret
.section .bss
.balign 16
sector_data: .skip 512
.section .note.GNU-stack,"",@progbits

.section .text,"ax"
.global fr_mod
fr_mod:
    /* Integers only; the result takes the sign of the divisor. */
    call fr_pop
    movq %rax,%r10
    movq %rdx,%r11
    call fr_pop
    cmpq $1,%rdx
    jne .modbad
    cmpq $1,%r11
    jne .modbad
    testq %r10,%r10
    jz .modbad
    xorl %edi,%edi
    /* idivq faults on INT64_MIN / -1, and any value mod -1 is zero. */
    cmpq $-1,%r10
    je .modpush
    movq %r10,%rcx
    cqto
    idivq %rcx
    movq %rdx,%rdi
    testq %rdi,%rdi
    jz .modpush
    movq %rdi,%rax
    xorq %r10,%rax
    jns .modpush
    addq %r10,%rdi
.modpush:
    movq $1,%rsi
    jmp fr_push
.modbad:
    xor %edi,%edi
    xor %esi,%esi
    jmp fr_push
.global fr_source_buffer
fr_source_buffer:
    leaq source_data(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_source_bstore
fr_source_bstore:
    call fr_pop
    movq %rax,%r10
    call fr_pop
    cmpq $2048,%rax
    ja .badsource
    movb %r10b,source_data(%rax)
.badsource:
    ret
.section .bss
.balign 16
source_data: .skip 2050
.section .note.GNU-stack,"",@progbits

/* Franc framebuffer glyphs use the linked font table as data. */
.section .text,"ax"
.global fr_font_base
fr_font_base:
    leaq franc_font8x8(%rip), %rdi
    movq $1, %rsi
    jmp fr_push
.section .note.GNU-stack,"",@progbits


/* Franc Stage 2 compiler bridge: no C objects, no libc. AOT functions and
 * primitives form the initial dictionary, with 512 bounded JIT definitions.
 * JIT code lives at mapped RAM 0x400000+, not in the disk image.
 */
.section .text,"ax"
.global fr_dict_head
fr_dict_head:
    movq fr_dict_head_ptr(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.macro DICT_FIELD name,offset
.global \name
\name:
    call fr_pop
    testq %rax,%rax
    jz .Ldf_null\@
    movq \offset(%rax),%rdi
    jmp .Ldf_push\@
.Ldf_null\@:
    xorq %rdi,%rdi
.Ldf_push\@:
    movq $1,%rsi
    jmp fr_push
.endm
DICT_FIELD fr_dict_next,0
DICT_FIELD fr_dict_name,8
DICT_FIELD fr_dict_code,16

.macro PUSH_ADDRESS name,symbol
.global \name
\name:
    leaq \symbol(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.endm
PUSH_ADDRESS fr_s2_token_buffer,s2_token_buffer
PUSH_ADDRESS fr_s2_control_buffer,s2_control_buffer
PUSH_ADDRESS fr_s2_line_buffer,s2_line_buffer
PUSH_ADDRESS fr_s2_lit_addr,fr_push
PUSH_ADDRESS fr_s2_sign_addr,fr_condition
PUSH_ADDRESS fr_s2_string_addr,fr_push
PUSH_ADDRESS fr_s2_self_source,franc_stage2_source
PUSH_ADDRESS fr_repl_buffer,repl_input
.global fr_aot_bundle_area
fr_aot_bundle_area:
    movq $0x200000,%rdi
    movq $1,%rsi
    jmp fr_push

.global fr_s2_code
fr_s2_code:
    movq s2_code_next(%rip),%rdi
    leaq 65536(%rdi),%rax
    cmpq $0x02000000,%rax
    ja .Lcode_exhausted
    movq %rax,s2_code_next(%rip)
    movq $1,%rsi
    jmp fr_push
.Lcode_exhausted:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

.global fr_s2_run
fr_s2_run:
    call fr_pop
    cmpq $0x400000,%rax
    jb .Lrun_end
    cmpq s2_code_next(%rip),%rax
    jae .Lrun_end
    call *%rax
.Lrun_end:
    ret

.global fr_s2_define
fr_s2_define:
    pushq %r12
    pushq %r13
    call fr_pop
    movq %rax,%r12
    call fr_pop
    movq %rax,%r13
    cmpq $0x400000,%r12
    jb .Ldef_done
    cmpq s2_code_next(%rip),%r12
    jae .Ldef_done
    testq %r13,%r13
    jz .Ldef_done
    movq s2_dict_used(%rip),%r9
    cmpq $512,%r9
    jae .Ldef_done
    leaq s2_dict_names(%rip),%r10
    movq %r9,%r11
    shlq $6,%r11
    addq %r11,%r10
    xorq %rcx,%rcx
.Ldef_copy:
    cmpq $63,%rcx
    jae .Ldef_done
    movb (%r13,%rcx),%al
    movb %al,(%r10,%rcx)
    incq %rcx
    testb %al,%al
    jnz .Ldef_copy
    leaq s2_dict_nodes(%rip),%r11
    leaq (%r9,%r9,2),%r9
    shlq $3,%r9
    addq %r9,%r11
    movq fr_dict_head_ptr(%rip),%rax
    movq %rax,(%r11)
    movq %r10,8(%r11)
    movq %r12,16(%r11)
    movq %r11,fr_dict_head_ptr(%rip)
    incq s2_dict_used(%rip)
.Ldef_done:
    popq %r13
    popq %r12
    ret

.global fr_s2_intern
fr_s2_intern:
    call fr_pop
    testq %rax,%rax
    jz .Lintern_fail
    movq %rax,%r8
    movq s2_intern_used(%rip),%r9
    leaq s2_intern_data(%rip),%r10
    addq %r9,%r10
    xorq %rcx,%rcx
.Lintern_copy:
    cmpq $255,%rcx
    jae .Lintern_fail
    movq %r9,%r11
    addq %rcx,%r11
    cmpq $32768,%r11
    jae .Lintern_fail
    movb (%r8,%rcx),%al
    movb %al,(%r10,%rcx)
    incq %rcx
    testb %al,%al
    jnz .Lintern_copy
    addq %rcx,s2_intern_used(%rip)
    movq %r10,%rdi
    movq $1,%rsi
    jmp fr_push
.Lintern_fail:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

.section .data
.balign 8
s2_code_next: .quad 0x400000
.section .bss
.balign 16
fr_dict_head_ptr: .skip 8
s2_dict_used: .skip 8
s2_intern_used: .skip 8
s2_token_buffer: .skip 1024
s2_control_buffer: .skip 1024
s2_line_buffer: .skip 16384
s2_dict_nodes: .skip 12288 /* 512 entries x 24-byte node */
s2_dict_names: .skip 32768 /* 512 entries x 64-byte string */
s2_intern_data: .skip 32768
repl_input: .skip 256
.section .note.GNU-stack,"",@progbits

/* PCI configuration mechanism #1 requires 32-bit port operations. */
.section .text,"ax"
.global fr_inl
fr_inl:
    call fr_pop
    movw %ax,%dx
    xorl %eax,%eax
    inl %dx,%eax
    movq %rax,%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_outl
fr_outl:
    call fr_pop
    movq %rax,%r10
    call fr_pop
    movw %ax,%dx
    movl %r10d,%eax
    outl %eax,%dx
    ret
.section .note.GNU-stack,"",@progbits

/* Non-reclaiming 4 MiB 16-byte-aligned Franc kernel heap at 0x05400000.
 * Caller is responsible for object lifetime and zero initialization.
 * This range is outside JIT (0x00400000..0x02000000), editor (0x06b...),
 * bignums (0x060...), and QEMU UEFI page tables (< 0x05000000).
 */
.section .data
.balign 8
fr_heap_next: .quad 0x05400000
.section .text,"ax"
.global fr_heap_alloc
fr_heap_alloc:
    call fr_pop
    cmpq $1,%rdx
    jne .Lalloc_fail
    testq %rax,%rax
    jle .Lalloc_fail
    cmpq $0x400000,%rax
    ja .Lalloc_fail
    addq $15,%rax
    andq $-16,%rax
    movq fr_heap_next(%rip),%rdi
    leaq (%rdi,%rax),%r8
    cmpq $0x05800000,%r8
    ja .Lalloc_fail
    movq %r8,fr_heap_next(%rip)
    movq $1,%rsi
    jmp fr_push
.Lalloc_fail:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

.global fr_heap_available
fr_heap_available:
    movq $0x05800000,%rdi
    subq fr_heap_next(%rip),%rdi
    movq $1,%rsi
    jmp fr_push

/* Signed integer shifts. Nonintegral operands or invalid counts -> bottom.
 * Left shift rejects overflow; right shift preserves sign.
 */
.global fr_lshift
fr_lshift:
    call fr_pop
    cmpq $1,%rdx
    jne .Lshl_bad
    cmpq $63,%rax
    ja .Lshl_bad
    movq %rax,%r10
    call fr_pop
    cmpq $1,%rdx
    jne .Lshl_bad
    movq %r10,%rcx
    movq %rax,%rdi
    shlq %cl,%rdi
    movq %rdi,%r8
    sarq %cl,%r8
    cmpq %rax,%r8
    jne .Lshl_bad
    movq $1,%rsi
    jmp fr_push
.Lshl_bad:
    xorq %rdi,%rdi
    xorq %rsi,%rsi
    jmp fr_push

.global fr_rshift
fr_rshift:
    call fr_pop
    cmpq $1,%rdx
    jne .Lshr_bad
    cmpq $63,%rax
    ja .Lshr_bad
    movq %rax,%r10
    call fr_pop
    cmpq $1,%rdx
    jne .Lshr_bad
    movq %r10,%rcx
    sarq %cl,%rax
    movq %rax,%rdi
    movq $1,%rsi
    jmp fr_push
.Lshr_bad:
    xorq %rdi,%rdi
    xorq %rsi,%rsi
    jmp fr_push
.section .note.GNU-stack,"",@progbits


/* C-free cooperative fibers with independent CPU *and Franc data* stacks.
 * All JIT code still shares kernel privilege, dictionary and registers.
 * Two slots, 16 KiB CPU stacks + 16 KiB rational data stacks per slot.
 * Switching preserves SysV callee-saved regs; no timer interrupts.
 */
.section .data
.balign 8
fr_fiber_running: .quad -1
fr_fiber_next: .quad 0

.section .bss
.balign 16
fr_fiber_slots: .skip 128
fr_fiber_cpu_stacks: .skip 32768
fr_fiber_data_stacks: .skip 32768
fr_fiber_host_rsp: .skip 8
fr_fiber_host_ds: .skip 8

.section .text,"ax"
/* rdi points to saved rsp, rsi points to destination rsp. */
fr_fiber_switch:
    pushq %rbp
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    movq %rsp,(%rdi)
    movq (%rsi),%rsp
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    popq %rbp
    ret

/* (compiled-code-address -- success). Reject non-JIT or busy address. */
.global fr_fiber_spawn
fr_fiber_spawn:
    call fr_pop
    cmpq $1,%rdx
    jne .Lfib_spawn_bad
    cmpq $0x400000,%rax
    jb .Lfib_spawn_bad
    cmpq s2_code_next(%rip),%rax
    jae .Lfib_spawn_bad
    cmpq $-1,fr_fiber_running(%rip)
    jne .Lfib_spawn_bad
    leaq fr_fiber_slots(%rip),%r8
    movq (%r8),%rcx
    cmpq $1,%rcx
    jne .Lfib_slot0
    addq $64,%r8
    cmpq $1,(%r8)
    je .Lfib_spawn_bad
    movq $1,%rcx
    jmp .Lfib_slot_ready
.Lfib_slot0:
    xorq %rcx,%rcx
.Lfib_slot_ready:
    movq $1,(%r8)
    movq %rax,8(%r8)
    leaq fr_fiber_cpu_stacks(%rip),%r9
    movq %rcx,%r10
    shlq $14,%r10
    addq %r10,%r9
    addq $16384-64,%r9
    movq %r9,16(%r8)
    movq $0,0(%r9)
    movq $0,8(%r9)
    movq $0,16(%r9)
    movq $0,24(%r9)
    movq $0,32(%r9)
    movq $0,40(%r9)
    leaq fr_fiber_entry(%rip),%r11
    movq %r11,48(%r9)
    leaq fr_fiber_data_stacks(%rip),%r9
    addq %r10,%r9
    movq %r9,24(%r8)
    movq $1,%rdi
    movq $1,%rsi
    jmp fr_push
.Lfib_spawn_bad:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

/* (-- did-work), one cooperative dispatch. No scheduling inside a fiber. */
.global fr_fiber_step
fr_fiber_step:
    cmpq $-1,fr_fiber_running(%rip)
    jne .Lfib_step_none
    movq fr_fiber_next(%rip),%r10
    leaq fr_fiber_slots(%rip),%r8
    testq %r10,%r10
    jz .Lfib_step_first
    addq $64,%r8
.Lfib_step_first:
    cmpq $1,(%r8)
    je .Lfib_step_chosen
    xorq $1,%r10
    leaq fr_fiber_slots(%rip),%r8
    testq %r10,%r10
    jz .Lfib_step_other
    addq $64,%r8
.Lfib_step_other:
    cmpq $1,(%r8)
    jne .Lfib_step_none
.Lfib_step_chosen:
    movq %r10,fr_fiber_running(%rip)
    xorq $1,%r10
    movq %r10,fr_fiber_next(%rip)
    movq ds_ptr(%rip),%rax
    movq %rax,fr_fiber_host_ds(%rip)
    movq 24(%r8),%rax
    movq %rax,ds_ptr(%rip)
    leaq fr_fiber_host_rsp(%rip),%rdi
    leaq 16(%r8),%rsi
    call fr_fiber_switch
    movq $1,%rdi
    movq $1,%rsi
    jmp fr_push
.Lfib_step_none:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

/* From a fiber, resume the caller's CPU and Franc stacks. */
.global fr_fiber_yield
fr_fiber_yield:
    movq fr_fiber_running(%rip),%r10
    cmpq $-1,%r10
    je .Lfib_yield_return
    leaq fr_fiber_slots(%rip),%r8
    shlq $6,%r10
    addq %r10,%r8
    movq ds_ptr(%rip),%rax
    movq %rax,24(%r8)
    movq fr_fiber_host_ds(%rip),%rax
    movq %rax,ds_ptr(%rip)
    movq $-1,fr_fiber_running(%rip)
    leaq 16(%r8),%rdi
    leaq fr_fiber_host_rsp(%rip),%rsi
    call fr_fiber_switch
.Lfib_yield_return:
    ret

/* Synthetic first entry. No task can return into invalid caller memory. */
fr_fiber_entry:
    subq $8,%rsp
    movq fr_fiber_running(%rip),%rax
    shlq $6,%rax
    leaq fr_fiber_slots(%rip),%r8
    addq %rax,%r8
    movq 8(%r8),%rax
    call *%rax
    addq $8,%rsp
    movq fr_fiber_running(%rip),%r10
    shlq $6,%r10
    leaq fr_fiber_slots(%rip),%r8
    addq %r10,%r8
    movq $2,(%r8)
    movq ds_ptr(%rip),%rax
    movq %rax,24(%r8)
    movq fr_fiber_host_ds(%rip),%rax
    movq %rax,ds_ptr(%rip)
    movq $-1,fr_fiber_running(%rip)
    leaq 16(%r8),%rdi
    leaq fr_fiber_host_rsp(%rip),%rsi
    call fr_fiber_switch
    ud2

.global fr_fiber_active
fr_fiber_active:
    xorq %rdi,%rdi
    leaq fr_fiber_slots(%rip),%rax
    cmpq $1,(%rax)
    jne .Lfib_active_1
    incq %rdi
.Lfib_active_1:
    cmpq $1,64(%rax)
    jne .Lfib_active_end
    incq %rdi
.Lfib_active_end:
    movq $1,%rsi
    jmp fr_push
.section .note.GNU-stack,"",@progbits


/* Bounded physical 4KiB page allocator, 8MiB arena at 0x07000000.
 * BIOS E820 authorization is required before allocation. UEFI without
 * handoff fails closed. Tracks 2048 pages and zeroes both on allocate and
 * release. Legacy page-free rejects frames held by an active owner lease.
 * Identity mapping is NOT process isolation.
 */
.section .bss
.balign 8
fr_page_bitmap: .skip 256
fr_pages_used: .skip 8
.section .text,"ax"
.global fr_page_alloc
fr_page_alloc:
    /* No physical page is allocated unless firmware authorizes the
     * entire fixed arena. In particular, a UEFI boot with no imported
     * firmware memory map cannot borrow assumed RAM.
     */
    call fr_e820_arena_usable
    testl %eax,%eax
    jz .Lpage_empty
    leaq fr_page_bitmap(%rip),%r8
    xorq %rcx,%rcx
.Lpage_scan:
    cmpq $2048,%rcx
    jae .Lpage_empty
    btq %rcx,(%r8)
    jc .Lpage_taken
    btsq %rcx,(%r8)
    incq fr_pages_used(%rip)
    movq %rcx,%rdi
    shlq $12,%rdi
    addq $0x07000000,%rdi
    pushq %rdi
    movl $512,%ecx
    xorq %rax,%rax
    cld
    rep stosq
    popq %rdi
    movq $1,%rsi
    jmp fr_push
.Lpage_taken:
    incq %rcx
    jmp .Lpage_scan
.Lpage_empty:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

.global fr_page_free
fr_page_free:
    call fr_pop
    cmpq $1,%rdx
    jne .Lpage_free_no
    cmpq $0x07000000,%rax
    jb .Lpage_free_no
    cmpq $0x07800000,%rax
    jae .Lpage_free_no
    testq $4095,%rax
    jne .Lpage_free_no
    subq $0x07000000,%rax
    shrq $12,%rax
    /* Do not allow the legacy free word to bypass an owner's lease. */
    movq %rax,%r10
    shlq $4,%r10
    leaq fr_lease_page_tags(%rip),%r9
    cmpq $0,(%r9,%r10)
    jne .Lpage_free_no
    leaq fr_page_bitmap(%rip),%r8
    btrq %rax,(%r8)
    jnc .Lpage_free_no
    /* Scrub released contents before this frame can be reused. */
    movq %rax,%rdi
    shlq $12,%rdi
    addq $0x07000000,%rdi
    movl $512,%ecx
    xorl %eax,%eax
    cld
    rep stosq
    decq fr_pages_used(%rip)
    movq $1,%rdi
    movq $1,%rsi
    jmp fr_push
.Lpage_free_no:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

.global fr_page_free_count
fr_page_free_count:
    call fr_e820_arena_usable
    testl %eax,%eax
    jz .Lpage_count_none
    movq $2048,%rdi
    subq fr_pages_used(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.Lpage_count_none:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push
.section .note.GNU-stack,"",@progbits


/* Franctxt semantic SHA-256 primitive. Native Franc parser owns documents;
 * assembly supplies deterministic cryptographic arithmetic, no C/Python.
 * (canonical-document-pointer byte-length -- lowercase-hex-pointer|0)
 */
.section .text,"ax"
.global fr_ft_sha256
fr_ft_sha256:
    pushq %r12
    pushq %r13
    pushq %rbx
    call fr_pop
    movq %rax,%r12
    movq %rdx,%r13
    call fr_pop
    cmpq $1,%r13
    jne .Lft_sha_abi_fail
    cmpq $1,%rdx
    jne .Lft_sha_abi_fail
    cmpq $2047,%r12
    ja .Lft_sha_abi_fail
    testq %rax,%rax
    jz .Lft_sha_abi_fail
    movq %rax,%rdi
    movq %r12,%rsi
    call ft_sha256_canonical
    jmp .Lft_sha_abi_end
.Lft_sha_abi_fail:
    xorq %rax,%rax
.Lft_sha_abi_end:
    popq %rbx
    popq %r13
    popq %r12
    movq %rax,%rdi
    movq $1,%rsi
    jmp fr_push

/* (byte-pointer length -- 64-char lowercase raw SHA256 digest); no domain. */
.global fr_pkg_sha256
fr_pkg_sha256:
    pushq %r12
    pushq %r13
    pushq %rbx
    call fr_pop
    movq %rax,%r12
    movq %rdx,%r13
    call fr_pop
    cmpq $1,%r13
    jne .Lpkg_sha_abi_fail
    cmpq $1,%rdx
    jne .Lpkg_sha_abi_fail
    cmpq $2047,%r12
    ja .Lpkg_sha_abi_fail
    testq %rax,%rax
    jz .Lpkg_sha_abi_fail
    movq %rax,%rdi
    movq %r12,%rsi
    call ft_sha256_raw
    jmp .Lpkg_sha_abi_end
.Lpkg_sha_abi_fail:
    xorq %rax,%rax
.Lpkg_sha_abi_end:
    popq %rbx
    popq %r13
    popq %r12
    movq %rax,%rdi
    movq $1,%rsi
    jmp fr_push


/* SHA-256 compression source is shared with the independent Linux ABI test. */
.include "franctxt/sha256_native.S"


.section .text,"ax"
/* Strictly 32-bit PCI BAR0 memory-mapped device registers.
 * QEMU 82540EM legacy e1000 I/O BAR is inert; PCI MMIO is necessary.
 * Only the 128KiB MMIO window above 128MiB guest RAM is addressable.
 * BIOS boot pages map 256MiB; UEFI already maps low 4GiB.
 */
.global fr_mmio32_fetch
fr_mmio32_fetch:
    call fr_pop
    cmpq $1,%rdx
    jne .Lmmio_read_bad
    cmpq $0x08000000,%rax
    jb .Lmmio_read_bad
    cmpq $0x08020000,%rax
    jae .Lmmio_read_bad
    testq $3,%rax
    jne .Lmmio_read_bad
    movl (%rax),%edi
    movq $1,%rsi
    jmp fr_push
.Lmmio_read_bad:
    xorq %rdi,%rdi
    xorq %rsi,%rsi
    jmp fr_push

.global fr_mmio32_store
fr_mmio32_store:
    call fr_pop
    cmpq $1,%rdx
    jne .Lmmio_write_bad
    movabsq $4294967295,%r8
    cmpq %r8,%rax
    ja .Lmmio_write_bad
    movl %eax,%r10d
    call fr_pop
    cmpq $1,%rdx
    jne .Lmmio_write_bad
    cmpq $0x08000000,%rax
    jb .Lmmio_write_bad
    cmpq $0x08020000,%rax
    jae .Lmmio_write_bad
    testq $3,%rax
    jne .Lmmio_write_bad
    movl %r10d,(%rax)
    mfence
.Lmmio_write_bad:
    ret

/* Native C-free timer and IDT entry points. */
.include "stage4/interrupts.S"
.include "stage4/scheduler.S"
.include "stage4/e820.S"
/* Experimental BIOS-only CPL3 page-table and TSS isolation proof. */
.include "stage4/ring3.S"
/* Trusted-kernel generation-tagged page ownership for Wave 1. */
.include "stage4/page_owners.S"
/* BIOS-only E820-gated independent CPL3 address space validation. */
.include "stage4/process_spaces.S"
/* Wave 2 bounded user-IRQ scheduler is native assembly only. */
.include "stage4/user_scheduler.S"
/* Wave 3: copy only audited Franc-emitted CPL3 byte templates. */
.include "stage4/user_compiled.S"

/* Separate pure-assembly GOP renderer; BIOS VGA remains unchanged. */
.include "stage4/gop_console.S"
