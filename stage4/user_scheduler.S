/* FrancOS Wave 2 / F2: first bounded IRQ-preempted CPL3 user contexts.
 *
 * Two *assembly stub* user contexts use separately leased E820-approved
 * PML4/PDPT/PD/PT, code, user stack and kernel RSP0 pages. IRQ0 saves
 * all 15 integer GPRs plus the hardware IRET frame, switches CR3 and
 * per-task TSS.RSP0, and resumes the other CPL3 task or the host REPL.
 * Invalid INT80 codes or CPL3 page faults retire only the offending slot.
 *
 * This is explicitly NOT F3: the users are not yet compiled Franc source,
 * the syscalls are only exit(0) and invalid-call termination, FPU/SIMD is
 * forbidden, there is no indefinite scheduler or general process API.
 * The bounded 80-tick QEMU test must still prove real user preemption,
 * private memory and host recovery; no cooperative yields are involved.
 */
.section .bss
.balign 16
fr_user_saved_rsp:      .skip 24  /* 0 host, 1 A, 2 B */
fr_user_kstacks:        .skip 16  /* owned physical 4KiB RSP0 frames */
fr_user_states:         .skip 24  /* 0 host, 1 runnable, 2 exit, 3 timeout, 4 fault */
fr_user_current:        .skip 8
fr_user_enabled:        .skip 8
fr_user_busy:           .skip 8
fr_user_target_tick:    .skip 8
fr_user_switch_count:   .skip 8
fr_user_fault_addr:     .skip 8
fr_user_syscall_code:   .skip 8
fr_user_reclaimed:      .skip 8
fr_user_mode:           .skip 8  /* 0 never fault, 1 A faults after progress */
fr_user_result:         .skip 8
fr_user_a_progress:     .skip 8
fr_user_b_progress:     .skip 8

.section .text,"ax"
/* Entered from fr_irq_timer with 15 GPRs saved and PIC EOI already sent. */
fr_user_timer_tick:
    movq fr_user_current(%rip),%rax
    cmpq $2,%rax
    ja .Luser_fatal
    leaq fr_user_saved_rsp(%rip),%rcx
    movq %rsp,(%rcx,%rax,8)
    incq fr_user_switch_count(%rip)
    movq fr_irq_tick_count(%rip),%r8
    cmpq fr_user_target_tick(%rip),%r8
    jae .Luser_timeout
    incq %rax
    cmpq $3,%rax
    jb .Luser_try_slot
    xorq %rax,%rax
.Luser_try_slot:
    testq %rax,%rax
    jz fr_user_dispatch
    leaq fr_user_states(%rip),%rcx
    cmpq $1,(%rcx,%rax,8)
    je fr_user_dispatch
    incq %rax
    cmpq $3,%rax
    jb .Luser_try_slot
    xorq %rax,%rax
    jmp fr_user_dispatch
.Luser_timeout:
    movq $0,fr_user_enabled(%rip)
    cmpq $1,fr_user_states+8(%rip)
    jne .Luser_timeout_b
    movq $3,fr_user_states+8(%rip)
.Luser_timeout_b:
    cmpq $1,fr_user_states+16(%rip)
    jne .Luser_timeout_host
    movq $3,fr_user_states+16(%rip)
.Luser_timeout_host:
    xorq %rax,%rax
    jmp fr_user_dispatch

/* rax = 0 (trusted host) or 1..2 (prevalidated runnable user).
 * Called only with interrupts masked from IRQ0 or user trap gates.
 * It never invokes the Franc allocator/dictionary or Rat stack.
 */
fr_user_dispatch:
    movq %rax,fr_user_current(%rip)
    testq %rax,%rax
    jz .Luser_resume_host
    movq %rax,%r10
    decq %r10
    leaq fr_space_roots(%rip),%rcx
    movq (%rcx,%r10,8),%rdx
    testq %rdx,%rdx
    jz .Luser_fatal
    movq %rdx,%cr3
    leaq fr_user_kstacks(%rip),%rcx
    movq (%rcx,%r10,8),%rdx
    leaq 4096(%rdx),%rdx
    movq %rdx,fr_ring3_tss+4(%rip)
    leaq fr_user_saved_rsp(%rip),%rcx
    movq (%rcx,%rax,8),%rsp
    jmp .Lirq_restore
.Luser_resume_host:
    movq $0x9000,%rdx
    movq %rdx,%cr3
    movq fr_user_saved_rsp(%rip),%rsp
    jmp .Lirq_restore
.Luser_fatal:
    cli
    movb $'X',%al
    movw $0x3f8,%dx
    outb %al,%dx
