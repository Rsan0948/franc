/* FrancOS x86-64 interrupt foundation (BIOS QEMU proof, not a scheduler).
 * 256 ring-0 interrupt gates; unexpected vectors halt with serial 'X'.
 * CPU exceptions are installed at boot by fr_cpu_init on a separate stack.
 * IRQ0 is a 100 Hz PIT timer with PIC remapped to vectors 32..47.
 * All registers touched by IRQ0 are saved; RFLAGS is restored by iretq.
 * No Ring 3, preemption or nested IRQs are claimed here.
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
    /* Vectors below 32 keep the exception gates from fr_cpu_init. */
    leaq fr_irq_idt+512(%rip),%r8
    leaq fr_irq_fault(%rip),%r9
    movl $32,%ecx
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
    /* Wave 2: bounded CPL3 contexts use their own CR3 and TSS RSP0. */
    cmpq $1,fr_user_enabled(%rip)
    je fr_user_timer_tick
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

/* CPU setup shared by BIOS and UEFI boot: GDT and TSS, exception gates, and
 * 4 KiB mappings of the low 2 MiB for the stack guard and read-only code.
 */
.set FR_KERNEL_STACK_GUARD,0x100000
.set FR_KERNEL_STACK_TOP,0x141000
.section .bss
.balign 4096
fr_low_pt: .skip 4096
fr_fault_stack: .skip 8192
fr_recover_rsp: .skip 8
fr_recover_ds: .skip 8
.section .rodata
faultmsg: .asciz "\nFAULT vector "
faultatmsg: .asciz " at "
faulthaltmsg: .asciz "\nHALTED: no recovery point\n"
fr_fault_table:
.irp v,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    .quad fr_fault_\v
.endr
.section .text,"ax"
.global fr_cpu_init
fr_cpu_init:
    leaq fr_fault_stack+8192(%rip),%rax
    movq %rax,fr_ring3_tss+36(%rip) /* IST1 */
    movw $104,fr_ring3_tss+102(%rip)
    leaq fr_ring3_tss(%rip),%rax
    movq %rax,%rcx
    movw $103,fr_ring3_gdt+48(%rip)
    movw %cx,fr_ring3_gdt+50(%rip)
    shrq $16,%rcx
    movb %cl,fr_ring3_gdt+52(%rip)
    movb $0x89,fr_ring3_gdt+53(%rip)
    movb $0,fr_ring3_gdt+54(%rip)
    shrq $8,%rcx
    movb %cl,fr_ring3_gdt+55(%rip)
    shrq $8,%rcx
    movl %ecx,fr_ring3_gdt+56(%rip)
    leaq fr_ring3_gdt(%rip),%rax
    movq %rax,fr_ring3_gdtr+2(%rip)
    lgdt fr_ring3_gdtr(%rip)
    pushq $0x18
    leaq .Lcpu_new_cs(%rip),%rax
    pushq %rax
    lretq
.Lcpu_new_cs:
    movw $0x10,%ax
    movw %ax,%ds
    movw %ax,%es
    movw %ax,%ss
    movw %ax,%fs
    movw %ax,%gs
    movw $0x30,%ax
    ltr %ax
    /* Spurious vectors halt; exceptions use IST1 so a bad stack can report. */
    leaq fr_irq_idt(%rip),%rdi
    leaq fr_irq_fault(%rip),%rsi
    movl $0x8e00,%edx
    movl $256,%r8d
.Lcpu_spurious:
    call fr_ring3_setgate
    addq $16,%rdi
    decl %r8d
    jnz .Lcpu_spurious
    leaq fr_irq_idt(%rip),%rdi
    leaq fr_fault_table(%rip),%r9
    movl $0x8e01,%edx
    movl $32,%r8d
