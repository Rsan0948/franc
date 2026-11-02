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
    cld
    movabs $__bss_start,%rdi
    movabs $__bss_end,%rcx
    subq %rdi,%rcx
    xor %eax,%eax
    rep stosb
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

/* Arithmetic. All intermediate operations are 64-bit; overflows become bottom. */
.macro ARITH name,operation
.global \name
\name:
    call fr_pop
    movq %rax,%r10
    movq %rdx,%r11
    call fr_pop
    testq %rdx,%rdx
    jz .Lbad\@
    testq %r11,%r11
    jz .Lbad\@
    .ifc \operation,add
      imulq %r11,%rax
      jo .Lbad\@
      movq %rax,%rdi
      movq %rdx,%rax
      imulq %r10,%rax
      jo .Lbad\@
      addq %rax,%rdi
      jo .Lbad\@
      imulq %r11,%rdx
      jo .Lbad\@
      movq %rdx,%rsi
    .endif
    .ifc \operation,sub
      imulq %r11,%rax
      jo .Lbad\@
      movq %rax,%rdi
      movq %rdx,%rax
      imulq %r10,%rax
      jo .Lbad\@
      subq %rax,%rdi
      jo .Lbad\@
      imulq %r11,%rdx
      jo .Lbad\@
      movq %rdx,%rsi
    .endif
    .ifc \operation,mul
      imulq %r10,%rax
      jo .Lbad\@
      movq %rax,%rdi
      imulq %r11,%rdx
      jo .Lbad\@
      movq %rdx,%rsi
    .endif
    .ifc \operation,div
      imulq %r11,%rax
      jo .Lbad\@
      movq %rax,%rdi
      imulq %r10,%rdx
      jo .Lbad\@
      movq %rdx,%rsi
    .endif
    jmp fr_push
.Lbad\@:
    xorq %rdi,%rdi
    xorq %rsi,%rsi
    jmp fr_push
.endm
ARITH fr_add,add
ARITH fr_sub,sub
ARITH fr_mul,mul
ARITH fr_div,div

.global fr_neg
fr_neg:
    call fr_pop
    negq %rax
    movq %rax,%rdi
    movq %rdx,%rsi
    jmp fr_push
.global fr_abs
fr_abs:
    call fr_pop
    testq %rax,%rax
    jns .positive
    negq %rax
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
    call fr_pop
    movq %rax,%r10
    call fr_pop
    testq %r10,%r10
    jz .modbad
    movq %r10,%rcx
    cqto
    idivq %rcx
    movq %rdx,%rdi
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
