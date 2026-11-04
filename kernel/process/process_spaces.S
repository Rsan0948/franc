/* FrancOS F1: bounded, firmware-authorized independent CPL3 address spaces.
 * This is a BIOS/QEMU exit-test probe, NOT concurrent Franc processes.
 *
 * Two generation-tagged owners each receive private PML4/PDPT/PD/PT,
 * code and stack pages from the E820-approved 8 MiB arena. Both roots
 * share the supervisor-only low kernel mapping; the user 1GiB region
 * is separately populated. A faults trying to read B's physical code
 * frame through the supervisor mapping; B then runs in its own CR3 and
 * writes its private stack. Exit invalidates CR3 aliases, retires both
 * owners and scrubs their pages. TSS/INT80 setup comes from the verified
 * ring3-probe. No user Franc compiler/runtime or scheduling here.
 */
.section .bss
.balign 16
fr_space_pages:       .skip 96    /* 2 * (PML4,PDPT,PD,PT,code,stack) */
fr_space_generations: .skip 16
fr_space_roots:       .skip 16
fr_space_states:      .skip 16   /* 4=faulted A; 2=completed B */
fr_space_active:      .skip 8
fr_space_done:        .skip 8
fr_space_phase:       .skip 8
fr_space_host_rsp:    .skip 8
fr_space_cr2:         .skip 8
fr_space_error:       .skip 8
fr_space_user_cpl:    .skip 8
fr_space_reclaimed:   .skip 8
fr_space_result:      .skip 8

.section .text,"ax"
/* %r12 owner, %r13 generation; return allocated physical page in rax. */
fr_space_take:
    movq %r12,%rdi
    movq $1,%rsi
    call fr_push
    movq %r13,%rdi
    movq $1,%rsi
    call fr_push
    call fr_lease_alloc
    call fr_pop
    ret

/* %r12 owner, %r13 generation; return number reclaimed in rax. */
fr_space_retire:
    movq %r12,%rdi
    movq $1,%rsi
    call fr_push
    movq %r13,%rdi
    movq $1,%rsi
    call fr_push
    call fr_lease_end
    call fr_pop
    ret

/* User A attempts to read B's *physical* code page, which is mapped
 * only through the kernel/supervisor low identity mapping.
 * movabs immediate is patched before this code is copied to user memory.
 */
fr_space_code_a:
    movabsq $0,%rax
    movzbl (%rax),%eax
    movl $0x41,%eax
    int $0x80
    ud2
fr_space_code_a_end:

/* User B performs an observable private-stack write and exits via INT80. */
fr_space_code_b:
    movabsq $0x40001000,%rdi
    movl $0,(%rdi)
    movl $12345,%ecx
.Lspace_user_loop:
    incl (%rdi)
    decl %ecx
    jnz .Lspace_user_loop
    movl $0x42,%eax
    int $0x80
    ud2
fr_space_code_b_end:

/* Called through existing #PF gate; on entry RSP points to error code
 * followed by RIP, CS, RFLAGS, user RSP and SS.
 * Unlike a general exception dispatcher, this handles ONLY the probe.
 */
fr_space_page_fault:
    movq %cr2,%rax
    movq %rax,fr_space_cr2(%rip)
    movq (%rsp),%rax
    movq %rax,fr_space_error(%rip)
    movq 16(%rsp),%rax
    andq $3,%rax
    movq %rax,fr_space_user_cpl(%rip)
    /* Recover on our guarded host stack, never return to faulting IP. */
    movq fr_space_host_rsp(%rip),%rsp
    movq $0x9000,%rax
    movq %rax,%cr3
    jmp .Lspace_fault_return

/* Called through the existing DPL3 INT80 gate. */
fr_space_int80:
    movq 8(%rsp),%rcx
    andq $3,%rcx
    movq %rcx,fr_space_user_cpl(%rip)
    movq %rax,fr_space_result(%rip)
    movq fr_space_host_rsp(%rip),%rsp
    movq $0x9000,%rax
    movq %rax,%cr3
    jmp .Lspace_syscall_return

