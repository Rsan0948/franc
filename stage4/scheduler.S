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
.section .data
.balign 8
/* Linked dictionary nodes: next, name, code. First next is set at boot. */
fr_task_dict_run: .quad 0, .Ltask_run_name, fr_task_run
fr_task_dict_ainc: .quad fr_task_dict_run, .Ltask_ainc_name, fr_task_inc_a
fr_task_dict_binc: .quad fr_task_dict_ainc, .Ltask_binc_name, fr_task_inc_b
fr_task_dict_statea: .quad fr_task_dict_binc, .Ltask_statea_name, fr_task_state_a
fr_task_dict_stateb: .quad fr_task_dict_statea, .Ltask_stateb_name, fr_task_state_b
fr_task_dict_top: .quad fr_task_dict_stateb, .Ltask_generation_name, fr_task_generation_word
.section .bss
.balign 8
/* 0:host, 1:worker A, 2:worker B.
 * state=0 unallocated,1 runnable,2 returned,3 timed-out/faulted.
 */
fr_task_states: .skip 24
fr_task_codes: .skip 24
fr_task_generation: .skip 8
fr_task_fault: .skip 8
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