.Luser_halt:
    hlt
    jmp .Luser_halt

/* User trap gates push an IRET frame (plus #PF error), not a saved GPR
 * frame. Save all 15 GPRs for identical dispatch, but the faulted task
 * is never resumed. Every unknown call fails closed for *that* task.
 */
fr_user_page_fault:
    movq 16(%rsp),%rcx /* CS after #PF error + RIP */
    andq $3,%rcx
    cmpq $3,%rcx
    jne .Luser_fatal
    movq %cr2,%rcx
    movq %rcx,fr_user_fault_addr(%rip)
    jmp fr_user_trap_retire
fr_user_int80:
    movq 8(%rsp),%rcx  /* CS after RIP, no error code */
    andq $3,%rcx
    cmpq $3,%rcx
    jne .Luser_fatal
    /* A narrow 64-bit syscall ABI. Successful calls return through IRETQ;
     * no unvalidated userspace pointer may be dereferenced by the kernel.
     * RAX=0 exit, 1 write-buffer (RDI ptr, RSI 1..80), 2 ticks,
     * 3 nonblocking serial input; all others retire only this user.
     * Only writable user-stack mappings may supply buffer bytes. This is
     * not yet the F3 package/file I/O service boundary.
     */
    cmpq $1,%rax
    je .Luser_sys_write
    cmpq $2,%rax
    je .Luser_sys_ticks
    cmpq $3,%rax
    je .Luser_sys_read
    movq %rax,fr_user_syscall_code(%rip)
    jmp fr_user_trap_retire
.Luser_sys_ticks:
    movq fr_irq_tick_count(%rip),%rax
    iretq
.Luser_sys_read:
    movw $0x3fd,%dx
    inb %dx,%al
    testb $1,%al
    jz .Luser_sys_no_input
    movw $0x3f8,%dx
    inb %dx,%al
    movzbl %al,%eax
    iretq
.Luser_sys_no_input:
    movq $-1,%rax
    iretq
.Luser_sys_write:
    cmpq $0x40001000,%rdi
    jb .Luser_sys_bad_pointer
    cmpq $0x40002000,%rdi
    jae .Luser_sys_bad_pointer
    cmpq $1,%rsi
    jb .Luser_sys_bad_pointer
    cmpq $80,%rsi
    ja .Luser_sys_bad_pointer
    movq $0x40002000,%rcx
    subq %rdi,%rcx
    cmpq %rsi,%rcx
    jb .Luser_sys_bad_pointer
    movq %rdi,%r9
    movq %rsi,%r8
.Luser_sys_write_loop:
    /* No more than 80 bytes. Avoid printf, heap, Franc Rat stacks, IRQ
     * nesting or mutable JIT data while on a CPL3 kernel stack.
     */
    movzbl (%r9),%eax
    movw $0x3f8,%dx
    outb %al,%dx
    incq %r9
    decq %r8
    jnz .Luser_sys_write_loop
    movq %rsi,%rax
    iretq
.Luser_sys_bad_pointer:
    movq $-2,fr_user_syscall_code(%rip)
    jmp fr_user_trap_retire
fr_user_trap_retire:
    pushq %rax
    pushq %rbx
    pushq %rcx
    pushq %rdx
    pushq %rsi
    pushq %rdi
    pushq %rbp
    pushq %r8
    pushq %r9
    pushq %r10
    pushq %r11
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    movq fr_user_current(%rip),%rcx
    cmpq $1,%rcx
    jb .Luser_fatal
    cmpq $2,%rcx
    ja .Luser_fatal
    leaq fr_user_states(%rip),%r8
    movq $4,(%r8,%rcx,8)
    /* For INT80(0), distinguish normal exit from a user error. */
    cmpq $0,fr_user_syscall_code(%rip)
    jne .Luser_trap_next
    cmpq $0,fr_user_fault_addr(%rip)
    jne .Luser_trap_next
    movq $2,(%r8,%rcx,8)
.Luser_trap_next:
    /* Switch to the other runnable user, or return to host. */
    cmpq $1,%rcx
    je .Luser_trap_other_b
    movq $1,%rax
    jmp .Luser_trap_check
.Luser_trap_other_b:
    movq $2,%rax
.Luser_trap_check:
    cmpq $1,(%r8,%rax,8)
    je fr_user_dispatch
    movq $0,fr_user_enabled(%rip)
    xorq %rax,%rax
    jmp fr_user_dispatch

