/* FrancOS experimental BIOS/QEMU CPL3 proof. Not a userland ABI.
 * Creates supervisor-protected kernel map plus two 4KiB user aliases
 * at 0x40000000/0x40001000. Installs GDT, 64-bit TSS RSP0, user INT80
 * gate and a fail-closed page-fault gate. One user snippet traps via
 * INT80, the other attempts to READ supervisor memory at 0x10000 and
 * must #PF. Only one run is allowed; no general process management.
 *
 * Prerequisites: irq-start has initialized the IDT. BIOS CR3=0x9000,
 * PML4[0] points to 0xa000, PDPT[0] remains supervisor-only.
 * UEFI mapping or general hardware paging are intentionally rejected.
 */
.code64
.section .bss
.balign 4096
fr_ring3_pd: .skip 4096
.balign 4096
fr_ring3_pt: .skip 4096
.balign 4096
fr_ring3_user_codepage: .skip 4096
.balign 4096
fr_ring3_user_stack: .skip 4096
.balign 16
fr_ring3_kernel_stack: .skip 16384
.balign 16
fr_ring3_tss: .skip 104
.balign 8
fr_ring3_active: .skip 8
fr_ring3_done: .skip 8
fr_ring3_phase: .skip 8
fr_ring3_host_rsp: .skip 8
fr_ring3_good_return: .skip 8
fr_ring3_user_cs: .skip 8
fr_ring3_fault: .skip 8
fr_ring3_cr2: .skip 8
fr_ring3_pferror: .skip 8
/* Separate physical backing pages for a restricted two-process
 * survival probe. Each process maps ONLY its own pages at the same two
 * virtual addresses; neither can access the other's physical frames.
 */
.balign 4096
fr_proc_b_codepage: .skip 4096
.balign 4096
fr_proc_b_stack: .skip 4096
.balign 8
fr_proc_active: .skip 8
fr_proc_done: .skip 8
fr_proc_a_state: .skip 8  /* 4 = faulted */
fr_proc_b_state: .skip 8  /* 2 = completed */
fr_proc_b_syscall: .skip 8
fr_proc_survivor: .skip 8

.section .data
.balign 16
fr_ring3_gdt:
    .quad 0
    .quad 0x00cf9a000000ffff /* 0x08: original 32-bit kernel code */
    .quad 0x00cf92000000ffff /* 0x10: kernel data */
    .quad 0x00af9a000000ffff /* 0x18: original 64-bit kernel code */
    .quad 0x00affa000000ffff /* 0x20: user 64-bit code, RPL3=0x23 */
    .quad 0x00cff2000000ffff /* 0x28: user data, RPL3=0x2b */
    .quad 0,0                 /* 0x30: dynamically installed 64-bit TSS */
fr_ring3_gdt_end:
.balign 8
fr_ring3_gdtr:
    .word fr_ring3_gdt_end - fr_ring3_gdt - 1
    .quad 0

.section .text,"ax"
/* On entry rdi=gate address, rsi=handler, edx=attr 0x8e00/0xee00.
 * Keep gate selector at current kernel CS (the BIOS uses 0x18).
 */
fr_ring3_setgate:
    movw %si,0(%rdi)
    movw %cs,2(%rdi)
    movw %dx,4(%rdi)
    movq %rsi,%rax
    shrq $16,%rax
    movw %ax,6(%rdi)
    movq %rsi,%rax
    shrq $32,%rax
    movl %eax,8(%rdi)
    movl $0,12(%rdi)
    ret

/* Only the exact two user transitions specified by the probe are
 * accepted. No arbitrary user syscall dispatch or unsafe kernel calls.
 */
