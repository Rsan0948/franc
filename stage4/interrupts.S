/* FrancOS x86-64 interrupt foundation (BIOS QEMU proof, not a scheduler).
 * 256 ring-0 interrupt gates; unexpected vectors halt with serial 'X'.
 * IRQ0 is a 100 Hz PIT timer with PIC remapped to vectors 32..47.
 * All registers touched by IRQ0 are saved; RFLAGS is restored by iretq.
 * No Ring 3, preemption, nested IRQs or fault recovery is claimed.
 * Enable only explicitly through the native Franc 'irq-start' primitive.
 */
.code64
.section .bss
.balign 16
fr_irq_idt: .skip 4096
.balign 8
fr_irq_tick_count: .skip 8
fr_irq_running: .skip 8
/* Single CPU, ring-0, assembly-only preemption proof. This is not a
 * general Franc fiber scheduler; threads do not touch shared ds_ptr.
 * This proof saves/restores ds_ptr, but a general scheduler still requires
 * full task descriptors, rational stack limits, register ownership, FPU/SIMD
 * state, error handling, and explicit lifecycle/critical-section controls.
 */
.balign 16
fr_preempt_a_stack: .skip 16384
fr_preempt_b_stack: .skip 16384
.balign 8
fr_preempt_rsp: .skip 24 /* [host, asm A, asm B] interrupted RSP */
fr_preempt_ds: .skip 24  /* per-context Franc rational stack cursors */
.balign 16
fr_preempt_data_stacks: .skip 32768 /* two private 16 KiB Rat stacks */
fr_preempt_current: .skip 8
fr_preempt_enabled: .skip 8
fr_preempt_mode: .skip 8 /* 0=off, 1=assembly, 2=Franc JIT */
fr_preempt_target_tick: .skip 8
fr_preempt_a_counter: .skip 8
fr_preempt_b_counter: .skip 8
.section .data
.balign 8
fr_irq_idtr:
    .word 4095
    .quad 0

.section .text,"ax"
.global fr_irq_start
fr_irq_start:
    cmpq $1,fr_irq_running(%rip)
    je .Lirq_already
    cli
    /* Bind gates to the active CS selector, not an assumed firmware GDT. */
    movw %cs,%dx
    leaq fr_irq_idt(%rip),%r8
    leaq fr_irq_fault(%rip),%r9
    xorq %rcx,%rcx
.Lirq_gate_loop:
    movw %r9w,0(%r8)
    movw %dx,2(%r8)
    movw $0x8e00,4(%r8)
    movq %r9,%rax
    shrq $16,%rax
    movw %ax,6(%r8)
    movq %r9,%rax
    shrq $32,%rax
    movl %eax,8(%r8)
    movl $0,12(%r8)
    addq $16,%r8
    incq %rcx
    cmpq $256,%rcx
    jne .Lirq_gate_loop
    /* PIC IRQ0 -> interrupt vector 32. */
    leaq fr_irq_idt+512(%rip),%r8
    leaq fr_irq_timer(%rip),%r9
    movw %r9w,0(%r8)
    movw %dx,2(%r8)
    movw $0x8e00,4(%r8)
    movq %r9,%rax
    shrq $16,%rax
    movw %ax,6(%r8)
    movq %r9,%rax
    shrq $32,%rax
    movl %eax,8(%r8)
    movl $0,12(%r8)
    leaq fr_irq_idt(%rip),%rax
    movq %rax,fr_irq_idtr+2(%rip)
    lidt fr_irq_idtr(%rip)
    movq $0,fr_irq_tick_count(%rip)
    /* PIC ICW1: edge triggered, cascade, ICW4 follows. */
    movb $0x11,%al
    outb %al,$0x20
    outb %al,$0xa0
    /* ICW2: mapped IRQ vectors 0x20..0x2f. */
    movb $0x20,%al
    outb %al,$0x21
    movb $0x28,%al
    outb %al,$0xa1
    /* ICW3 cascade configuration. */
    movb $4,%al
    outb %al,$0x21
    movb $2,%al
    outb %al,$0xa1
    /* ICW4: 8086 mode, explicit EOIs. */
    movb $1,%al
    outb %al,$0x21
    outb %al,$0xa1
    /* Unmask master IRQ0 only; mask slave entirely. */
    movb $0xfe,%al
    outb %al,$0x21
    movb $0xff,%al
    outb %al,$0xa1
    /* PIT channel 0, mode 2, 1193182 / 11932 ~= 100 Hz. */
    movb $0x34,%al
    outb %al,$0x43
    movb $0x9c,%al
    outb %al,$0x40
    movb $0x2e,%al
    outb %al,$0x40
    movq $1,fr_irq_running(%rip)
    sti
    movq $1,%rdi
    movq $1,%rsi
    jmp fr_push