.global fr_space_probe
fr_space_probe:
    pushq %rbx
    pushq %rbp
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    xorq %r15,%r15
    cmpq $1,fr_irq_running(%rip)
    jne .Lspace_return
    cmpq $1,fr_ring3_done(%rip)
    jne .Lspace_return
    cmpq $0,fr_ring3_active(%rip)
    jne .Lspace_return
    cmpq $0,fr_proc_active(%rip)
    jne .Lspace_return
    cmpq $0,fr_preempt_enabled(%rip)
    jne .Lspace_return
    cmpq $0,fr_space_done(%rip)
    jne .Lspace_return
    movq %cr3,%rax
    andq $-4096,%rax
    cmpq $0x9000,%rax
    jne .Lspace_return
    call fr_e820_arena_usable
    testl %eax,%eax
    jz .Lspace_return
    /* One-shot so failed allocation cannot reuse partially owned state. */
    movq $1,fr_space_done(%rip)
    movq $0,fr_space_states(%rip)
    movq $0,fr_space_states+8(%rip)
    movq $0,fr_space_reclaimed(%rip)
    movq $0,fr_space_cr2(%rip)
    movq $0,fr_space_error(%rip)
    movq $0,fr_space_user_cpl(%rip)
    movq $0,fr_space_result(%rip)

    /* Create two independent owner generations. */
    movq $1,%rdi
    movq $1,%rsi
    call fr_push
    call fr_lease_begin
    call fr_pop
    testq %rax,%rax
    jz .Lspace_cleanup
    movq %rax,fr_space_generations(%rip)
    movq $2,%rdi
    movq $1,%rsi
    call fr_push
    call fr_lease_begin
    call fr_pop
    testq %rax,%rax
    jz .Lspace_cleanup
    movq %rax,fr_space_generations+8(%rip)

    /* For each owner allocate six separately zeroed owned frames.
     * Every pointer is in the approved physical page arena.
     */
    xorq %rbx,%rbx
.Lspace_owner_loop:
    cmpq $2,%rbx
    jae .Lspace_build_roots
    leaq 1(%rbx),%r12
    leaq fr_space_generations(%rip),%r8
    movq (%r8,%rbx,8),%r13
    xorq %r14,%r14
.Lspace_alloc_loop:
    cmpq $6,%r14
    jae .Lspace_next_owner
    call fr_space_take
    testq %rax,%rax
    jz .Lspace_cleanup
    movq %rbx,%rcx
    imulq $6,%rcx
    addq %r14,%rcx
    leaq fr_space_pages(%rip),%r8
    movq %rax,(%r8,%rcx,8)
    incq %r14
    jmp .Lspace_alloc_loop
.Lspace_next_owner:
    incq %rbx
    jmp .Lspace_owner_loop

/* Write each private PML4/PDPT/PD/PT. Clone exactly the low PDPT[0]
 * supervisor mapping from BIOS, NEVER use a user bit on PDPT[0].
 * The independent user region starts at virtual 0x40000000.
 */
.Lspace_build_roots:
    xorq %rbx,%rbx
.Lspace_table_loop:
    cmpq $2,%rbx
    jae .Lspace_install_code
    movq %rbx,%rcx
    imulq $48,%rcx
    leaq fr_space_pages(%rip),%r8
    addq %rcx,%r8
    movq (%r8),%r9    /* PML4 */
    movq 8(%r8),%r10  /* PDPT */
    movq 16(%r8),%r11 /* PD */
    movq 24(%r8),%r12 /* PT */
    movq 32(%r8),%r13 /* code */
    movq 40(%r8),%r14 /* stack */
    movq %r10,%rax
    orq $7,%rax
    movq %rax,(%r9)
    movq 0xa000,%rax   /* QEMU BIOS original PDPT[0] is supervisor */
    testq $4,%rax
    jnz .Lspace_cleanup /* refuse an unexpected user kernel mapping */
    testq $1,%rax
    jz .Lspace_cleanup
    movq %rax,(%r10)
    movq %r11,%rax
    orq $7,%rax
    movq %rax,8(%r10)
    movq %r12,%rax
    orq $7,%rax
    movq %rax,(%r11)
    movq %r13,%rax
    orq $5,%rax       /* user read/execute, no user write */
    movq %rax,(%r12)
    movq %r14,%rax
    orq $7,%rax       /* private user R/W stack */
    movq %rax,8(%r12)
    leaq fr_space_roots(%rip),%r8
    movq %r9,(%r8,%rbx,8)
    incq %rbx
    jmp .Lspace_table_loop