fr_ring3_int80:
    cmpq $1,fr_user_enabled(%rip)
    je fr_user_int80
    cmpq $1,fr_space_active(%rip)
    je fr_space_int80
    cmpq $1,fr_ring3_active(%rip)
    jne .Lring3_unexpected
    cmpq $3,fr_ring3_phase(%rip)
    je .Lproc_int80
    cmpq $1,fr_ring3_phase(%rip)
    jne .Lring3_unexpected
    movq 8(%rsp),%rax         /* interrupted CS at frame slot 1 */
    andq $3,%rax
    cmpq $3,%rax
    jne .Lring3_unexpected
    movq $3,fr_ring3_user_cs(%rip)
    movq $1,fr_ring3_good_return(%rip)
    movq fr_ring3_host_rsp(%rip),%rsp
    jmp .Lring3_after_good

.Lproc_int80:
    cmpq $1,fr_proc_active(%rip)
    jne .Lring3_unexpected
    movq 8(%rsp),%rax
    andq $3,%rax
    cmpq $3,%rax
    jne .Lring3_unexpected
    movq $1,fr_proc_b_syscall(%rip)
    movq fr_ring3_host_rsp(%rip),%rsp
    jmp .Lproc_after_success

fr_ring3_page_fault:
    testb $3,16(%rsp)         /* kernel-mode faults are not user faults */
    jz fr_fault_14
    cmpq $1,fr_user_enabled(%rip)
    je fr_user_page_fault
    cmpq $1,fr_space_active(%rip)
    je fr_space_page_fault
    cmpq $1,fr_ring3_active(%rip)
    jne .Lring3_unexpected
    cmpq $2,fr_ring3_phase(%rip)
    jne .Lring3_unexpected
    movq %cr2,%rax
    movq %rax,fr_ring3_cr2(%rip)
    cmpq $0x10000,%rax
    jne .Lring3_unexpected
    movq (%rsp),%rax          /* #PF pushes a 64-bit error code */
    movq %rax,fr_ring3_pferror(%rip)
    testq $4,%rax            /* user-mode access */
    jz .Lring3_unexpected
    movq 16(%rsp),%rax        /* interrupted CS follows error+RIP */
    andq $3,%rax
    cmpq $3,%rax
    jne .Lring3_unexpected
    movq $1,fr_ring3_fault(%rip)
    movq fr_ring3_host_rsp(%rip),%rsp
    cmpq $1,fr_proc_active(%rip)
    je .Lproc_after_fault
    jmp .Lring3_after_fault

.Lring3_unexpected:
    cli
    movw $0x3f8,%dx
    movb $'U',%al
    outb %al,%dx
.Lring3_dead:
    hlt
    jmp .Lring3_dead

/* Offsets of the user-code snippets are fixed within the same page.
 * No linking, syscalls, relocations or Franc runtime in CPL3.
 */
fr_ring3_good_code:
    movq $0x1234,%rax
    int $0x80
    ud2
fr_ring3_good_code_end:
fr_ring3_bad_code:
    movabsq $0x10000,%rax
    movzbl (%rax),%eax        /* expected supervisor-mode protection #PF */
    int $0x80                /* must never be reached */
    ud2
fr_ring3_bad_code_end:

