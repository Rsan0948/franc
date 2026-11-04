/* FrancOS UEFI GOP runtime console -- linked into the C-free kernel.
 * Firmware publishes a validated 32-byte handoff at fr_gop_descriptor(%rip).
 */
.section .text,"ax"
.global fr_gop_putchar
fr_gop_putchar:
    pushq %rbx
    pushq %rsi
    pushq %rdi
    pushq %r8
    pushq %r9
    pushq %r10
    pushq %r11
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    cmpl $0x50475246,fr_gop_descriptor(%rip)
    jne .Lgc_done
    cmpl $1,fr_gop_descriptor+4(%rip)
    jne .Lgc_done
    movzbl %al,%ebx
    cmpb $10,%bl
    je .Lgc_newline
    cmpb $13,%bl
    je .Lgc_carriage
    cmpb $8,%bl
    je .Lgc_backspace
    cmpb $32,%bl
    jb .Lgc_done
    cmpb $127,%bl
    jae .Lgc_done
    cmpq $0,fr_gop_initialized(%rip)
    jne .Lgc_canvas_ready
    call .Lgc_init
.Lgc_canvas_ready:
    /* Highlight native Home's selected row before its leading arrow. */
    cmpl $0,fr_gop_column(%rip)
    jne .Lgop_focus_checked
    cmpb $'>',%bl
    jne .Lgop_focus_checked
    movl fr_gop_row(%rip),%ecx
    cmpl $7,%ecx
    jb .Lgop_focus_checked
    cmpl $15,%ecx
    ja .Lgop_focus_checked
    movl %ecx,fr_gop_focus_row(%rip)
    call .Lgop_focus_paint
.Lgop_focus_checked:
    movl fr_gop_descriptor+16(%rip),%ecx
    subl $64,%ecx
    shrl $4,%ecx
    cmpl %ecx,fr_gop_column(%rip)
    jb .Lgc_place
    call .Lgc_advance
.Lgc_place:
    movq fr_gop_descriptor+8(%rip),%r12
    movl fr_gop_descriptor+24(%rip),%r13d
    movl fr_gop_column(%rip),%r14d
    shll $4,%r14d
    addl $32,%r14d
    movl fr_gop_row(%rip),%r15d
    imull $20,%r15d
    addl $32,%r15d
    leaq franc_font8x8(%rip),%rsi
    leaq (%rsi,%rbx,8),%rsi
    xorl %r8d,%r8d
.Lgc_row:
    cmpl $8,%r8d
    jae .Lgc_rendered
    movzbl (%rsi,%r8,1),%r10d
    xorl %r9d,%r9d
.Lgc_column_pixel:
    cmpl $8,%r9d
    jae .Lgc_nextrow
    movl $0x00192331,%r11d /* shared canvas */
    cmpl $96,%r15d
    jae .Lgop_background_panel
    movl $0x00222F3B,%r11d /* header */
    jmp .Lgop_background_chosen
.Lgop_background_panel:
    cmpl $704,%r14d
    jb .Lgop_background_chosen
    cmpl $984,%r14d
    jae .Lgop_background_chosen
    cmpl $112,%r15d
    jb .Lgop_background_chosen
    cmpl $516,%r15d
    jae .Lgop_background_chosen
    movl $0x00242D3D,%r11d /* right panel */
.Lgop_background_chosen:
    movl fr_gop_row(%rip),%eax
    cmpl fr_gop_focus_row(%rip),%eax
    jne .Lgop_focus_bg_done
    cmpl $656,%r14d
    jae .Lgop_focus_bg_done
    movl $0x00394F4B,%r11d
.Lgop_focus_bg_done:
    btl %r9d,%r10d
    jnc .Lgc_color
    movl $0x00EFEFEF,%r11d
.Lgc_color:
    movl %r8d,%eax
    leal (%r15,%rax,2),%eax
    imull %r13d,%eax
    leal (%r14,%r9,2),%edx
    addl %edx,%eax
    leaq (%r12,%rax,4),%rdi
    movl %r11d,(%rdi)
    movl %r11d,4(%rdi)
    leaq (,%r13,4),%rdx
    movl %r11d,(%rdi,%rdx)
    movl %r11d,4(%rdi,%rdx)
    incl %r9d
    jmp .Lgc_column_pixel
.Lgc_nextrow:
    incl %r8d
    jmp .Lgc_row
.Lgc_rendered:
    incl fr_gop_column(%rip)
    jmp .Lgc_done
.Lgc_carriage:
    movl $0,fr_gop_column(%rip)
    jmp .Lgc_done
.Lgc_newline:
    call .Lgc_advance
    jmp .Lgc_done
.Lgc_backspace:
    cmpl $0,fr_gop_column(%rip)
    je .Lgc_done
    decl fr_gop_column(%rip)
    jmp .Lgc_done