.Lspace_install_code:
    leaq fr_space_pages(%rip),%rbx
    /* B's code frame is unprivileged only in B's own root; A cannot
     * follow the kernel identity alias to discover its bytes.
     */
    leaq fr_space_code_a(%rip),%rsi
    movq 32(%rbx),%rdi
    movl $(fr_space_code_a_end-fr_space_code_a),%ecx
    cld
    rep movsb
    movq 80(%rbx),%rax /* B code: offset 48 + 32 */
    movq 32(%rbx),%r8
    movq %rax,2(%r8)   /* patch movabs immediate of user A */
    leaq fr_space_code_b(%rip),%rsi
    movq 80(%rbx),%rdi
    movl $(fr_space_code_b_end-fr_space_code_b),%ecx
    rep movsb

    cli
    movq $1,fr_space_active(%rip)
    movq $1,fr_space_phase(%rip)
    movq %rsp,fr_space_host_rsp(%rip)
    movq fr_space_roots(%rip),%rax
    movq %rax,%cr3
    pushq $0x2b
    pushq $0x40002000
    pushq $0x2          /* IF=0: this tests memory, not user IRQ0 yet */
    pushq $0x23
    pushq $0x40000000
    iretq

.Lspace_fault_return:
    movw $0x10,%ax
    movw %ax,%ss
    cmpq $1,fr_space_phase(%rip)
    jne .Lspace_abort_cli
    cmpq $3,fr_space_user_cpl(%rip)
    jne .Lspace_abort_cli
    movq fr_space_pages+80(%rip),%rax
    cmpq fr_space_cr2(%rip),%rax
    jne .Lspace_abort_cli
    movq fr_space_error(%rip),%rax
    andq $7,%rax
    cmpq $5,%rax       /* present, read, from user: supervisor denial */
    jne .Lspace_abort_cli
    movq $4,fr_space_states(%rip)
    movq $2,fr_space_phase(%rip)
    movq %rsp,fr_space_host_rsp(%rip)
    movq fr_space_roots+8(%rip),%rax
    movq %rax,%cr3
    pushq $0x2b
    pushq $0x40002000
    pushq $0x2
    pushq $0x23
    pushq $0x40000000
    iretq

.Lspace_syscall_return:
    movw $0x10,%ax
    movw %ax,%ss
    cmpq $2,fr_space_phase(%rip)
    jne .Lspace_abort_cli
    cmpq $3,fr_space_user_cpl(%rip)
    jne .Lspace_abort_cli
    cmpq $0x42,fr_space_result(%rip)
    jne .Lspace_abort_cli
    movq fr_space_pages+88(%rip),%rax /* B stack frame */
    cmpl $12345,(%rax)
    jne .Lspace_abort_cli
    movq $2,fr_space_states+8(%rip)
    movq $1,%r15

.Lspace_abort_cli:
    movq $0,fr_space_active(%rip)
    /* Ensure no released user page remains mapped in the active CR3. */
    movq $0x9000,%rax
    movq %rax,%cr3
    sti

.Lspace_cleanup:
    xorq %rbx,%rbx
.Lspace_retire_loop:
    cmpq $2,%rbx
    jae .Lspace_finish
    leaq fr_space_generations(%rip),%r8
    movq (%r8,%rbx,8),%r13
    testq %r13,%r13
    jz .Lspace_retire_next
    leaq 1(%rbx),%r12
    call fr_space_retire
    addq %rax,fr_space_reclaimed(%rip)
.Lspace_retire_next:
    incq %rbx
    jmp .Lspace_retire_loop

.Lspace_finish:
    /* An accepted probe must cleanly reclaim all 12 owned frames. */
    cmpq $1,%r15
    jne .Lspace_return
    cmpq $12,fr_space_reclaimed(%rip)
    je .Lspace_return
    xorq %r15,%r15
.Lspace_return:
    movq %r15,%rdi
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbp
    popq %rbx
    movq $1,%rsi
    jmp fr_push

/* Independent QEMU-readable state, no serialized claim of concurrent user
 * scheduling. These probes are intentionally read-only after execution.
 */
.global fr_space_root_a
fr_space_root_a:
    movq fr_space_roots(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_space_root_b
fr_space_root_b:
    movq fr_space_roots+8(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_space_state_a
fr_space_state_a:
    movq fr_space_states(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_space_state_b
fr_space_state_b:
    movq fr_space_states+8(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_space_fault_addr
fr_space_fault_addr:
    movq fr_space_cr2(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_space_reclaimed_count
fr_space_reclaimed_count:
    movq fr_space_reclaimed(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