.global fr_ring3_probe
fr_ring3_probe:
    /* Save SysV non-volatile registers for return to Franc JIT. */
    pushq %rbx
    pushq %rbp
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    cmpq $1,fr_irq_running(%rip)
    jne .Lring3_probe_fail
    cmpq $0,fr_ring3_done(%rip)
    jne .Lring3_probe_fail
    movq %cr3,%rax
    andq $-4096,%rax
    cmpq $0x9000,%rax        /* BIOS-only known source page tables */
    jne .Lring3_probe_fail
    cli
    /* Initialize all private tables and user pages, not kernel memory. */
    leaq fr_ring3_pd(%rip),%rdi
    movl $512,%ecx
    xorq %rax,%rax
    cld
    rep stosq
    leaq fr_ring3_pt(%rip),%rdi
    movl $512,%ecx
    rep stosq
    leaq fr_ring3_user_codepage(%rip),%rdi
    movl $512,%ecx
    rep stosq
    leaq fr_ring3_user_stack(%rip),%rdi
    movl $512,%ecx
    rep stosq
    /* Copy position-independent tiny user programs into user page. */
    leaq fr_ring3_good_code(%rip),%rsi
    leaq fr_ring3_user_codepage(%rip),%rdi
    movl $(fr_ring3_good_code_end-fr_ring3_good_code),%ecx
    rep movsb
    leaq fr_ring3_bad_code(%rip),%rsi
    leaq fr_ring3_user_codepage+128(%rip),%rdi
    movl $(fr_ring3_bad_code_end-fr_ring3_bad_code),%ecx
    rep movsb

    /* New user-only 1GiB virtual region, no user access to low
     * kernel mappings because PDPT[0] retains U/S=0.
     */
    leaq fr_ring3_user_codepage(%rip),%rax
    orq $5,%rax            /* read/execute, user, read-only */
    movq %rax,fr_ring3_pt(%rip)
    leaq fr_ring3_user_stack(%rip),%rax
    orq $7,%rax            /* user read/write stack */
    movq %rax,fr_ring3_pt+8(%rip)
    leaq fr_ring3_pt(%rip),%rax
    orq $7,%rax
    movq %rax,fr_ring3_pd(%rip)
    movq $0x9000,%rbx
    movq (%rbx),%rax
    orq $4,%rax
    movq %rax,(%rbx)       /* PML4[0] U/S=1, subordinate kernel PDPT US=0 */
    movq 0(%rbx),%rax
    andq $-4096,%rax
    movq %rax,%rbx         /* PDPT 0xa000 */
    cmpq $0,8(%rbx)       /* existing UEFI mappings cannot be replaced */
    jne .Lring3_abort_cli
    leaq fr_ring3_pd(%rip),%rax
    orq $7,%rax
    movq %rax,8(%rbx)
    movq %cr3,%rax
    movq %rax,%cr3         /* flush translation caches after U/S changes */

    /* fr_cpu_init loaded the GDT and TSS at boot; set the ring-0 stack. */
    leaq fr_ring3_kernel_stack+16384(%rip),%rax
    movq %rax,fr_ring3_tss+4(%rip) /* 64-bit TSS RSP0 offset 4 */
    /* Two protected gates: #PF with error code, software INT80 DPL3. */
    leaq fr_irq_idt+224(%rip),%rdi
    leaq fr_ring3_page_fault(%rip),%rsi
    movl $0x8e00,%edx
    call fr_ring3_setgate
    leaq fr_irq_idt+2048(%rip),%rdi
    leaq fr_ring3_int80(%rip),%rsi
    movl $0xee00,%edx
    call fr_ring3_setgate

    movq $1,fr_ring3_done(%rip)
    movq $1,fr_ring3_active(%rip)
    movq $1,fr_ring3_phase(%rip)
    movq $0,fr_ring3_good_return(%rip)
    movq $0,fr_ring3_fault(%rip)
    movq $0,fr_ring3_cr2(%rip)
    movq $0,fr_ring3_pferror(%rip)
    movq %rsp,fr_ring3_host_rsp(%rip)
    pushq $0x2b           /* user SS */
    pushq $0x40002000    /* stack top: exclusive end of 4KiB user page */
    pushq $0x202         /* IF=1 and reserved bit 1 set */
    pushq $0x23           /* user 64-bit code CS */
    pushq $0x40000000    /* user code via user-only page-table entry */
    iretq

.Lring3_after_good:
    movw $0x10,%ax
    movw %ax,%ss
    cmpq $1,fr_ring3_good_return(%rip)
    jne .Lring3_probe_finish
    movq $2,fr_ring3_phase(%rip)
    movq %rsp,fr_ring3_host_rsp(%rip)
    pushq $0x2b
    pushq $0x40002000
    pushq $0x202
    pushq $0x23
    pushq $0x40000080
    iretq