.Lgc_advance:
    movl $0,fr_gop_column(%rip)
    incl fr_gop_row(%rip)
    movl fr_gop_descriptor+20(%rip),%ecx
    subl $64,%ecx
    movl %ecx,%eax
    xorl %edx,%edx
    movl $20,%ecx
    divl %ecx
    cmpl %eax,fr_gop_row(%rip)
    jb .Lgc_advance_done
    movl $0,fr_gop_row(%rip)
.Lgc_advance_done:
    ret
.Lgc_init:
    pushq %rax
    pushq %rcx
    movq fr_gop_descriptor+8(%rip),%rdi
    movl fr_gop_descriptor+24(%rip),%eax
    imull fr_gop_descriptor+20(%rip),%eax
    movl %eax,%ecx
    movl $0x00192331,%eax
    cld
    rep stosl
    movl $-1,fr_gop_focus_row(%rip)
    /* Native accent header (top 8px), outside the glyph viewport. */
    movq fr_gop_descriptor+8(%rip),%rdi
    movl fr_gop_descriptor+24(%rip),%ecx
    shll $3,%ecx
    movl $0x00768F43,%eax
    rep stosl
    /* Left accent rail, 8 pixels wide, pitch-aware. */
    movq fr_gop_descriptor+8(%rip),%rdi
    movl fr_gop_descriptor+20(%rip),%ecx
    movl fr_gop_descriptor+24(%rip),%edx
    shll $2,%edx
.Lgop_rail_row:
    movl $0x00768F43,(%rdi)
    movl $0x00768F43,4(%rdi)
    movl $0x00768F43,8(%rdi)
    movl $0x00768F43,12(%rdi)
    movl $0x00768F43,16(%rdi)
    movl $0x00768F43,20(%rdi)
    movl $0x00768F43,24(%rdi)
    movl $0x00768F43,28(%rdi)
    addq %rdx,%rdi
    loop .Lgop_rail_row
    movq $1,fr_gop_initialized(%rip)
    popq %rcx
    popq %rax
    ret
.Lgc_done:
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %r11
    popq %r10
    popq %r9
    popq %r8
    popq %rdi
    popq %rsi
    popq %rbx
    ret
/* Match a real Franc vc-clear: 96+ consecutive zero-byte writes to the
 * legacy VGA aperture. Single glyph drawing cannot reach that threshold.
 * Reset the UEFI framebuffer so the native Home is not appended below the
 * boot diagnostic log. BIOS uses no descriptor and remains unchanged.
 */
.global fr_gop_on_vga_write
fr_gop_on_vga_write:
    cmpl $0x50475246,fr_gop_descriptor(%rip)
    jne .Lgop_watch_end
    pushq %rax
    pushq %rcx
    pushq %rdx
    pushq %rdi
    pushq %r8
    testb %r10b,%r10b
    jne .Lgop_watch_break
    cmpq $0xA0000,%rax
    jb .Lgop_watch_break
    cmpq $0xAFA00,%rax
    jae .Lgop_watch_break
    movq fr_gop_last_addr(%rip),%r8
    incq %r8
    cmpq %r8,%rax
    jne .Lgop_watch_start
    incl fr_gop_clear_count(%rip)
    cmpl $96,fr_gop_clear_count(%rip)
    jne .Lgop_watch_record
    movl $0,fr_gop_column(%rip)
    movl $0,fr_gop_row(%rip)
    call .Lgc_init
    call .Lgc_workspace_frame
    jmp .Lgop_watch_record
.Lgop_watch_start:
    movl $1,fr_gop_clear_count(%rip)
.Lgop_watch_record:
    movq %rax,fr_gop_last_addr(%rip)
    jmp .Lgop_watch_cleanup
.Lgop_watch_break:
    movl $0,fr_gop_clear_count(%rip)
    movq $0,fr_gop_last_addr(%rip)
.Lgop_watch_cleanup:
    popq %r8
    popq %rdi
    popq %rdx
    popq %rcx
    popq %rax
.Lgop_watch_end:
    ret
/* Focus uses a contiguous 16px bar at x32..656. Franc's selection
 * arrow remains the source of truth; no host-generated UI is involved.
 */
.Lgop_focus_paint:
    pushq %rax
    pushq %rcx
    pushq %rdx
    pushq %rdi
    pushq %r8
    pushq %r9
    movq fr_gop_descriptor+8(%rip),%r8
    movl fr_gop_descriptor+24(%rip),%r9d
    movl fr_gop_focus_row(%rip),%edx
    imull $20,%edx
    addl $32,%edx
.Lgop_focus_scan:
    movl %edx,%eax
    imull %r9d,%eax
    leaq 128(%r8,%rax,4),%rdi
    movl $624,%ecx
    movl $0x00394F4B,%eax
    cld
    rep stosl
    incl %edx
    movl fr_gop_focus_row(%rip),%ecx
    imull $20,%ecx
    addl $48,%ecx
    cmpl %ecx,%edx
    jb .Lgop_focus_scan
    popq %r9
    popq %r8
    popq %rdi
    popq %rdx
    popq %rcx
    popq %rax
    ret

