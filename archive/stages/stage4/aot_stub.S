/* Minimal assembly bridge from the existing x86-64 boot runtime into a
 * Franc-generated relocatable program. No C or Python-produced application. */
.code64
.section .text
.global franc_entry
.extern franc_aot_entry
franc_entry:
    jmp franc_aot_entry
.section .rodata
.global franc_stage2_source
franc_stage2_source:
    .byte 0
.section .data
.balign 8
.global franc_dict_initial
franc_dict_initial:
    .quad 0
.section .note.GNU-stack,"",@progbits