/* User-space CPU-bound code. Both use only their *own* virtual user
 * stack at 0x40001000. No Franc code or privileged helper is called.
 */
fr_user_code_a:
    movabsq $0x40001000,%rdi
.Luser_a_loop:
    incl (%rdi)
    pause
    jmp .Luser_a_loop
fr_user_code_a_end:
fr_user_code_a_fault:
    movabsq $0x40001000,%rdi
    movl $1000,%ecx
.Luser_a_fault_loop:
    incl (%rdi)
    decl %ecx
    jnz .Luser_a_fault_loop
    movabsq $0x10000,%rax
    movzbl (%rax),%eax /* user #PF, expected supervisor read denial */
    ud2
fr_user_code_a_fault_end:
/* Deterministic F2 ABI checks. These user snippets run in real CPL3,
 * use the same isolated private stack, and return through the validated
 * syscall/IRQ boundaries. Actual Franc-authored user words remain F3.
 */
fr_user_code_a_exit:
    movabsq $0x40001000,%rdi
    movl $1000,%ecx
.Luser_a_exit_loop:
    incl (%rdi)
    decl %ecx
    jnz .Luser_a_exit_loop
    xorl %eax,%eax
    int $0x80
    ud2
fr_user_code_a_exit_end:
fr_user_code_a_invalid:
    movabsq $0x40001000,%rdi
    movl $1000,%ecx
.Luser_a_invalid_loop:
    incl (%rdi)
    decl %ecx
    jnz .Luser_a_invalid_loop
    movl $99,%eax
    int $0x80
    ud2
fr_user_code_a_invalid_end:
fr_user_code_a_write:
    movabsq $0x40001000,%rdi
    movl $1000,%ecx
.Luser_a_write_loop:
    incl (%rdi)
    decl %ecx
    jnz .Luser_a_write_loop
    movb 
.Luser_b_loop:
    addl $2,(%rdi)
    pause
    jmp .Luser_b_loop
fr_user_code_b_end:

/* Build synthetic *user-mode* saved IRQ frame for one kernel RSP0 page.
 * rdi = physical kernel stack top, rsi = user RIP, rdx = user RSP.
 */
fr_user_frame:
    subq $40,%rdi
    movq %rsi,(%rdi)
    movq $0x23,8(%rdi)
    movq $0x202,16(%rdi)
    movq %rdx,24(%rdi)
    movq $0x2b,32(%rdi)
    subq $120,%rdi
    movq %rdi,%r8
    movl $15,%ecx
    xorl %eax,%eax
    cld
    rep stosq
    movq %r8,%rax
    ret

/* Shared setup for the two explicit CLI experiments. Must preserve host
 * CPU callee-saved regs and never allow a second concurrent launch.
 */
fr_user_run:
    pushq %rbx
    pushq %rbp
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    movq %rdi,fr_user_mode(%rip)
    xorq %r15,%r15
    cmpq $1,fr_irq_running(%rip)
    jne .Luser_done
    cmpq $1,fr_ring3_done(%rip)
    jne .Luser_done
    cmpq $0,fr_ring3_active(%rip)
    jne .Luser_done
    cmpq $0,fr_space_active(%rip)
    jne .Luser_done
    cmpq $0,fr_preempt_enabled(%rip)
    jne .Luser_done
    cmpq $0,fr_user_busy(%rip)
    jne .Luser_done
    movq %cr3,%rax
    andq $-4096,%rax
    cmpq $0x9000,%rax
    jne .Luser_done
    call fr_e820_arena_usable
    testl %eax,%eax
    jz .Luser_done
    movq $1,fr_user_busy(%rip)
    movq $0,fr_user_fault_addr(%rip)
    movq $-1,fr_user_syscall_code(%rip)
    movq $0,fr_user_switch_count(%rip)
    movq $0,fr_user_reclaimed(%rip)
    movq $0,fr_user_states+8(%rip)
    movq $0,fr_user_states+16(%rip)
    movq $0,fr_user_a_progress(%rip)
    movq $0,fr_user_b_progress(%rip)
    /* Reacquire generation-tagged leases and independent page tables. */
    movq $1,%rdi
    movq $1,%rsi
    call fr_push
    call fr_lease_begin
    call fr_pop
    testq %rax,%rax
    jz .Luser_cleanup
    movq %rax,fr_space_generations(%rip)
    movq $2,%rdi
    movq $1,%rsi
    call fr_push
    call fr_lease_begin
    call fr_pop
    testq %rax,%rax
    jz .Luser_cleanup
    movq %rax,fr_space_generations+8(%rip)

    xorq %rbx,%rbx