/* Shared native UEFI 1024x768 workspace layout. Firmware-independent
 * text is still emitted by Franc; this only provides a branded frame,
 * right-side information panel, and consistent margins/typography.
 * Legacy 320x200 BIOS output is unchanged.
 */
.Lgc_workspace_frame:
    pushq %rax
    pushq %rbx
    pushq %rcx
    pushq %rdx
    pushq %rdi
    pushq %r8
    pushq %r9
    movl fr_gop_descriptor+16(%rip),%eax
    cmpl $980,%eax
    jb .Lgc_frame_labels
    movq fr_gop_descriptor+8(%rip),%rbx
    movl fr_gop_descriptor+24(%rip),%r9d
    movl $112,%r8d
.Lgc_panel_row:
    movl %r8d,%eax
    imull %r9d,%eax
    leaq 2816(%rbx,%rax,4),%rdi /* x=704 */
    movl $280,%ecx             /* 280-pixel sidebar */
    movl $0x00242D3D,%eax
    cld
    rep stosl
    incl %r8d
    cmpl $516,%r8d
    jb .Lgc_panel_row
    /* Splitter line, separated from main Franc source text. */
    movl $112,%r8d
.Lgc_split_row:
    movl %r8d,%eax
    imull %r9d,%eax
    leaq 2720(%rbx,%rax,4),%rdi /* x=680 */
    movl $0x00768F43,(%rdi)
    incl %r8d
    cmpl $516,%r8d
    jb .Lgc_split_row
    /* Repaint a calm header surface; the glyph renderer uses exactly
     * the same background color for its transparent-looking pixel cells. */
    movq fr_gop_descriptor+8(%rip),%rbx
    movl fr_gop_descriptor+24(%rip),%r9d
    movl $16,%r8d
.Lgop_header_row:
    movl %r8d,%eax
    imull %r9d,%eax
    leaq 64(%rbx,%rax,4),%rdi  /* x=16 */
    movl fr_gop_descriptor+16(%rip),%ecx
    subl $32,%ecx
    movl $0x00222F3B,%eax
    cld
    rep stosl
    incl %r8d
    cmpl $96,%r8d
    jb .Lgop_header_row
.Lgc_frame_labels:
    movl $0,fr_gop_row(%rip)
    movl $0,fr_gop_column(%rip)
    leaq .Lgc_frame_title(%rip),%rbx
    call .Lgc_frame_string
    movl $1,fr_gop_row(%rip)
    movl $0,fr_gop_column(%rip)
    leaq .Lgc_frame_subtitle(%rip),%rbx
    call .Lgc_frame_string
    movl fr_gop_descriptor+16(%rip),%eax
    cmpl $980,%eax
    jb .Lgc_frame_end
    movl $6,fr_gop_row(%rip)
    movl $44,fr_gop_column(%rip)
    leaq .Lgc_frame_aside(%rip),%rbx
    call .Lgc_frame_string
    movl $9,fr_gop_row(%rip)
    movl $44,fr_gop_column(%rip)
    leaq .Lgc_frame_info(%rip),%rbx
    call .Lgc_frame_string
    movl $11,fr_gop_row(%rip)
    movl $44,fr_gop_column(%rip)
    leaq .Lgc_frame_more(%rip),%rbx
    call .Lgc_frame_string
.Lgc_frame_end:
    movl $5,fr_gop_row(%rip)
    movl $0,fr_gop_column(%rip)
    popq %r9
    popq %r8
    popq %rdi
    popq %rdx
    popq %rcx
    popq %rbx
    popq %rax
    ret
.Lgc_frame_string:
    movzbl (%rbx),%eax
    testb %al,%al
    jz .Lgc_frame_string_end
    call fr_gop_putchar
    incq %rbx
    jmp .Lgc_frame_string
.Lgc_frame_string_end:
    ret
.section .rodata
.Lgc_frame_title: .asciz "F R A N C O S   /   W O R K S P A C E"
.Lgc_frame_subtitle: .asciz "Native Franc environment  |  UEFI GOP"
.Lgc_frame_aside: .asciz "SYSTEM"
.Lgc_frame_info: .asciz "FRANC + ASM"
.Lgc_frame_more: .asciz "Keyboard UI"
.section .text,"ax"
.section .bss
.balign 8
fr_gop_descriptor: .skip 32
fr_gop_initialized: .quad 0
fr_gop_last_addr: .quad 0
fr_gop_clear_count: .long 0
fr_gop_focus_row: .long 0
fr_gop_column: .long 0
fr_gop_row: .long 0
.section .text,"ax"
