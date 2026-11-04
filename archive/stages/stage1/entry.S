.code64
.section .text.entry,"ax"
.global _kstart
.extern kernel_main
.extern __bss_start
.extern __bss_end
_kstart:
    cld
    movabs $__bss_start,%rdi
    movabs $__bss_end,%rcx
    subq %rdi,%rcx
    xorl %eax,%eax
    rep stosb
    movabs $0x80000,%rsp
    call kernel_main
1:  cli
    hlt
    jmp 1b
.section .note.GNU-stack,"",@progbits
