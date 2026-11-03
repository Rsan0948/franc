/* Portable x86-64 SHA-256 for Franctxt v1 document identity.
 * No C, libc, firmware, heap, syscalls or x86 SHA extensions.
 * SysV: ft_sha256_canonical(rdi=canonical_ptr, rsi=byte_count)
 * -> rax points to static 64-byte lowercase hex plus trailing NUL.
 * Computes SHA256("franctxt/1" + NUL + canonical document bytes).
 * Null return for null pointer or byte_count > 2047.
 * NON-REENTRANT: static workspaces; intended for trusted single-core
 * kernel operations only, not untrusted or preemptible execution.
 */
.code64
.section .rodata
.Lft_sha_domain: .asciz "franctxt/1"
.Lft_sha_hexchars: .ascii "0123456789abcdef"
.balign 4
.Lft_sha_initial:
    .long 0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a
    .long 0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19
.Lft_sha_k:
    .long 0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
    .long 0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
    .long 0xd807aa98,0x12835b01,0x243185be,0x550c7dc3
    .long 0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174
    .long 0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc
    .long 0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da
    .long 0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7
    .long 0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967
    .long 0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13
    .long 0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85
    .long 0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3
    .long 0xd192e819,0xd6990624,0xf40e3585,0x106aa070
    .long 0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5
    .long 0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3
    .long 0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
    .long 0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2

.section .bss
.balign 16
.Lft_sha_message: .skip 2176
.balign 16
.Lft_sha_schedule: .skip 256
.balign 16
.Lft_sha_state: .skip 32
.balign 16
.Lft_sha_output: .skip 65

.section .text,"ax"
.global ft_sha256_canonical
.type ft_sha256_canonical,@function
ft_sha256_canonical:
    testq %rdi,%rdi
    jz .Lft_sha_fail
    cmpq $2047,%rsi
    ja .Lft_sha_fail
    pushq %rbx
    pushq %rbp
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    movq %rdi,%r14
    movq %rsi,%r13
    /* Reset 2176 bytes of message workspace. */
    leaq .Lft_sha_message(%rip),%rdi
    movl $272,%ecx
    xorl %eax,%eax
    cld
    rep stosq
    /* Prefix the 11-byte domain, including its terminating zero. */
    leaq .Lft_sha_message(%rip),%rdi
    leaq .Lft_sha_domain(%rip),%rsi
    movl $11,%ecx
    rep movsb
    /* Copy canonical document as opaque bytes. */
    movq %r14,%rsi
    movq %r13,%rcx
    rep movsb
    movb $0x80,(%rdi)
    /* Number of 64-byte blocks = ceil((11 + document_bytes + 9)/64). */
    leaq 83(%r13),%r14
    shrq $6,%r14
    /* Last 64-bit message-length field is big endian, in bits. */
    leaq 11(%r13),%rax
    shlq $3,%rax
    bswapq %rax
    leaq .Lft_sha_message(%rip),%r11
    movq %r14,%r10
    shlq $6,%r10
    subq $8,%r10
    movq %rax,(%r11,%r10)
    /* Reset eight digest state words. */
    leaq .Lft_sha_initial(%rip),%rsi
    leaq .Lft_sha_state(%rip),%rdi
    movl $8,%ecx
    rep movsl
    xorq %r13,%r13
.Lft_block:
    cmpq %r14,%r13
    jae .Lft_finished
    leaq .Lft_sha_message(%rip),%r11
    movq %r13,%rax
    shlq $6,%rax
    addq %rax,%r11
    leaq .Lft_sha_schedule(%rip),%r12
    xorq %rcx,%rcx
.Lft_load16:
    cmpq $16,%rcx
    jae .Lft_expand_start
    movl (%r11,%rcx,4),%eax
    bswapl %eax
    movl %eax,(%r12,%rcx,4)
    incq %rcx
    jmp .Lft_load16
.Lft_expand_start:
    movl $16,%ecx
.Lft_expand:
    cmpq $64,%rcx
    jae .Lft_round_start
    /* small_sigma_0(W[t-15]). */
    movl -60(%r12,%rcx,4),%eax
    movl %eax,%r8d
    rorl $7,%r8d
    movl %eax,%r9d
    rorl $18,%r9d
    xorl %r9d,%r8d
    shrl $3,%eax
    xorl %eax,%r8d
    /* small_sigma_1(W[t-2]). */
    movl -8(%r12,%rcx,4),%eax
    movl %eax,%r9d
    rorl $17,%r9d
    movl %eax,%r10d
    rorl $19,%r10d
    xorl %r10d,%r9d
    shrl $10,%eax
    xorl %eax,%r9d
    movl -64(%r12,%rcx,4),%eax
    addl -28(%r12,%rcx,4),%eax
    addl %r8d,%eax
    addl %r9d,%eax
    movl %eax,(%r12,%rcx,4)
    incq %rcx
    jmp .Lft_expand