.Lring3_after_fault:
    movw $0x10,%ax
    movw %ax,%ss
    cmpq $1,fr_ring3_fault(%rip)
    jne .Lring3_probe_finish
    cmpq $3,fr_ring3_user_cs(%rip)
    jne .Lring3_probe_finish
    movq $1,%r12
    jmp .Lring3_probe_finish_success

.Lring3_abort_cli:
    /* Only reached before GDT/TSS/entry; do not expose CPL3 on error. */
    sti
.Lring3_probe_fail:
    /* Rejecting entry before irq-start MUST NOT execute STI: there is
     * no installed protected IDT and a PIT IRQ would wedge the guest.
     * After successful initialization a failing one-shot reentry leaves
     * the caller's IF state unchanged instead of enabling it.
     */
    xorq %r12,%r12
    jmp .Lring3_probe_return

.Lring3_probe_finish:
    xorq %r12,%r12
.Lring3_probe_finish_success:
    movq $0,fr_ring3_active(%rip)
    sti
.Lring3_probe_return:
    movq %r12,%rdi
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbp
    popq %rbx
    movq $1,%rsi
    jmp fr_push

.global fr_ring3_user_cpl
fr_ring3_user_cpl:
    movq fr_ring3_user_cs(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_ring3_fault_seen
fr_ring3_fault_seen:
    movq fr_ring3_fault(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_ring3_fault_address
fr_ring3_fault_address:
    movq fr_ring3_cr2(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_ring3_fault_error
fr_ring3_fault_error:
    movq fr_ring3_pferror(%rip),%rdi
    movq $1,%rsi
    jmp fr_push


/* Two successive isolated CPL3 contexts, NOT concurrent user processes.
 * First A deliberately faults reading supervisor memory; kernel records
 * #PF and unmaps A's user pages, switches PTEs to B's distinct physical
 * code/stack pages, reloads CR3 and launches B at the SAME user VAs.
 * B executes a private write loop and makes a restricted INT80 syscall.
 * Both executions run at CPL3; kernel and host REPL must survive.
 */
fr_proc_b_code:
    movabsq $0x40001000,%rdi
    movl $0,(%rdi)
    movl $50000,%ecx
.Lproc_b_loop:
    incl (%rdi)
    decl %ecx
    jnz .Lproc_b_loop
    movl $0x40,%eax
    int $0x80
    ud2
fr_proc_b_code_end:

.global fr_proc_probe
fr_proc_probe:
    pushq %rbx
    pushq %rbp
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    cmpq $1,fr_irq_running(%rip)
    jne .Lproc_probe_bad
    cmpq $1,fr_ring3_done(%rip)
    jne .Lproc_probe_bad
    cmpq $0,fr_ring3_active(%rip)
    jne .Lproc_probe_bad
    cmpq $0,fr_preempt_enabled(%rip)
    jne .Lproc_probe_bad
    cmpq $0,fr_proc_done(%rip)
    jne .Lproc_probe_bad
    movq %cr3,%rax
    andq $-4096,%rax
    cmpq $0x9000,%rax
    jne .Lproc_probe_bad
    cli
    /* B's physical pages remain supervisor-only under the kernel's low
     * identity mapping and will be aliased exclusively when B starts.
     */
    leaq fr_proc_b_codepage(%rip),%rdi
    movl $512,%ecx
    xorl %eax,%eax
    cld
    rep stosq
    leaq fr_proc_b_stack(%rip),%rdi
    movl $512,%ecx
    rep stosq
    leaq fr_proc_b_code(%rip),%rsi
    leaq fr_proc_b_codepage(%rip),%rdi
    movl $(fr_proc_b_code_end-fr_proc_b_code),%ecx
    rep movsb
    movq $1,fr_proc_done(%rip)
    movq $1,fr_proc_active(%rip)
    movq $1,fr_proc_a_state(%rip)
    movq $0,fr_proc_b_state(%rip)
    movq $0,fr_proc_b_syscall(%rip)
    movq $0,fr_proc_survivor(%rip)
    movq $0,fr_ring3_fault(%rip)
    movq $0,fr_ring3_cr2(%rip)
    movq $0,fr_ring3_pferror(%rip)
    movq $1,fr_ring3_active(%rip)
    movq $2,fr_ring3_phase(%rip)
    /* Reinstall A-only aliases. The 0x40001000 stack slot and code page
     * cannot expose any of B's physical frames during A's execution.
     */
    leaq fr_ring3_user_codepage(%rip),%rax
    orq $5,%rax
    movq %rax,fr_ring3_pt(%rip)
    leaq fr_ring3_user_stack(%rip),%rax
    orq $7,%rax
    movq %rax,fr_ring3_pt+8(%rip)
    movq %cr3,%rax
    movq %rax,%cr3
    movq %rsp,fr_ring3_host_rsp(%rip)
    pushq $0x2b
    pushq $0x40002000
    pushq $0x202
    pushq $0x23
    pushq $0x40000080       /* process A's deliberate #PF snippet */
    iretq

/* Entered on the host CPU stack by the A-only page-fault gate. */
.Lproc_after_fault:
    movw $0x10,%ax
    movw %ax,%ss
    cmpq $1,fr_ring3_fault(%rip)
    jne .Lproc_abort
    cmpq $0x10000,fr_ring3_cr2(%rip)
    jne .Lproc_abort
    movq $4,fr_proc_a_state(%rip)
    movq $1,fr_proc_b_state(%rip)
    /* Revoke A's virtual aliases and map B's independent code/stack.
     * Explicit reload is essential to invalidate the old A translations.
     */
    leaq fr_proc_b_codepage(%rip),%rax
    orq $5,%rax
    movq %rax,fr_ring3_pt(%rip)
    leaq fr_proc_b_stack(%rip),%rax
    orq $7,%rax
    movq %rax,fr_ring3_pt+8(%rip)
    movq %cr3,%rax
    movq %rax,%cr3
    movq $3,fr_ring3_phase(%rip)
    movq %rsp,fr_ring3_host_rsp(%rip)
    pushq $0x2b
    pushq $0x40002000
    pushq $0x202
    pushq $0x23
    pushq $0x40000000
    iretq

/* Restricted INT80 completion from B: inspect its private physical page
 * and check the loop actually completed before declaring survival.
 */
.Lproc_after_success:
    movw $0x10,%ax
    movw %ax,%ss
    cmpq $1,fr_proc_b_syscall(%rip)
    jne .Lproc_abort
    cmpl $50000,fr_proc_b_stack(%rip)
    jne .Lproc_abort
    movq $2,fr_proc_b_state(%rip)
    movq $1,fr_proc_survivor(%rip)
    movq $1,%r12
    jmp .Lproc_finish
.Lproc_abort:
    xorq %r12,%r12
    jmp .Lproc_finish
.Lproc_probe_bad:
    xorq %r12,%r12
    jmp .Lproc_return
.Lproc_finish:
    /* Both user aliases are revoked after exit. No stale B mapping is
     * left in the address space to be accessed by another user context.
     */
    movq $0,fr_ring3_pt(%rip)
    movq $0,fr_ring3_pt+8(%rip)
    movq %cr3,%rax
    movq %rax,%cr3
    movq $0,fr_ring3_active(%rip)
    movq $0,fr_proc_active(%rip)
    sti
.Lproc_return:
    movq %r12,%rdi
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbp
    popq %rbx
    movq $1,%rsi
    jmp fr_push

.global fr_proc_state_a
fr_proc_state_a:
    movq fr_proc_a_state(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_proc_state_b
fr_proc_state_b:
    movq fr_proc_b_state(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_proc_b_steps
fr_proc_b_steps:
    movl fr_proc_b_stack(%rip),%edi
    movq $1,%rsi
    jmp fr_push
.global fr_proc_survivor_ok
fr_proc_survivor_ok:
    movq fr_proc_survivor(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
