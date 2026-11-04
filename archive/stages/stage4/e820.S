/* FrancOS BIOS E820 firmware inventory. Does not allocate memory.
 * Loader writes signature 0x30323845/count at 0x4ff0/0x4ff4 and
 * at most 48 24-byte entries at 0x5000. UEFI has a different API
 * and intentionally exposes count zero until its own handoff exists.
 */
.code64
.section .text,"ax"
/* return count or zero on absent/corrupt signature */
fr_e820_count:
    cmpl $0x30323845,0x4ff0
    jne .Le820_none
    movzwq 0x4ff4,%rdi
    cmpq $48,%rdi
    ja .Le820_none
    testq %rdi,%rdi
    jz .Le820_none
    movq $1,%rsi
    jmp fr_push
.Le820_none:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

/* rax = integer index from Franc stack, r8 = entry address on success.
 * carry set when invalid. Only inventory fields may be accessed.
 */
fr_e820_entry:
    cmpq $1,%rdx
    jne .Le820_entry_bad
    testq %rax,%rax
    js .Le820_entry_bad
    cmpq $48,%rax
    jae .Le820_entry_bad
    cmpl $0x30323845,0x4ff0
    jne .Le820_entry_bad
    movzwq 0x4ff4,%rcx
    cmpq $48,%rcx
    ja .Le820_entry_bad
    cmpq %rcx,%rax
    jae .Le820_entry_bad
    imulq $24,%rax,%r8
    addq $0x5000,%r8
    clc
    ret
.Le820_entry_bad:
    stc
    ret
/* (index -- base|0) */
fr_e820_base:
    call fr_pop
    call fr_e820_entry
    jc .Le820_zero
    movq 0(%r8),%rdi
    movq $1,%rsi
    jmp fr_push
/* (index -- length|0) */
fr_e820_length:
    call fr_pop
    call fr_e820_entry
    jc .Le820_zero
    movq 8(%r8),%rdi
    movq $1,%rsi
    jmp fr_push
/* (index -- type|0) */
fr_e820_type:
    call fr_pop
    call fr_e820_entry
    jc .Le820_zero
    movl 16(%r8),%edi
    movq $1,%rsi
    jmp fr_push
.Le820_zero:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

/* Validated 8 MiB physical page arena at [0x07000000,0x07800000).
 * Requires a full trusted BIOS E820 inventory and at least one type-1
 * descriptor covering the entire arena; reject ANY reserved/non-type1
 * descriptor overlapping the arena even if firmware entries overlap.
 * Returns EAX=1/0; caller-saved registers only. Unknown UEFI map fails
 * closed: UEFI GetMemoryMap must be integrated before it can allocate.
 */
fr_e820_arena_usable:
    cmpl $0x30323845,0x4ff0
    jne .Le820_arena_bad
    movzwq 0x4ff4,%rcx
    testq %rcx,%rcx
    jz .Le820_arena_bad
    cmpq $48,%rcx
    ja .Le820_arena_bad
    movq $0x5000,%r8
    xorl %esi,%esi
.Le820_arena_loop:
    movq 0(%r8),%r9
    movq 8(%r8),%r10
    testq %r10,%r10
    jz .Le820_arena_next
    movq %r9,%r11
    addq %r10,%r11
    jc .Le820_arena_bad   /* overflow in firmware-supplied range */
    cmpl $1,16(%r8)
    jne .Le820_arena_reserved
    cmpq $0x07000000,%r9
    ja .Le820_arena_next
    cmpq $0x07800000,%r11
    jb .Le820_arena_next
    movl $1,%esi
    jmp .Le820_arena_next
.Le820_arena_reserved:
    cmpq $0x07800000,%r9
    jae .Le820_arena_next
    cmpq $0x07000000,%r11
    ja .Le820_arena_bad
.Le820_arena_next:
    addq $24,%r8
    decq %rcx
    jnz .Le820_arena_loop
    movl %esi,%eax
    ret
.Le820_arena_bad:
    xorl %eax,%eax
    ret

fr_e820_arena_word:
    call fr_e820_arena_usable
    movl %eax,%edi
    movq $1,%rsi
    jmp fr_push
