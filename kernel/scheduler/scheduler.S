/* FrancOS bounded trusted native-JIT preemption. Two CPU/rational stacks,
 * one host slot, 120 PIT ticks. No general isolation, shared-register
 * virtualization, FPU/SIMD saving, or exception recovery is claimed.
 * These ABI words are linked into the mutable dictionary at kernel startup.
 */
.section .rodata
.Ltask_run_name: .asciz "task-preempt-run"
.Ltask_ainc_name: .asciz "task-inc-a"
.Ltask_binc_name: .asciz "task-inc-b"
.Ltask_statea_name: .asciz "task-state-a"
.Ltask_stateb_name: .asciz "task-state-b"
.Ltask_generation_name: .asciz "task-generation"
.Ltask_local_read_name: .asciz "task-local@"
.Ltask_local_write_name: .asciz "task-local!"
.Ltask_local_a_name: .asciz "task-local-a0"
.Ltask_local_b_name: .asciz "task-local-b0"
.Le820_count_name: .asciz "e820-count"
.Le820_base_name: .asciz "e820-base"
.Le820_length_name: .asciz "e820-length"
.Le820_type_name: .asciz "e820-type"
.Le820_arena_name: .asciz "page-arena-safe?"
.Lproc_probe_name: .asciz "process-fault-probe"
.Lproc_a_state_name: .asciz "process-a-state"
.Lproc_b_state_name: .asciz "process-b-state"
.Lproc_b_steps_name: .asciz "process-b-steps"
.Lproc_survivor_name: .asciz "process-survived?"
.Llease_begin_name: .asciz "proc-lease-begin"
.Llease_alloc_name: .asciz "proc-lease-alloc"
.Llease_free_name: .asciz "proc-lease-free"
.Llease_end_name: .asciz "proc-lease-end"
.Lspace_probe_name: .asciz "space-probe"
.Lspace_a_name: .asciz "space-root-a"
.Lspace_b_name: .asciz "space-root-b"
.Lspace_sa_name: .asciz "space-state-a"
.Lspace_sb_name: .asciz "space-state-b"
.Lspace_fault_name: .asciz "space-fault-address"
.Lspace_reclaim_name: .asciz "space-reclaimed"
.Luser_probe_name: .asciz "user-preempt-probe"
.Luser_fault_name: .asciz "user-preempt-fault-probe"
.Luser_a_name: .asciz "user-preempt-a-steps"
.Luser_b_name: .asciz "user-preempt-b-steps"
.Luser_sa_name: .asciz "user-preempt-a-state"
.Luser_sb_name: .asciz "user-preempt-b-state"
.Luser_switch_name: .asciz "user-preempt-switches"
.Luser_reclaim_name: .asciz "user-preempt-reclaimed"
.Luser_exit_name: .asciz "user-preempt-exit-probe"
.Luser_invalid_name: .asciz "user-preempt-invalid-probe"
.Luser_syscall_name: .asciz "user-preempt-syscall-probe"
.Luser_badptr_name: .asciz "user-preempt-badptr-probe"
.Lcompiled_stage_name: .asciz "user-code-stage"
.Lcompiled_probe_name: .asciz "user-compiled-probe"
.Lcompiled_relaunch_name: .asciz "user-compiled-relaunch"
.Lcompiled_a_kind_name: .asciz "user-compiled-a-kind"
.Lcompiled_b_kind_name: .asciz "user-compiled-b-kind"
.Lpkg_raw_sha_name: .asciz "pkg-sha256"
.Lsha_long_name: .asciz "sha256-long"
.section .data
.balign 8
/* Linked dictionary nodes: next, name, code. First next is set at boot. */
fr_task_dict_run: .quad 0, .Ltask_run_name, fr_task_run
fr_task_dict_ainc: .quad fr_task_dict_run, .Ltask_ainc_name, fr_task_inc_a
fr_task_dict_binc: .quad fr_task_dict_ainc, .Ltask_binc_name, fr_task_inc_b
fr_task_dict_statea: .quad fr_task_dict_binc, .Ltask_statea_name, fr_task_state_a
fr_task_dict_stateb: .quad fr_task_dict_statea, .Ltask_stateb_name, fr_task_state_b
fr_task_dict_localread: .quad fr_task_dict_stateb, .Ltask_local_read_name, fr_task_local_read
fr_task_dict_localwrite: .quad fr_task_dict_localread, .Ltask_local_write_name, fr_task_local_write
fr_task_dict_locala: .quad fr_task_dict_localwrite, .Ltask_local_a_name, fr_task_local_a0
fr_task_dict_localb: .quad fr_task_dict_locala, .Ltask_local_b_name, fr_task_local_b0
fr_task_dict_generation: .quad fr_task_dict_localb, .Ltask_generation_name, fr_task_generation_word
fr_task_dict_e820_count: .quad fr_task_dict_generation, .Le820_count_name, fr_e820_count
fr_task_dict_e820_base: .quad fr_task_dict_e820_count, .Le820_base_name, fr_e820_base
fr_task_dict_e820_length: .quad fr_task_dict_e820_base, .Le820_length_name, fr_e820_length
fr_task_dict_e820_type: .quad fr_task_dict_e820_length, .Le820_type_name, fr_e820_type
fr_task_dict_e820_arena: .quad fr_task_dict_e820_type, .Le820_arena_name, fr_e820_arena_word
fr_task_dict_proc_probe: .quad fr_task_dict_e820_arena, .Lproc_probe_name, fr_proc_probe
fr_task_dict_proc_a: .quad fr_task_dict_proc_probe, .Lproc_a_state_name, fr_proc_state_a
fr_task_dict_proc_b: .quad fr_task_dict_proc_a, .Lproc_b_state_name, fr_proc_state_b
fr_task_dict_proc_steps: .quad fr_task_dict_proc_b, .Lproc_b_steps_name, fr_proc_b_steps
fr_task_dict_proc_survivor: .quad fr_task_dict_proc_steps, .Lproc_survivor_name, fr_proc_survivor_ok
fr_task_dict_lease_begin: .quad fr_task_dict_proc_survivor, .Llease_begin_name, fr_lease_begin
fr_task_dict_lease_alloc: .quad fr_task_dict_lease_begin, .Llease_alloc_name, fr_lease_alloc
fr_task_dict_lease_free: .quad fr_task_dict_lease_alloc, .Llease_free_name, fr_lease_free
fr_task_dict_lease_end: .quad fr_task_dict_lease_free, .Llease_end_name, fr_lease_end
fr_task_dict_space_probe: .quad fr_task_dict_lease_end, .Lspace_probe_name, fr_space_probe
fr_task_dict_space_a: .quad fr_task_dict_space_probe, .Lspace_a_name, fr_space_root_a
fr_task_dict_space_b: .quad fr_task_dict_space_a, .Lspace_b_name, fr_space_root_b
fr_task_dict_space_sa: .quad fr_task_dict_space_b, .Lspace_sa_name, fr_space_state_a
fr_task_dict_space_sb: .quad fr_task_dict_space_sa, .Lspace_sb_name, fr_space_state_b
fr_task_dict_space_fault: .quad fr_task_dict_space_sb, .Lspace_fault_name, fr_space_fault_addr
fr_task_dict_space_reclaim: .quad fr_task_dict_space_fault, .Lspace_reclaim_name, fr_space_reclaimed_count
fr_task_dict_user_probe: .quad fr_task_dict_space_reclaim, .Luser_probe_name, fr_user_sched_probe
fr_task_dict_user_fault: .quad fr_task_dict_user_probe, .Luser_fault_name, fr_user_sched_fault_probe
fr_task_dict_user_a: .quad fr_task_dict_user_fault, .Luser_a_name, fr_user_sched_a_steps
fr_task_dict_user_b: .quad fr_task_dict_user_a, .Luser_b_name, fr_user_sched_b_steps
fr_task_dict_user_sa: .quad fr_task_dict_user_b, .Luser_sa_name, fr_user_sched_a_state
fr_task_dict_user_sb: .quad fr_task_dict_user_sa, .Luser_sb_name, fr_user_sched_b_state
fr_task_dict_user_switch: .quad fr_task_dict_user_sb, .Luser_switch_name, fr_user_sched_switches
fr_task_dict_user_reclaim: .quad fr_task_dict_user_switch, .Luser_reclaim_name, fr_user_sched_reclaimed
fr_task_dict_user_exit: .quad fr_task_dict_user_reclaim, .Luser_exit_name, fr_user_sched_exit_probe
fr_task_dict_user_invalid: .quad fr_task_dict_user_exit, .Luser_invalid_name, fr_user_sched_invalid_probe
fr_task_dict_user_syscall: .quad fr_task_dict_user_invalid, .Luser_syscall_name, fr_user_sched_syscall_probe
fr_task_dict_badptr: .quad fr_task_dict_user_syscall, .Luser_badptr_name, fr_user_sched_badptr_probe
fr_task_dict_compiled_stage: .quad fr_task_dict_badptr, .Lcompiled_stage_name, fr_user_compiled_stage
fr_task_dict_compiled_probe: .quad fr_task_dict_compiled_stage, .Lcompiled_probe_name, fr_user_compiled_probe
fr_task_dict_compiled_relaunch: .quad fr_task_dict_compiled_probe, .Lcompiled_relaunch_name, fr_user_compiled_relaunch
fr_task_dict_compiled_a_kind: .quad fr_task_dict_compiled_relaunch, .Lcompiled_a_kind_name, fr_user_compiled_a_kind
fr_task_dict_compiled_b_kind: .quad fr_task_dict_compiled_a_kind, .Lcompiled_b_kind_name, fr_user_compiled_b_kind
fr_task_dict_pkg_sha: .quad fr_task_dict_compiled_b_kind, .Lpkg_raw_sha_name, fr_pkg_sha256
fr_task_dict_top: .quad fr_task_dict_pkg_sha, .Lsha_long_name, fr_sha256_long
.section .bss
.balign 8
/* 0:host, 1:worker A, 2:worker B.
 * state=0 unallocated,1 runnable,2 returned,3 timed-out/faulted.
 */
