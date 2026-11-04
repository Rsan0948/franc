/* FrancOS UEFI GOP runtime console -- linked into the C-free kernel.
 * Firmware publishes a validated 32-byte handoff at 0x70000.
 */
.section .text,"ax"
.global fr_gop_putchar
fr_gop_putchar:
    pushq %rbx
    pushq %rsi
    pushq %rdi
    pushq %r8
    pushq %r9
    pushq %r10
    pushq %r11
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    cmpl $0x50475246,0x70000
    jne .Lgc_done
    cmpl $1,0x70004
    jne .Lgc_done
    movzbl %al,%ebx
    cmpb $10,%bl
    je .Lgc_newline
    cmpb $13,%bl
    je .Lgc_carriage
    cmpb $8,%bl
    je .Lgc_backspace
    cmpb $32,%bl
    jb .Lgc_done
    cmpb $127,%bl
    jae .Lgc_done
    cmpq $0,fr_gop_initialized(%rip)
    jne .Lgc_canvas_ready
    call .Lgc_init
.Lgc_canvas_ready:
    movl 0x70010,%ecx
    subl $64,%ecx
    shrl $4,%ecx
    cmpl %ecx,fr_gop_column(%rip)
    jb .Lgc_place
    call .Lgc_advance
.Lgc_place:
    movq 0x70008,%r12
    movl 0x70018,%r13d
    movl fr_gop_column(%rip),%r14d
    shll $4,%r14d
    addl $32,%r14d
    movl fr_gop_row(%rip),%r15d
    imull $20,%r15d
    addl $32,%r15d
    leaq franc_font8x8(%rip),%rsi
    leaq (%rsi,%rbx,8),%rsi
    xorl %r8d,%r8d
.Lgc_row:
    cmpl $8,%r8d
    jae .Lgc_rendered
    movzbl (%rsi,%r8,1),%r10d
    xorl %r9d,%r9d
.Lgc_column_pixel:
    cmpl $8,%r9d
    jae .Lgc_nextrow
    movl $0x00232D3B,%r11d
    btl %r9d,%r10d
    jnc .Lgc_color
    movl $0x00EFEFEF,%r11d
.Lgc_color:
    movl %r8d,%eax
    leal (%r15,%rax,2),%eax
    imull %r13d,%eax
    leal (%r14,%r9,2),%edx
    addl %edx,%eax
    leaq (%r12,%rax,4),%rdi
    movl %r11d,(%rdi)
    movl %r11d,4(%rdi)
    leaq (,%r13,4),%rdx
    movl %r11d,(%rdi,%rdx)
    movl %r11d,4(%rdi,%rdx)
    incl %r9d
    jmp .Lgc_column_pixel
.Lgc_nextrow:
    incl %r8d
    jmp .Lgc_row
.Lgc_rendered:
    incl fr_gop_column(%rip)
    jmp .Lgc_done
.Lgc_carriage:
    movl $0,fr_gop_column(%rip)
    jmp .Lgc_done
.Lgc_newline:
    call .Lgc_advance
    jmp .Lgc_done
.Lgc_backspace:
    cmpl $0,fr_gop_column(%rip)
    je .Lgc_done
    decl fr_gop_column(%rip)
    jmp .Lgc_done
.Lgc_advance:
    movl $0,fr_gop_column(%rip)
    incl fr_gop_row(%rip)
    movl 0x70014,%ecx
    subl $64,%ecx
    movl %ecx,%eax
    xorl %edx,%edx
    movl $20,%ecx
    divl %ecx
    cmpl %eax,fr_gop_row(%rip)
    jb .Lgc_advance_done
    movl $0,fr_gop_row(%rip)
.Lgc_advance_done:
    ret
.Lgc_init:
    pushq %rax
    pushq %rcx
    movq 0x70008,%rdi
    movl 0x70018,%eax
    imull 0x70014,%eax
    movl %eax,%ecx
    movl $0x00192331,%eax
    cld
    rep stosl
    movq $1,fr_gop_initialized(%rip)
    popq %rcx
    popq %rax
    ret
.Lgc_done:
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %r11
    popq %r10
    popq %r9
    popq %r8
    popq %rdi
    popq %rsi
    popq %rbx
    ret
.section .bss
.balign 8
fr_gop_initialized: .quad 0
fr_gop_column: .long 0
fr_gop_row: .long 0
.section .text,"ax"
