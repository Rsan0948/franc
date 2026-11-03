/* FrancOS Wave 1: trusted-kernel page leases (NOT a Ring 3 security boundary).
 * Two bounded owner slots with monotonically increasing generation tokens.
 * Leases tag 4KiB frames allocated from the existing E820-approved arena.
 * An owner cannot free another owner's page via these APIs; stale generations
 * cannot allocate, free or reclaim after a lease has ended. Reclaim scrubs
 * frames before making them available to the bitmap allocator.
 *
 * A lease is only an ownership/lifecycle foundation. Until distinct CR3
 * address spaces and syscalls exist, all privileged Franc code can still
 * access the identity-mapped physical memory. Never expose these words to
 * untrusted CPL3 code as an authorization mechanism.
 */
.section .bss
.balign 16
fr_lease_page_tags: .skip 32768  /* 2048 pairs: owner and generation */
fr_lease_generations: .skip 16   /* generation for owners 1 and 2 */
fr_lease_live: .skip 16          /* active flag for owners 1 and 2 */

.section .text,"ax"
/* Internal: r12=owner [1,2], r13=generation; eax=valid lease. */
fr_lease_check:
    cmpq $1,%r12
    jb .Llease_invalid
    cmpq $2,%r12
    ja .Llease_invalid
    testq %r13,%r13
    jle .Llease_invalid
    movq %r12,%rcx
    decq %rcx
    leaq fr_lease_live(%rip),%r8
    cmpq $1,(%r8,%rcx,8)
    jne .Llease_invalid
    leaq fr_lease_generations(%rip),%r8
    cmpq %r13,(%r8,%rcx,8)
    jne .Llease_invalid
    movl $1,%eax
    ret
.Llease_invalid:
    xorl %eax,%eax
    ret

/* (owner -- generation|0). Only two active owners; no token reuse. */
.global fr_lease_begin
fr_lease_begin:
    call fr_pop
    cmpq $1,%rdx
    jne .Llease_begin_bad
    cmpq $1,%rax
    jb .Llease_begin_bad
    cmpq $2,%rax
    ja .Llease_begin_bad
    decq %rax
    leaq fr_lease_live(%rip),%r8
    cmpq $0,(%r8,%rax,8)
    jne .Llease_begin_bad
    leaq fr_lease_generations(%rip),%r9
    movq (%r9,%rax,8),%rdi
    cmpq $0x7fffffff,%rdi
    jae .Llease_begin_bad
    incq %rdi
    movq %rdi,(%r9,%rax,8)
    movq $1,(%r8,%rax,8)
    movq $1,%rsi
    jmp fr_push
.Llease_begin_bad:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

/* (owner generation -- physical-page|0). Only allocates on a live lease. */
.global fr_lease_alloc
fr_lease_alloc:
    pushq %r12
    pushq %r13
    call fr_pop
    movq %rax,%r13
    cmpq $1,%rdx
    jne .Llease_alloc_bad
    call fr_pop
    movq %rax,%r12
    cmpq $1,%rdx
    jne .Llease_alloc_bad
    call fr_lease_check
    testl %eax,%eax
    jz .Llease_alloc_bad
    call fr_page_alloc
    call fr_pop
    testq %rax,%rax
    jz .Llease_alloc_bad
    movq %rax,%rdi
    subq $0x07000000,%rax
    shrq $12,%rax
    shlq $4,%rax
    leaq fr_lease_page_tags(%rip),%r8
    movq %r12,(%r8,%rax)
    movq %r13,8(%r8,%rax)
    jmp .Llease_alloc_return
.Llease_alloc_bad:
    xorq %rdi,%rdi
.Llease_alloc_return:
    popq %r13
    popq %r12
    movq $1,%rsi
    jmp fr_push

/* (owner generation page -- 1|0). Reject foreign/stale/unaligned pages. */
.global fr_lease_free
fr_lease_free:
    pushq %r12
    pushq %r13
    pushq %r14
    call fr_pop
    movq %rax,%r14
    cmpq $1,%rdx
    jne .Llease_free_bad
    call fr_pop
    movq %rax,%r13
    cmpq $1,%rdx
    jne .Llease_free_bad
    call fr_pop
    movq %rax,%r12
    cmpq $1,%rdx
    jne .Llease_free_bad
    call fr_lease_check
    testl %eax,%eax
    jz .Llease_free_bad
    cmpq $0x07000000,%r14
    jb .Llease_free_bad
    cmpq $0x07800000,%r14
    jae .Llease_free_bad
    testq $4095,%r14
    jne .Llease_free_bad
    movq %r14,%rax
    subq $0x07000000,%rax
    shrq $12,%rax
    shlq $4,%rax
    leaq fr_lease_page_tags(%rip),%r8
    cmpq %r12,(%r8,%rax)
    jne .Llease_free_bad
    cmpq %r13,8(%r8,%rax)
    jne .Llease_free_bad
    /* Tag must be removed before the legacy page-free rejects leased pages. */
    movq $0,(%r8,%rax)
    movq $0,8(%r8,%rax)
    movq %r14,%rdi
    movq $1,%rsi
    call fr_push
    call fr_page_free
    call fr_pop
    movq %rax,%rdi
    jmp .Llease_free_return
.Llease_free_bad:
    xorq %rdi,%rdi
.Llease_free_return:
    popq %r14
    popq %r13
    popq %r12
    movq $1,%rsi
    jmp fr_push

/* (owner generation -- reclaimed-count). Retires lease and scrubs frames. */
.global fr_lease_end
fr_lease_end:
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    call fr_pop
    movq %rax,%r13
    cmpq $1,%rdx
    jne .Llease_end_bad
    call fr_pop
    movq %rax,%r12
    cmpq $1,%rdx
    jne .Llease_end_bad
    call fr_lease_check
    testl %eax,%eax
    jz .Llease_end_bad
    xorq %r14,%r14
    xorq %r15,%r15
.Llease_end_scan:
    cmpq $2048,%r14
    jae .Llease_end_retire
    movq %r14,%rax
    shlq $4,%rax
    leaq fr_lease_page_tags(%rip),%r8
    cmpq %r12,(%r8,%rax)
    jne .Llease_end_next
    cmpq %r13,8(%r8,%rax)
    jne .Llease_end_next
    movq $0,(%r8,%rax)
    movq $0,8(%r8,%rax)
    movq %r14,%rdi
    shlq $12,%rdi
    addq $0x07000000,%rdi
    movq $1,%rsi
    call fr_push
    call fr_page_free
    call fr_pop
    addq %rax,%r15
.Llease_end_next:
    incq %r14
    jmp .Llease_end_scan
.Llease_end_retire:
    movq %r12,%rax
    decq %rax
    leaq fr_lease_live(%rip),%r8
    movq $0,(%r8,%rax,8)
    movq %r15,%rdi
    jmp .Llease_end_return
.Llease_end_bad:
    xorq %rdi,%rdi
.Llease_end_return:
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    movq $1,%rsi
    jmp fr_push
