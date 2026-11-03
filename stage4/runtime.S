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
    leaq franc_dict_initial(%rip),%rax
    movq (%rax),%rax
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


/* Franc Stage 2 compiler bridge: no C objects, no libc. AOT functions and
 * primitives form the initial dictionary, with 256 mutable definitions.
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
    cmpq $256,%r9
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
s2_dict_nodes: .skip 6144
s2_dict_names: .skip 16384
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