.Luser_allocate_owner:
    cmpq $2,%rbx
    jae .Luser_maps
    leaq 1(%rbx),%r12
    leaq fr_space_generations(%rip),%r8
    movq (%r8,%rbx,8),%r13
    xorq %r14,%r14
.Luser_allocate_six:
    cmpq $6,%r14
    jae .Luser_allocate_kernel_stack
    call fr_space_take
    testq %rax,%rax
    jz .Luser_cleanup
    movq %rbx,%rcx
    imulq $6,%rcx
    addq %r14,%rcx
    leaq fr_space_pages(%rip),%r8
    movq %rax,(%r8,%rcx,8)
    incq %r14
    jmp .Luser_allocate_six
.Luser_allocate_kernel_stack:
    call fr_space_take
    testq %rax,%rax
    jz .Luser_cleanup
    leaq fr_user_kstacks(%rip),%r8
    movq %rax,(%r8,%rbx,8)
    incq %rbx
    jmp .Luser_allocate_owner

.Luser_maps:
    xorq %rbx,%rbx
.Luser_map_owner:
    cmpq $2,%rbx
    jae .Luser_write_code
    movq %rbx,%rcx
    imulq $48,%rcx
    leaq fr_space_pages(%rip),%r8
    addq %rcx,%r8
    movq 0(%r8),%r9
    movq 8(%r8),%r10
    movq 16(%r8),%r11
    movq 24(%r8),%r12
    movq 32(%r8),%r13
    movq 40(%r8),%r14
    movq %r10,%rax
    orq $7,%rax
    movq %rax,(%r9)       /* private PML4[0] */
    movq 0xa000,%rax
    testq $4,%rax
    jnz .Luser_cleanup
    testq $1,%rax
    jz .Luser_cleanup
    movq %rax,(%r10)      /* supervisor-only kernel 0..1GiB */
    movq %r11,%rax
    orq $7,%rax
    movq %rax,8(%r10)     /* user-region PDPT[1] */
    movq %r12,%rax
    orq $7,%rax
    movq %rax,(%r11)
    movq %r13,%rax
    orq $5,%rax
    movq %rax,(%r12)      /* user R/X code */
    movq %r14,%rax
    orq $7,%rax
    movq %rax,8(%r12)     /* user RW stack */
    leaq fr_space_roots(%rip),%r8
    movq %r9,(%r8,%rbx,8)
    incq %rbx
    jmp .Luser_map_owner

.Luser_write_code:
    leaq fr_space_pages(%rip),%rbx
    movq 32(%rbx),%rdi
    cmpq $1,fr_user_mode(%rip)
    jne .Luser_try_a_exit
    leaq fr_user_code_a_fault(%rip),%rsi
    movl $(fr_user_code_a_fault_end-fr_user_code_a_fault),%ecx
    jmp .Luser_copy_a
.Luser_try_a_exit:
    cmpq $2,fr_user_mode(%rip)
    jne .Luser_try_a_invalid
    leaq fr_user_code_a_exit(%rip),%rsi
    movl $(fr_user_code_a_exit_end-fr_user_code_a_exit),%ecx
    jmp .Luser_copy_a
.Luser_try_a_invalid:
    cmpq $3,fr_user_mode(%rip)
    jne .Luser_try_a_write
    leaq fr_user_code_a_invalid(%rip),%rsi
    movl $(fr_user_code_a_invalid_end-fr_user_code_a_invalid),%ecx
    jmp .Luser_copy_a
.Luser_try_a_write:
    cmpq $4,fr_user_mode(%rip)
    jne .Luser_try_a_bad_pointer
    leaq fr_user_code_a_write(%rip),%rsi
    movl $(fr_user_code_a_write_end-fr_user_code_a_write),%ecx
    jmp .Luser_copy_a
.Luser_try_a_bad_pointer:
    cmpq $5,fr_user_mode(%rip)
    jne .Luser_write_a_normal
    leaq fr_user_code_a_invalid_pointer(%rip),%rsi
    movl $(fr_user_code_a_invalid_pointer_end-fr_user_code_a_invalid_pointer),%ecx
    jmp .Luser_copy_a
.Luser_write_a_normal:
    leaq fr_user_code_a(%rip),%rsi
    movl $(fr_user_code_a_end-fr_user_code_a),%ecx