fr_task_states: .skip 24
fr_task_codes: .skip 24
fr_task_generation: .skip 8
fr_task_fault: .skip 8
.balign 16
/* Eight bounded, integer scalar locals per worker (2 x 8 x 8 bytes).
 * This is explicit task-local storage, NOT automatic virtualization of
 * all historical Franc global named registers or arbitrary pointers.
 */
fr_task_locals: .skip 128
.section .text,"ax"
/* rdi=entrypoint, eax=1 iff exact registered JIT definition. */
fr_task_validate:
    cmpq $0x400000,%rdi
    jb .Ltvbad
    cmpq s2_code_next(%rip),%rdi
    jae .Ltvbad
    movq fr_dict_head_ptr(%rip),%rcx
    movl $512,%r8d
.Ltvloop:
    testq %rcx,%rcx
    jz .Ltvbad
    cmpq %rdi,16(%rcx)
    je .Ltvyes
    movq (%rcx),%rcx
    decq %r8
    jnz .Ltvloop
.Ltvbad:
    xorl %eax,%eax
    ret
.Ltvyes:
    movl $1,%eax
    ret

/* Synthetic first IRET resumes here on a private CPU stack. */
fr_task_entry:
    movq fr_preempt_current(%rip),%rax
    cmpq $1,%rax
    jb fr_task_abort_current
    cmpq $2,%rax
    ja fr_task_abort_current
    leaq fr_task_codes(%rip),%rcx
    movq (%rcx,%rax,8),%rax
    call *%rax
    cli
    movq fr_preempt_current(%rip),%rax
    leaq fr_task_states(%rip),%rcx
    movq $2,(%rcx,%rax,8)
    sti
