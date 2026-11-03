/* Link bridge for a Franc-produced kernel object. No C and no Python. */
.code64
.section .text
.global franc_entry
.extern franc_aot_entry
franc_entry:
    jmp franc_aot_entry
.section .note.GNU-stack,"",@progbits