.Lft_round_start:
    movl .Lft_sha_state(%rip),%eax
    movl .Lft_sha_state+4(%rip),%ebx
    movl .Lft_sha_state+8(%rip),%ecx
    movl .Lft_sha_state+12(%rip),%edx
    movl .Lft_sha_state+16(%rip),%esi
    movl .Lft_sha_state+20(%rip),%edi
    movl .Lft_sha_state+24(%rip),%r8d
    movl .Lft_sha_state+28(%rip),%r9d
    xorq %r15,%r15
.Lft_round:
    cmpq $64,%r15
    jae .Lft_compress_end
    /* Big Sigma1(e), then Ch(e,f,g). */
    movl %esi,%r10d
    rorl $6,%r10d
    movl %esi,%r11d
    rorl $11,%r11d
    xorl %r11d,%r10d
    movl %esi,%r11d
    rorl $25,%r11d
    xorl %r11d,%r10d
    movl %esi,%r11d
    andl %edi,%r11d
    movl %esi,%ebp
    notl %ebp
    andl %r8d,%ebp
    xorl %ebp,%r11d
    /* T1 = h + Sigma1(e) + Ch + K[t] + W[t], mod 2^32. */
    movl %r9d,%ebp
    addl %r10d,%ebp
    addl %r11d,%ebp
    leaq .Lft_sha_k(%rip),%r11
    addl (%r11,%r15,4),%ebp
    addl (%r12,%r15,4),%ebp
    /* T2 = Sigma0(a) + Maj(a,b,c), mod 2^32.
     * Maj = (a & b) + (c & (a xor b)); addends are disjoint.
     */
    movl %eax,%r10d
    rorl $2,%r10d
    movl %eax,%r11d
    rorl $13,%r11d
    xorl %r11d,%r10d
    movl %eax,%r11d
    rorl $22,%r11d
    xorl %r11d,%r10d
    movl %eax,%r11d
    andl %ebx,%r11d
    addl %r11d,%r10d
    movl %eax,%r11d
    xorl %ebx,%r11d
    andl %ecx,%r11d
    addl %r11d,%r10d
    /* Rotate working words and inject T1/T2. */
    movl %r8d,%r9d
    movl %edi,%r8d
    movl %esi,%edi
    movl %edx,%esi
    addl %ebp,%esi
    movl %ecx,%edx
    movl %ebx,%ecx
    movl %eax,%ebx
    movl %ebp,%eax
    addl %r10d,%eax
    incq %r15
    jmp .Lft_round
.Lft_compress_end:
    addl %eax,.Lft_sha_state(%rip)
    addl %ebx,.Lft_sha_state+4(%rip)
    addl %ecx,.Lft_sha_state+8(%rip)
    addl %edx,.Lft_sha_state+12(%rip)
    addl %esi,.Lft_sha_state+16(%rip)
    addl %edi,.Lft_sha_state+20(%rip)
    addl %r8d,.Lft_sha_state+24(%rip)
    addl %r9d,.Lft_sha_state+28(%rip)
    incq %r13
    jmp .Lft_block
.Lft_finished:
    leaq .Lft_sha_state(%rip),%r12
    leaq .Lft_sha_output(%rip),%rdi
    leaq .Lft_sha_hexchars(%rip),%r11
    xorl %r13d,%r13d
.Lft_hex_word:
    cmpq $8,%r13
    jae .Lft_hex_done
    movl (%r12,%r13,4),%eax
    movl $8,%r15d
.Lft_hex_nibble:
    movl %eax,%ecx
    shrl $28,%ecx
    movzbl (%r11,%rcx),%edx
    movb %dl,(%rdi)
    incq %rdi
    shll $4,%eax
    decq %r15
    jnz .Lft_hex_nibble
    incq %r13
    jmp .Lft_hex_word
.Lft_hex_done:
    movb $0,(%rdi)
    leaq .Lft_sha_output(%rip),%rax
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbp
    popq %rbx
    ret
.Lft_sha_fail:
    xorq %rax,%rax
    ret
.size ft_sha256_canonical,.-ft_sha256_canonical
.section .note.GNU-stack,"",@progbits