.Lirq_already:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

.global fr_irq_ticks
fr_irq_ticks:
    movq fr_irq_tick_count(%rip),%rdi
    movq $1,%rsi
    jmp fr_push

.global fr_irq_stop
fr_irq_stop:
    cli
    movb $0xff,%al
    outb %al,$0x21
    outb %al,$0xa1
    movq $0,fr_preempt_enabled(%rip)
    movq $0,fr_preempt_mode(%rip)
    movq $0,fr_irq_running(%rip)
    movq fr_irq_tick_count(%rip),%rdi
    movq $1,%rsi
    jmp fr_push

fr_irq_timer:
    /* Save the complete integer register file before task selection.
     * Hardware already pushed RIP, CS, RFLAGS at same privilege level.
     * The handler NEVER uses the Franc rational stack or heap.
     */
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
    incq fr_irq_tick_count(%rip)
    movw $0x20,%dx
    movb $0x20,%al
    outb %al,%dx
    cmpq $1,fr_preempt_enabled(%rip)
    jne .Lirq_restore
    movq fr_preempt_current(%rip),%rax
    leaq fr_preempt_rsp(%rip),%rcx
    leaq fr_preempt_ds(%rip),%r8
    movq %rsp,(%rcx,%rax,8)
    movq ds_ptr(%rip),%r9
    movq %r9,(%r8,%rax,8)
    incq %rax
    cmpq $3,%rax
    jb .Lirq_next_chosen
    xorq %rax,%rax
.Lirq_next_chosen:
    /* Skip Franc tasks that returned or failed, always retaining host. */
    cmpq $2,fr_preempt_mode(%rip)
    jne .Lirq_chosen
    testq %rax,%rax
    jz .Lirq_chosen
    leaq fr_task_states(%rip),%r10
    cmpq $1,(%r10,%rax,8)
    je .Lirq_chosen
    incq %rax
    cmpq $3,%rax
    jb .Lirq_next_chosen
    xorq %rax,%rax
    jmp .Lirq_next_chosen
.Lirq_chosen:
    movq %rax,fr_preempt_current(%rip)
    movq (%rcx,%rax,8),%rsp
    movq (%r8,%rax,8),%r9
    movq %r9,ds_ptr(%rip)
.Lirq_restore:
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %r11
    popq %r10
    popq %r9
    popq %r8
    popq %rbp
    popq %rdi
    popq %rsi
    popq %rdx
    popq %rcx
    popq %rbx
    popq %rax
    iretq

/* Build a fresh synthetic interrupt frame at the top of an isolated
 * 16 KiB kernel stack. Inputs: rdi=top-of-stack, rsi=worker RIP.
 * Outputs: rax=saved rsp pointing at 15 saved zeroed GPRs,
 * followed by RIP, CS, RFLAGS, previous RSP and SS.
 */
fr_preempt_prepare:
    /* IA-32e unconditionally pushes old SS:RSP on all interrupts.
     * IRETQ unconditionally restores them, even for CPL0 -> CPL0.
     * A synthetic 3-slot frame leaves workers on an invalid stack.
     */
    movq %rdi,%r8
    subq $40,%rdi
    movq %rsi,0(%rdi)
    movw %cs,%ax
    movzwq %ax,%rax
    movq %rax,8(%rdi)
    movq $0x202,16(%rdi)
    movq %r8,24(%rdi)
    movw %ss,%ax
    movzwq %ax,%rax
    movq %rax,32(%rdi)
    subq $120,%rdi
    movq %rdi,%r9
    movl $15,%ecx
    xorl %eax,%eax
    cld
    rep stosq
    movq %r9,%rax
    ret