.Luser_copy_a:
    cld
    rep movsb
    leaq fr_user_code_b(%rip),%rsi
    movq 80(%rbx),%rdi
    movl $(fr_user_code_b_end-fr_user_code_b),%ecx
    rep movsb

    leaq fr_user_kstacks(%rip),%rbx
    movq (%rbx),%rdi
    addq $4096,%rdi
    movq $0x40000000,%rsi
    movq $0x40002000,%rdx
    call fr_user_frame
    movq %rax,fr_user_saved_rsp+8(%rip)
    movq 8(%rbx),%rdi
    addq $4096,%rdi
    movq $0x40000000,%rsi
    movq $0x40002000,%rdx
    call fr_user_frame
    movq %rax,fr_user_saved_rsp+16(%rip)

    movq $1,fr_user_states+8(%rip)
    movq $1,fr_user_states+16(%rip)
    movq $0,fr_user_current(%rip)
    movq fr_irq_tick_count(%rip),%rax
    addq $80,%rax
    movq %rax,fr_user_target_tick(%rip)
    movq $1,fr_user_enabled(%rip)
    sti
.Luser_host_spin:
    movq fr_irq_tick_count(%rip),%rax
    cmpq fr_user_target_tick(%rip),%rax
    jb .Luser_host_spin
    cli
    movq $0,fr_user_enabled(%rip)
    movq $0x9000,%rax
    movq %rax,%cr3
    cmpq $1,fr_user_states+8(%rip)
    jne .Luser_check_b_state
    movq $3,fr_user_states+8(%rip)
.Luser_check_b_state:
    cmpq $1,fr_user_states+16(%rip)
    jne .Luser_verify
    movq $3,fr_user_states+16(%rip)
.Luser_verify:
    movq fr_space_pages+40(%rip),%rax
    movl (%rax),%r10d
    movq %r10,fr_user_a_progress(%rip)
    movq fr_space_pages+88(%rip),%rax
    movl (%rax),%r10d
    movq %r10,fr_user_b_progress(%rip)
    cmpq $0,fr_user_a_progress(%rip)
    je .Luser_cleanup_cli
    cmpq $0,fr_user_b_progress(%rip)
    je .Luser_cleanup_cli
    cmpq $5,fr_user_switch_count(%rip)
    jb .Luser_cleanup_cli
    /* 1 = deliberate memory fault, 2 = clean exit,
     * 3 = unknown INT80, 4 = valid write/ticks/exit,
     * 5 = rejected supervisor pointer. In all cases B remains alive.
     */
    movq fr_user_mode(%rip),%rax
    testq %rax,%rax
    jz .Luser_success
    cmpq $3,fr_user_states+16(%rip)
    jne .Luser_cleanup_cli
    cmpq $1,%rax
    jne .Luser_check_user_exit
    cmpq $4,fr_user_states+8(%rip)
    jne .Luser_cleanup_cli
    cmpq $0x10000,fr_user_fault_addr(%rip)
    jne .Luser_cleanup_cli
    jmp .Luser_success
.Luser_check_user_exit:
    cmpq $2,%rax
    jne .Luser_check_invalid
    cmpq $2,fr_user_states+8(%rip)
    jne .Luser_cleanup_cli
    jmp .Luser_success
.Luser_check_invalid:
    cmpq $4,%rax
    jne .Luser_invalid_assert
    cmpq $2,fr_user_states+8(%rip)
    jne .Luser_cleanup_cli
    cmpq $0,fr_user_fault_addr(%rip)
    jne .Luser_cleanup_cli
    jmp .Luser_success
.Luser_invalid_assert:
    cmpq $4,fr_user_states+8(%rip)
    jne .Luser_cleanup_cli
    cmpq $0,fr_user_fault_addr(%rip)
    jne .Luser_cleanup_cli
    cmpq $3,%rax
    jne .Luser_check_validwrite
    cmpq $99,fr_user_syscall_code(%rip)
    jne .Luser_cleanup_cli
    jmp .Luser_success
.Luser_check_validwrite:
    cmpq $4,%rax
    jne .Luser_check_badptr
    /* The valid console/sysclock program should normally exit with state
     * 2; this comparison is handled before common invalid-call paths.
     */
    jmp .Luser_cleanup_cli
.Luser_check_badptr:
    cmpq $5,%rax
    jne .Luser_cleanup_cli
    cmpq $-2,fr_user_syscall_code(%rip)
    jne .Luser_cleanup_cli
.Luser_success:
    movq $1,%r15
.Luser_cleanup_cli:
    sti

.Luser_cleanup:
    movq $0,fr_user_enabled(%rip)
    movq $0,fr_user_current(%rip)
    movq $0x9000,%rax
    movq %rax,%cr3
    xorq %rbx,%rbx
