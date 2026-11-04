/* FrancOS Wave 3 F3: sealed Franc-generated CPL3 code admission.
 *
 * Franc emits restricted x86-64 user code in a 256-byte kernel scratch
 * buffer. The kernel MUST NOT trust arbitrary JIT or scratch content.
 * Verify the entire byte sequence against two audited, finite templates,
 * with a single validated 1..255 immediate. Copy it to a sealed staging
 * area; there is no free-form user-code loader here.
 *
 * A second copy, from kernel staging into generation-owned RX PTE frames,
 * occurs only before the IRQ-preemptive user scheduler starts. None of the
 * user code can access kernel JIT, supervisor memory, or another CR3.
 */
.section .rodata
.balign 16
fr_compiled_fault_template:
    .byte 0x48,0xbf,0x00,0x10,0x00,0x40,0,0,0,0
    .byte 0xb9,0x01,0,0,0,0xff,0x07,0xff,0xc9,0x75,0xfa
    .byte 0x48,0xb8,0,0,1,0,0,0,0,0
    .byte 0x0f,0xb6,0x00,0x0f,0x0b
fr_compiled_loop_template:
    .byte 0x48,0xbf,0x00,0x10,0x00,0x40,0,0,0,0
    .byte 0x83,0x07,0x02,0xf3,0x90,0xeb,0xf9

.section .bss
.balign 16
fr_compiled_code:   .skip 128   /* two 64-byte verified templates */
fr_compiled_length: .skip 16    /* 0 absent or exact 17/36 */
fr_compiled_kind:   .skip 16    /* 1 faults after N; 2 loops forever */

.section .text,"ax"
.global fr_user_compiled_stage
fr_user_compiled_stage:
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    /* Stack: (code-pointer byte-length user-slot -- flag) */
    call fr_pop
    cmpq $1,%rdx
    jne .Lcompiled_reject
    movq %rax,%r12
    cmpq $1,%r12
    jb .Lcompiled_reject
    cmpq $2,%r12
    ja .Lcompiled_reject
    call fr_pop
    cmpq $1,%rdx
    jne .Lcompiled_reject
    movq %rax,%r15
    call fr_pop
    cmpq $1,%rdx
    jne .Lcompiled_reject
    movq %rax,%r14
    /* Never accept a caller-supplied kernel pointer or an already-executing
       user process. Compiler has a single fixed code-output location. */
    cmpq $0x06b00c00,%r14
    jne .Lcompiled_reject
    cmpq $0,fr_user_busy(%rip)
    jne .Lcompiled_reject
    cmpq $36,%r15
    je .Lcompiled_fault
    cmpq $17,%r15
    jne .Lcompiled_reject
    leaq fr_compiled_loop_template(%rip),%r13
    movq $2,%rbx
    jmp .Lcompiled_check
.Lcompiled_fault:
    leaq fr_compiled_fault_template(%rip),%r13
    movq $1,%rbx
.Lcompiled_check:
    xorq %r8,%r8
.Lcompiled_bytes:
    cmpq %r15,%r8
    jae .Lcompiled_save
    /* Only the count immediate differs from the statically audited code. */
    cmpq $1,%rbx
    jne .Lcompiled_loop_imm
    cmpq $11,%r8
    je .Lcompiled_immediate
    jmp .Lcompiled_fixed
.Lcompiled_loop_imm:
    cmpq $12,%r8
    je .Lcompiled_immediate
.Lcompiled_fixed:
    movzbl (%r13,%r8),%eax
    cmpb %al,(%r14,%r8)
    jne .Lcompiled_reject
    incq %r8
    jmp .Lcompiled_bytes
.Lcompiled_immediate:
    movzbl (%r14,%r8),%eax
    testl %eax,%eax
    jz .Lcompiled_reject
    incq %r8
    jmp .Lcompiled_bytes
.Lcompiled_save:
    movq %r12,%rcx
    decq %rcx
    leaq fr_compiled_code(%rip),%rdi
    shlq $6,%rcx
    addq %rcx,%rdi
    movq %r14,%rsi
    movq %r15,%rcx
    cld
    rep movsb
    movq %r12,%rcx
    decq %rcx
    leaq fr_compiled_kind(%rip),%r8
    movq %rbx,(%r8,%rcx,8)
    leaq fr_compiled_length(%rip),%r8
    movq %r15,(%r8,%rcx,8)
    movq $1,%rbx
    jmp .Lcompiled_done
.Lcompiled_reject:
    xorq %rbx,%rbx
.Lcompiled_done:
    movq %rbx,%rdi
    movq $1,%rsi
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    jmp fr_push

/* rdi = experiment 6 (fault A / loop B) or 7 (loop A / loop B).
 * Neither mode can run before both slots contain audited bytes.
 * A new run after mode 6 establishes new leases/CR3; no stale page reuse.
 */
.global fr_user_compiled_probe
fr_user_compiled_probe:
    movq $6,%rdi
    jmp fr_user_compiled_launch
.global fr_user_compiled_relaunch
fr_user_compiled_relaunch:
    movq $7,%rdi
fr_user_compiled_launch:
    cmpq $0,fr_user_busy(%rip)
    jne .Lcompiled_launch_bad
    cmpq $1,fr_compiled_kind(%rip)
    je .Lcompiled_launch_fault_a
    cmpq $7,%rdi
    jne .Lcompiled_launch_bad
    cmpq $2,fr_compiled_kind(%rip)
    jne .Lcompiled_launch_bad
.Lcompiled_launch_fault_a:
    cmpq $2,fr_compiled_kind+8(%rip)
    jne .Lcompiled_launch_bad
    movq fr_compiled_length(%rip),%rax
    cmpq $17,%rax
    je .Lcompiled_launch_a17
    cmpq $36,%rax
    jne .Lcompiled_launch_bad
    jmp .Lcompiled_launch_b
.Lcompiled_launch_a17:
    cmpq $7,%rdi
    jne .Lcompiled_launch_bad
.Lcompiled_launch_b:
    cmpq $17,fr_compiled_length+8(%rip)
    jne .Lcompiled_launch_bad
    jmp fr_user_run
.Lcompiled_launch_bad:
    movq $0,%rdi
    movq $1,%rsi
    jmp fr_push

.global fr_user_compiled_a_kind
fr_user_compiled_a_kind:
    movq fr_compiled_kind(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
.global fr_user_compiled_b_kind
fr_user_compiled_b_kind:
    movq fr_compiled_kind+8(%rip),%rdi
    movq $1,%rsi
    jmp fr_push