.Lcpu_exceptions:
    movq (%r9),%rsi
    call fr_ring3_setgate
    addq $16,%rdi
    addq $8,%r9
    decl %r8d
    jnz .Lcpu_exceptions
    leaq fr_irq_idt(%rip),%rax
    movq %rax,fr_irq_idtr+2(%rip)
    lidt fr_irq_idtr(%rip)
    /* Find the page directory, whichever loader built it. */
    movabsq $0x000ffffffffff000,%rdx
    movq %cr3,%rax
    andq %rdx,%rax
    movq (%rax),%rax
    andq %rdx,%rax
    movq (%rax),%rax
    testb $0x80,%al
    jnz .Lcpu_paging_done
    andq %rdx,%rax
    movq %rax,%r10
    testb $0x80,(%r10)
    jz .Lcpu_paging_done
    /* Replace the first 2 MiB page with the same mapping in 4 KiB pages. */
    leaq fr_low_pt(%rip),%rdi
    xorl %eax,%eax
    movq $__text_end,%r9
    andq $-4096,%r9
.Lcpu_low_page:
    movq %rax,%rcx
    orq $3,%rcx
    cmpq $0x10000,%rax
    jb .Lcpu_low_store
    cmpq %r9,%rax
    jae .Lcpu_low_store
    andq $-3,%rcx              /* kernel code is read-only */
.Lcpu_low_store:
    cmpq $FR_KERNEL_STACK_GUARD,%rax
    jne .Lcpu_low_write
    xorl %ecx,%ecx             /* stack guard is not present */
.Lcpu_low_write:
    movq %rcx,(%rdi)
    addq $8,%rdi
    addq $4096,%rax
    cmpq $0x200000,%rax
    jne .Lcpu_low_page
    leaq fr_low_pt(%rip),%rax
    orq $3,%rax
    movq %rax,(%r10)
    movq %cr3,%rax
    movq %rax,%cr3
    movq %cr0,%rax
    orq $0x10000,%rax          /* CR0.WP: read-only applies to ring 0 too */
    movq %rax,%cr0
.Lcpu_paging_done:
    ret

.irp v,0,1,2,3,4,5,6,7,9,15,16,18,19,20,22,23,24,25,26,27,28,31
fr_fault_\v:
    pushq $0
    pushq $\v
    jmp fr_cpu_fault
.endr
.irp v,8,10,11,12,13,14,17,21,29,30
fr_fault_\v:
    pushq $\v
    jmp fr_cpu_fault
.endr

/* Stack: vector, error, rip, cs, rflags, rsp, ss. */
fr_cpu_fault:
    testb $3,24(%rsp)
    jnz fr_irq_fault
    cmpq $2,fr_preempt_mode(%rip)
    jne .Lfault_report
    cmpq $0,fr_preempt_current(%rip)
    jne fr_task_abort_current
.Lfault_report:
    leaq faultmsg(%rip),%rdi
    call fr_write_z
    movq (%rsp),%rax
    movl $2,%ecx
    call fr_put_hex
    leaq faultatmsg(%rip),%rdi
    call fr_write_z
    movq 16(%rsp),%rax
    movl $16,%ecx
    call fr_put_hex
    movb $10,%al
    call .Lfault_putc
/* Resume after the innermost fr_s2_run, or halt if there is none. */
fr_recover:
    movq fr_recover_rsp(%rip),%rax
    testq %rax,%rax
    jz .Lfault_halt
    movq %rax,%rsp
    movq fr_recover_ds(%rip),%rax
    movq %rax,ds_ptr(%rip)
    cmpq $1,fr_irq_running(%rip)
    jne .Lrun_resume
    sti
    jmp .Lrun_resume
.Lfault_halt:
    leaq faulthaltmsg(%rip),%rdi
    call fr_write_z
.Lfault_stop:
    cli
    hlt
    jmp .Lfault_stop

/* Print the low ecx hex digits of rax. */
fr_put_hex:
    pushq %rbx
    pushq %r12
    movq %rax,%rbx
    movl %ecx,%r12d
.Lhex_next:
    leal -1(%r12),%ecx
    shll $2,%ecx
    movq %rbx,%rax
    shrq %cl,%rax
    andl $15,%eax
    addb $'0',%al
    cmpb $'9',%al
    jbe .Lhex_emit
    addb $39,%al
.Lhex_emit:
    call .Lfault_putc
    decl %r12d
    jnz .Lhex_next
    popq %r12
    popq %rbx
    ret
.Lfault_putc:
    jmp fr_putc