.Luser_retire_owner:
    cmpq $2,%rbx
    jae .Luser_end
    leaq fr_space_generations(%rip),%r8
    movq (%r8,%rbx,8),%r13
    testq %r13,%r13
    jz .Luser_retire_next
    leaq 1(%rbx),%r12
    call fr_space_retire
    addq %rax,fr_user_reclaimed(%rip)
.Luser_retire_next:
    incq %rbx
    jmp .Luser_retire_owner
.Luser_end:
    cmpq $1,%r15
    jne .Luser_clear_busy
    cmpq $14,fr_user_reclaimed(%rip)
    je .Luser_clear_busy
    xorq %r15,%r15
.Luser_clear_busy:
    movq $0,fr_user_busy(%rip)
.Luser_done:
    movq %r15,%rdi
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbp
    popq %rbx
    movq $1,%rsi
    jmp fr_push

.global fr_user_sched_probe
fr_user_sched_probe:
    xorl %edi,%edi
    jmp fr_user_run
.global fr_user_sched_fault_probe
fr_user_sched_fault_probe:
    movq $1,%rdi
    jmp fr_user_run
.global fr_user_sched_exit_probe
fr_user_sched_exit_probe:
    movq $2,%rdi
    jmp fr_user_run
.global fr_user_sched_invalid_probe
fr_user_sched_invalid_probe:
    movq $3,%rdi
    jmp fr_user_run
.global fr_user_sched_syscall_probe
fr_user_sched_syscall_probe:
    movq $4,%rdi
    jmp fr_user_run
.global fr_user_sched_badptr_probe
fr_user_sched_badptr_probe:
    movq $5,%rdi
    jmp fr_user_run