/* Never yielding, mutually preempted CPU-bound assembly workers.
 * They touch only their own counter and private Franc rational stack;
 * their instruction pointers are resumed from IRQ frames, not yields.
 */
/* Exercise the same rational stack primitives used by native Franc code.
 * Each never-yielding worker pushes and pops an integer on its private
 * Rat stack on EVERY iteration; a lost ds_ptr context is a hard failure.
 * This is still assembly-only workload code, not arbitrary Franc JIT tasks.
 */
fr_preempt_worker_a:
    movq fr_preempt_a_counter(%rip),%rdi
    movq $1,%rsi
    call fr_push
    call fr_pop
    cmpq $1,%rdx
    jne .Lpreempt_corrupt
    incq %rax
    movq %rax,fr_preempt_a_counter(%rip)
    pause
    jmp fr_preempt_worker_a
fr_preempt_worker_b:
    movq fr_preempt_b_counter(%rip),%rdi
    movq $1,%rsi
    call fr_push
    call fr_pop
    cmpq $1,%rdx
    jne .Lpreempt_corrupt
    incq %rax
    movq %rax,fr_preempt_b_counter(%rip)
    pause
    jmp fr_preempt_worker_b
.Lpreempt_corrupt:
    ud2

/* (-- did-both-progress). Requires irq-start first; bounded to 120 PIT
 * ticks. Host is runnable slot 0, workers are slots 1 and 2.
 * All contexts stay kernel ring0; no user-mode memory isolation.
 */
.global fr_preempt_demo
fr_preempt_demo:
    cmpq $1,fr_irq_running(%rip)
    jne .Lpreempt_bad
    cmpq $0,fr_preempt_enabled(%rip)
    jne .Lpreempt_bad
    cli
    movq $0,fr_preempt_a_counter(%rip)
    movq $0,fr_preempt_b_counter(%rip)
    movq $0,fr_preempt_current(%rip)
    movq $1,fr_preempt_mode(%rip)
    /* Slot 0 retains the interrupted Franc REPL stack. */
    movq ds_ptr(%rip),%rax
    movq %rax,fr_preempt_ds(%rip)
    leaq fr_preempt_data_stacks(%rip),%rax
    movq %rax,fr_preempt_ds+8(%rip)
    addq $16384,%rax
    movq %rax,fr_preempt_ds+16(%rip)
    leaq fr_preempt_a_stack+16384(%rip),%rdi
    leaq fr_preempt_worker_a(%rip),%rsi
    call fr_preempt_prepare
    movq %rax,fr_preempt_rsp+8(%rip)
    leaq fr_preempt_b_stack+16384(%rip),%rdi
    leaq fr_preempt_worker_b(%rip),%rsi
    call fr_preempt_prepare
    movq %rax,fr_preempt_rsp+16(%rip)
    movq fr_irq_tick_count(%rip),%rax
    addq $120,%rax
    movq %rax,fr_preempt_target_tick(%rip)
    movq $1,fr_preempt_enabled(%rip)
    sti
.Lpreempt_wait:
    pause
    movq fr_irq_tick_count(%rip),%rax
    cmpq fr_preempt_target_tick(%rip),%rax
    jb .Lpreempt_wait
    cli
    /* Host is executing, so no worker context can still be running. */
    movq $0,fr_preempt_enabled(%rip)
    movq $0,fr_preempt_mode(%rip)
    sti
    cmpq $0,fr_preempt_a_counter(%rip)
    je .Lpreempt_bad
    cmpq $0,fr_preempt_b_counter(%rip)
    je .Lpreempt_bad
    movq $1,%rdi
    movq $1,%rsi
    jmp fr_push
.Lpreempt_bad:
    xorq %rdi,%rdi
    movq $1,%rsi
    jmp fr_push

.global fr_preempt_a_count
fr_preempt_a_count:
    movq fr_preempt_a_counter(%rip),%rdi
    movq $1,%rsi
    jmp fr_push

.global fr_preempt_b_count
fr_preempt_b_count:
    movq fr_preempt_b_counter(%rip),%rdi
    movq $1,%rsi
    jmp fr_push

fr_irq_fault:
    cli
    movw $0x3f8,%dx
    movb $'X',%al
    outb %al,%dx
.Lirq_halt:
    hlt
    jmp .Lirq_halt