.Ltaskfinished:
    pause
    jmp .Ltaskfinished

/* Fail closed for explicit stack bound violations. Faulting code must not
 * return to the kernel; this does not replace page-fault isolation.
 */
fr_task_abort_current:
    cli
    movq fr_preempt_current(%rip),%rax
    cmpq $1,%rax
    jb .Ltaskhalterr
    cmpq $2,%rax
    ja .Ltaskhalterr
    leaq fr_task_states(%rip),%rcx
    movq $3,(%rcx,%rax,8)
    movq $1,fr_task_fault(%rip)
    sti
.Ltaskerrorloop:
    pause
    jmp .Ltaskerrorloop
.Ltaskhalterr:
    hlt
    jmp .Ltaskhalterr

/* (JIT-A JIT-B -- success). Only trusted words. Both must be distinct
 * defined native JIT functions; requires irq-start and a quiescent scheduler.
 */
.global fr_task_run
fr_task_run:
    pushq %rbx
    pushq %rbp
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    call fr_pop
    cmpq $1,%rdx
    jne .Ltrbad
    movq %rax,%r12
    call fr_pop
    cmpq $1,%rdx
    jne .Ltrbad
    movq %rax,%r13
    cmpq $1,fr_irq_running(%rip)
    jne .Ltrbad
    cmpq $0,fr_preempt_enabled(%rip)
    jne .Ltrbad
    movq %r12,%rdi
    call fr_task_validate
    testl %eax,%eax
    jz .Ltrbad
    movq %r13,%rdi
    call fr_task_validate
    testl %eax,%eax
    jz .Ltrbad
    cmpq %r12,%r13
    je .Ltrbad
    cli
    incq fr_task_generation(%rip)
    movq $0,fr_task_fault(%rip)
    movq $0,fr_preempt_a_counter(%rip)
    movq $0,fr_preempt_b_counter(%rip)
    movq $0,fr_preempt_current(%rip)
    /* New task generation starts with zeroed, independent local storage. */
    leaq fr_task_locals(%rip),%rdi
    movl $16,%ecx
    xorl %eax,%eax
    cld
    rep stosq
    movq $1,fr_task_states(%rip)
    movq $1,fr_task_states+8(%rip)
    movq $1,fr_task_states+16(%rip)
    movq %r13,fr_task_codes+8(%rip)
    movq %r12,fr_task_codes+16(%rip)
    movq ds_ptr(%rip),%rax
    movq %rax,fr_preempt_ds(%rip)
    leaq fr_preempt_data_stacks(%rip),%rax
    movq %rax,fr_preempt_ds+8(%rip)
    addq $16384,%rax
    movq %rax,fr_preempt_ds+16(%rip)
    leaq fr_preempt_a_stack+16384(%rip),%rdi
    leaq fr_task_entry(%rip),%rsi
    call fr_preempt_prepare
    movq %rax,fr_preempt_rsp+8(%rip)
    leaq fr_preempt_b_stack+16384(%rip),%rdi
    leaq fr_task_entry(%rip),%rsi
    call fr_preempt_prepare
    movq %rax,fr_preempt_rsp+16(%rip)
    movq fr_irq_tick_count(%rip),%rax
    addq $120,%rax
    movq %rax,fr_preempt_target_tick(%rip)
    movq $2,fr_preempt_mode(%rip)
    movq $1,fr_preempt_enabled(%rip)
    sti