.global fr_user_sched_a_steps
fr_user_sched_a_steps:
    movq fr_user_a_progress(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_user_sched_b_steps
fr_user_sched_b_steps:
    movq fr_user_b_progress(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_user_sched_a_state
fr_user_sched_a_state:
    movq fr_user_states+8(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_user_sched_b_state
fr_user_sched_b_state:
    movq fr_user_states+16(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_user_sched_switches
fr_user_sched_switches:
    movq fr_user_switch_count(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_user_sched_reclaimed
fr_user_sched_reclaimed:
    movq fr_user_reclaimed(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
W',16(%rdi)
    leaq 16(%rdi),%rdi
    movl $1,%esi
    movl $1,%eax
    int $0x80
    cmpq $1,%rax
    jne .Luser_a_write_fail
    movl $2,%eax
    int $0x80
    testq %rax,%rax
    jz .Luser_a_write_fail
    movl $0,%eax
    int $0x80
.Luser_a_write_fail:
    ud2
fr_user_code_a_write_end:
fr_user_code_a_invalid_pointer:
    movabsq $0x40001000,%rdi
    movl $1000,%ecx
.Luser_a_badptr_loop:
    incl (%rdi)
    decl %ecx
    jnz .Luser_a_badptr_loop
    movabsq $0x10000,%rdi
    movq $3,%rsi
    movq $1,%rax
    int $0x80
    ud2
fr_user_code_a_invalid_pointer_end:
fr_user_code_b:
    movabsq $0x40001000,%rdi
.Luser_b_loop:
    addl $2,(%rdi)
    pause
    jmp .Luser_b_loop
fr_user_code_b_end:

/* Build synthetic *user-mode* saved IRQ frame for one kernel RSP0 page.
 * rdi = physical kernel stack top, rsi = user RIP, rdx = user RSP.
 */
fr_user_frame:
    subq $40,%rdi
    movq %rsi,(%rdi)
    movq $0x23,8(%rdi)
    movq $0x202,16(%rdi)
    movq %rdx,24(%rdi)
    movq $0x2b,32(%rdi)
    subq $120,%rdi
    movq %rdi,%r8
    movl $15,%ecx
    xorl %eax,%eax
    cld
    rep stosq
    movq %r8,%rax
    ret

/* Shared setup for the two explicit CLI experiments. Must preserve host
 * CPU callee-saved regs and never allow a second concurrent launch.
 */
fr_user_run:
    pushq %rbx
    pushq %rbp
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    movq %rdi,fr_user_mode(%rip)
    xorq %r15,%r15
    cmpq $1,fr_irq_running(%rip)
    jne .Luser_done
    cmpq $1,fr_ring3_done(%rip)
    jne .Luser_done
    cmpq $0,fr_ring3_active(%rip)
    jne .Luser_done
    cmpq $0,fr_space_active(%rip)
    jne .Luser_done
    cmpq $0,fr_preempt_enabled(%rip)
    jne .Luser_done
    cmpq $0,fr_user_busy(%rip)
    jne .Luser_done
    movq %cr3,%rax
    andq $-4096,%rax
    cmpq $0x9000,%rax
    jne .Luser_done
    call fr_e820_arena_usable
    testl %eax,%eax
    jz .Luser_done
    movq $1,fr_user_busy(%rip)
    movq $0,fr_user_fault_addr(%rip)
    movq $-1,fr_user_syscall_code(%rip)
    movq $0,fr_user_switch_count(%rip)
    movq $0,fr_user_reclaimed(%rip)
    movq $0,fr_user_states+8(%rip)
    movq $0,fr_user_states+16(%rip)
    movq $0,fr_user_a_progress(%rip)
    movq $0,fr_user_b_progress(%rip)
    /* Reacquire generation-tagged leases and independent page tables. */
    movq $1,%rdi
    movq $1,%rsi
    call fr_push
    call fr_lease_begin
    call fr_pop
    testq %rax,%rax
    jz .Luser_cleanup
    movq %rax,fr_space_generations(%rip)
    movq $2,%rdi
    movq $1,%rsi
    call fr_push
    call fr_lease_begin
    call fr_pop
    testq %rax,%rax
    jz .Luser_cleanup
    movq %rax,fr_space_generations+8(%rip)

    xorq %rbx,%rbx
.Luser_allocate_owner:
    cmpq $2,%rbx
    jae .Luser_maps
    leaq 1(%rbx),%r12
    leaq fr_space_generations(%rip),%r8
    movq (%r8,%rbx,8),%r13
    xorq %r14,%r14
.Luser_allocate_six:
    cmpq $6,%r14
    jae .Luser_allocate_kernel_stack
    call fr_space_take
    testq %rax,%rax
    jz .Luser_cleanup
    movq %rbx,%rcx
    imulq $6,%rcx
    addq %r14,%rcx
    leaq fr_space_pages(%rip),%r8
    movq %rax,(%r8,%rcx,8)
    incq %r14
    jmp .Luser_allocate_six
.Luser_allocate_kernel_stack:
    call fr_space_take
    testq %rax,%rax
    jz .Luser_cleanup
    leaq fr_user_kstacks(%rip),%r8
    movq %rax,(%r8,%rbx,8)
    incq %rbx
    jmp .Luser_allocate_owner

.Luser_maps:
    xorq %rbx,%rbx
.Luser_map_owner:
    cmpq $2,%rbx
    jae .Luser_write_code
    movq %rbx,%rcx
    imulq $48,%rcx
    leaq fr_space_pages(%rip),%r8
    addq %rcx,%r8
    movq 0(%r8),%r9
    movq 8(%r8),%r10
    movq 16(%r8),%r11
    movq 24(%r8),%r12
    movq 32(%r8),%r13
    movq 40(%r8),%r14
    movq %r10,%rax
    orq $7,%rax
    movq %rax,(%r9)       /* private PML4[0] */
    movq 0xa000,%rax
    testq $4,%rax
    jnz .Luser_cleanup
    testq $1,%rax
    jz .Luser_cleanup
    movq %rax,(%r10)      /* supervisor-only kernel 0..1GiB */
    movq %r11,%rax
    orq $7,%rax
    movq %rax,8(%r10)     /* user-region PDPT[1] */
    movq %r12,%rax
    orq $7,%rax
    movq %rax,(%r11)
    movq %r13,%rax
    orq $5,%rax
    movq %rax,(%r12)      /* user R/X code */
    movq %r14,%rax
    orq $7,%rax
    movq %rax,8(%r12)     /* user RW stack */
    leaq fr_space_roots(%rip),%r8
    movq %r9,(%r8,%rbx,8)
    incq %rbx
    jmp .Luser_map_owner

.Luser_write_code:
    leaq fr_space_pages(%rip),%rbx
    movq 32(%rbx),%rdi
    cmpq $1,fr_user_mode(%rip)
    jne .Luser_write_a_normal
    leaq fr_user_code_a_fault(%rip),%rsi
    movl $(fr_user_code_a_fault_end-fr_user_code_a_fault),%ecx
    jmp .Luser_copy_a
.Luser_write_a_normal:
    leaq fr_user_code_a(%rip),%rsi
    movl $(fr_user_code_a_end-fr_user_code_a),%ecx
.Luser_copy_a:
    cld
    rep movsb
    leaq fr_user_code_b(%rip),%rsi
    movq 80(%rbx),%rdi
    movl $(fr_user_code_b_end-fr_user_code_b),%ecx
    rep movsb

    leaq fr_user_kstacks(%rip),%rbx
    movq (%rbx),%rdi
    addq $4096,%rdi
    movq $0x40000000,%rsi
    movq $0x40002000,%rdx
    call fr_user_frame
    movq %rax,fr_user_saved_rsp+8(%rip)
    movq 8(%rbx),%rdi
    addq $4096,%rdi
    movq $0x40000000,%rsi
    movq $0x40002000,%rdx
    call fr_user_frame
    movq %rax,fr_user_saved_rsp+16(%rip)

    movq $1,fr_user_states+8(%rip)
    movq $1,fr_user_states+16(%rip)
    movq $0,fr_user_current(%rip)
    movq fr_irq_tick_count(%rip),%rax
    addq $80,%rax
    movq %rax,fr_user_target_tick(%rip)
    movq $1,fr_user_enabled(%rip)
    sti
.Luser_host_spin:
    movq fr_irq_tick_count(%rip),%rax
    cmpq fr_user_target_tick(%rip),%rax
    jb .Luser_host_spin
    cli
    movq $0,fr_user_enabled(%rip)
    movq $0x9000,%rax
    movq %rax,%cr3
    cmpq $1,fr_user_states+8(%rip)
    jne .Luser_check_b_state
    movq $3,fr_user_states+8(%rip)
.Luser_check_b_state:
    cmpq $1,fr_user_states+16(%rip)
    jne .Luser_verify
    movq $3,fr_user_states+16(%rip)
.Luser_verify:
    movq fr_space_pages+40(%rip),%rax
    movl (%rax),%r10d
    movq %r10,fr_user_a_progress(%rip)
    movq fr_space_pages+88(%rip),%rax
    movl (%rax),%r10d
    movq %r10,fr_user_b_progress(%rip)
    cmpq $0,fr_user_a_progress(%rip)
    je .Luser_cleanup_cli
    cmpq $0,fr_user_b_progress(%rip)
    je .Luser_cleanup_cli
    cmpq $5,fr_user_switch_count(%rip)
    jb .Luser_cleanup_cli
    cmpq $1,fr_user_mode(%rip)
    jne .Luser_success
    cmpq $4,fr_user_states+8(%rip)
    jne .Luser_cleanup_cli
    cmpq $0x10000,fr_user_fault_addr(%rip)
    jne .Luser_cleanup_cli
    cmpq $3,fr_user_states+16(%rip)
    jne .Luser_cleanup_cli
.Luser_success:
    movq $1,%r15
.Luser_cleanup_cli:
    sti

.Luser_cleanup:
    movq $0,fr_user_enabled(%rip)
    movq $0,fr_user_current(%rip)
    movq $0x9000,%rax
    movq %rax,%cr3
    xorq %rbx,%rbx
.Luser_retire_owner:
    cmpq $2,%rbx
    jae .Luser_end
    leaq fr_space_generations(%rip),%r8
    movq (%r8,%rbx,8),%r13
    testq %r13,%r13
    jz .Luser_retire_next
    leaq 1(%rbx),%r12
    call fr_space_retire
    addq %rax,fr_user_reclaimed(%rip)
.Luser_retire_next:
    incq %rbx
    jmp .Luser_retire_owner
.Luser_end:
    cmpq $1,%r15
    jne .Luser_clear_busy
    cmpq $14,fr_user_reclaimed(%rip)
    je .Luser_clear_busy
    xorq %r15,%r15
.Luser_clear_busy:
    movq $0,fr_user_busy(%rip)
.Luser_done:
    movq %r15,%rdi
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbp
    popq %rbx
    movq $1,%rsi
    jmp fr_push

.global fr_user_sched_probe
fr_user_sched_probe:
    xorl %edi,%edi
    jmp fr_user_run
.global fr_user_sched_fault_probe
fr_user_sched_fault_probe:
    movq $1,%rdi
    jmp fr_user_run
.global fr_user_sched_a_steps
fr_user_sched_a_steps:
    movq fr_user_a_progress(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_user_sched_b_steps
fr_user_sched_b_steps:
    movq fr_user_b_progress(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_user_sched_a_state
fr_user_sched_a_state:
    movq fr_user_states+8(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_user_sched_b_state
fr_user_sched_b_state:
    movq fr_user_states+16(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_user_sched_switches
fr_user_sched_switches:
    movq fr_user_switch_count(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_user_sched_reclaimed
fr_user_sched_reclaimed:
    movq fr_user_reclaimed(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
