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
    movq $0,fr_irq_running(%rip)
    movq fr_irq_tick_count(%rip),%rdi
    movq $1,%rsi
    jmp fr_push

fr_irq_timer:
    pushq %rax
    pushq %rdx
    incq fr_irq_tick_count(%rip)
    movw $0x20,%dx
    movb $0x20,%al
    outb %al,%dx
    popq %rdx
    popq %rax
    iretq

fr_irq_fault:
    cli
    movw $0x3f8,%dx
    movb $'X',%al
    outb %al,%dx
.Lirq_halt:
    hlt
    jmp .Lirq_halt