.Ltrwait:
    pause
    movq fr_irq_tick_count(%rip),%rax
    cmpq fr_preempt_target_tick(%rip),%rax
    jb .Ltrwait
    cli
    movq $0,fr_preempt_enabled(%rip)
    movq $0,fr_preempt_mode(%rip)
    cmpq $1,fr_task_states+8(%rip)
    jne .Ltrretb
    movq $3,fr_task_states+8(%rip)
.Ltrretb:
    cmpq $1,fr_task_states+16(%rip)
    jne .Ltrstop
    movq $3,fr_task_states+16(%rip)
.Ltrstop:
    sti
    cmpq $0,fr_task_fault(%rip)
    jne .Ltrbad
    cmpq $100,fr_preempt_a_counter(%rip)
    jbe .Ltrbad
    cmpq $100,fr_preempt_b_counter(%rip)
    jbe .Ltrbad
    movq $1,%rbx
    jmp .Ltrfinish
.Ltrbad:
    xorq %rbx,%rbx
.Ltrfinish:
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbp
    movq %rbx,%rdi
    popq %rbx
    movq $1,%rsi
    jmp fr_push

/* Explicit counter hooks are used only for measurable QEMU JIT worker proof.
 * Franc-generated loops perform real Rat stack arithmetic on each iteration.
 */
fr_task_inc_a:
    incq fr_preempt_a_counter(%rip)
    ret
fr_task_inc_b:
    incq fr_preempt_b_counter(%rip)
    ret
fr_task_state_a:
    movq fr_task_states+8(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
fr_task_state_b:
    movq fr_task_states+16(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
fr_task_generation_word:
    movq fr_task_generation(%rip),%rdi
    movq $1,%rsi
    jmp fr_push

/* Native Franc scalar locals. Index range 0..7. Only worker slots 1/2
 * may read/write; the host receives zero for invalid/unowned access.
 * Stack contracts: (index -- value) and (value index -- success).
 * Values are exact signed i64 integers, canonical denominator 1.
 */
fr_task_local_read:
    call fr_pop
    cmpq $1,%rdx
    jne .Ltlreadbad
    cmpq $8,%rax
    jae .Ltlreadbad
    movq %rax,%r10
    movq fr_preempt_current(%rip),%r11
    cmpq $1,%r11
    jb .Ltlreadbad
    cmpq $2,%r11
    ja .Ltlreadbad
    decq %r11
    shlq $6,%r11
    leaq fr_task_locals(%rip),%r8
    addq %r11,%r8
    movq (%r8,%r10,8),%rdi
    movq $1,%rsi
    jmp fr_push
.Ltlreadbad:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

fr_task_local_write:
    call fr_pop
    cmpq $1,%rdx
    jne .Ltlwritebad
    cmpq $8,%rax
    jae .Ltlwritebad
    movq %rax,%r10
    call fr_pop
    cmpq $1,%rdx
    jne .Ltlwritebad
    movq fr_preempt_current(%rip),%r11
    cmpq $1,%r11
    jb .Ltlwritebad
    cmpq $2,%r11
    ja .Ltlwritebad
    decq %r11
    shlq $6,%r11
    leaq fr_task_locals(%rip),%r8
    addq %r11,%r8
    movq %rax,(%r8,%r10,8)
    movq $1,%rdi
    movq $1,%rsi
    jmp fr_push
.Ltlwritebad:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

/* Read-only post-run test inspection of per-worker local slot 0. */
fr_task_local_a0:
    movq fr_task_locals(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
fr_task_local_b0:
    movq fr_task_locals+64(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
