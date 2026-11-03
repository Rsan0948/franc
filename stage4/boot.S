/* FrancOS Stage4 BIOS loader: 310 kernel sectors, preserving FRANCFS1. */
.code16
.section .text
.global _start
_start:
  cli
  xorw %ax,%ax
  movw %ax,%ds
  movw %ax,%es
  movw %ax,%ss
  movw $0x7c00,%sp
  sti
  movb %dl,boot_drive
  movw $dap,%si
  movb $0x42,%ah
  movb boot_drive,%dl
  int $0x13
  jc disk_error
  /* Load optional kernel tail from LBA 200, keeping FRANCFS1 at 128..199.
     First portion (127 sectors) ends at physical 0x1FE00. */
  movw $dap_extra,%si
  movb $0x42,%ah
  movb boot_drive,%dl
  int $0x13
  jc disk_error
  /* Stage4 extra kernel extent, physical 0x26e00, LBA 256..382. */
  movw $dap_third,%si
  movb $0x42,%ah
  movb boot_drive,%dl
  int $0x13
  jc disk_error
  /* BIOS E820 inventory before switching to protected/long mode.
   * Store at low memory 0x5000 (up to 48 x 24-byte entries), with
   * a signature/count at 0x4ff0/0x4ff4. Failed discovery is represented
   * as an absent map, never as an assumption that RAM is available.
   */
  call e820_capture
  /* BIOS VGA mode 13h must be set before protected/long mode. */
  movw $0x0013,%ax
  int $0x10
  cli
  inb $0x92,%al
  orb $2,%al
  outb %al,$0x92
  lgdt gdt_desc
  movl %cr0,%eax
  orl $1,%eax
  movl %eax,%cr0
  ljmp $0x08,$protected

/* E820 24-byte entries. ES:DI = 0000:5000, EBX continuation.
 * BIOS may return a 20-byte record; the 24-byte slot is always zero
 * initialized and extended flags initialized to 1 before the call.
 * Bounded to 48 entries to avoid all reserved loader/runtime regions.
 */
e820_capture:
  pushw %es
  pushw %di
  pushw %bp
  xorw %ax,%ax
  movw %ax,%es
  movl $0,0x4ff0
  movw $0,0x4ff4
  movw $0x5000,%di
  xorw %bp,%bp
  xorl %ebx,%ebx
.e820_next:
  movl $0,0(%di)
  movl $0,4(%di)
  movl $0,8(%di)
  movl $0,12(%di)
  movl $0,16(%di)
  movl $1,20(%di)
  movl $0xe820,%eax
  movl $0x534d4150,%edx
  movl $24,%ecx
  int $0x15
  jc .e820_exit
  cmpl $0x534d4150,%eax
  jne .e820_exit
  cmpw $20,%cx
  jb .e820_exit
  incw %bp
  cmpw $48,%bp
  ja .e820_exit
  addw $24,%di
  testl %ebx,%ebx
  jne .e820_next
  movw %bp,0x4ff4
  movl $0x30323845,0x4ff0    /* little-endian ASCII E820 */
.e820_exit:
  popw %bp
  popw %di
  popw %es
  ret

disk_error:
  movw $err_msg,%si
1: lodsb
   testb %al,%al
   jz 2f
   movb $0x0e,%ah
   int $0x10
   jmp 1b
2: cli
   hlt
   jmp 2b

.code32
protected:
  movw $0x10,%ax
  movw %ax,%ds
  movw %ax,%es
  movw %ax,%ss
  movw %ax,%fs
  movw %ax,%gs
  /* PML4 0x9000 -> PDPT 0xA000 -> PD 0xB000, 256MiB identity map (128 x 2MiB pages).
     Guest RAM ends at 128MiB; the e1000 BAR0 is remapped to 0x08000000
     in the non-RAM PCI MMIO aperture above it. */
  movl $0x9000,%edi
  movl $3072,%ecx
  xorl %eax,%eax
  rep stosl
  movl $0xa003,0x9000
  movl $0xb003,0xa000
  movl $0xb000,%edi
  movl $128,%ecx
  movl $0x83,%eax
1: movl %eax,(%edi)
   addl $8,%edi
   addl $0x200000,%eax
   loop 1b
  movl %cr4,%eax
  orl $0x20,%eax
  movl %eax,%cr4
  movl $0x9000,%eax
  movl %eax,%cr3
  movl $0xc0000080,%ecx
  rdmsr
  orl $0x100,%eax
  wrmsr
  movl %cr0,%eax
  orl $0x80000000,%eax
  movl %eax,%cr0
  ljmp $0x18,$longmode

.code64
longmode:
  movw $0x10,%ax
  movw %ax,%ds
  movw %ax,%es
  movw %ax,%ss
  movabs $0x80000,%rsp
  movabs $0x10000,%rax
  call *%rax
1: cli
   hlt
   jmp 1b

.code16
.align 8
gdt:
  .quad 0
  .quad 0x00cf9a000000ffff    /* 0x08 32-bit code */
  .quad 0x00cf92000000ffff    /* 0x10 data */
  .quad 0x00af9a000000ffff    /* 0x18 64-bit code */
gdt_end:
gdt_desc:
  .word gdt_end-gdt-1
  .long gdt
boot_drive: .byte 0
err_msg: .asciz "FracOS disk load failed"
.align 4
dap:
  .byte 0x10,0
  .word 127
  .word 0,0x1000
  .quad 1
.align 4
dap_extra:
  .byte 0x10,0
  .word 56
  .word 0,0x1fe0
  .quad 200
.align 4
dap_third:
  .byte 0x10,0
  .word 127
  .word 0,0x26e0
  .quad 256
.org 510
.word 0xaa55
