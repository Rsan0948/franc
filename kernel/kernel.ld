ENTRY(_kstart)
SECTIONS {
 . = 0x10000;
 .text : { KEEP(*(.text.entry)) *(.text .text.*) }
 .rodata : { *(.rodata .rodata.*) }
 .data : { *(.data .data.*) }
 . = ALIGN(16);
 __bss_start = .;
 .bss : { *(.bss .bss.*) *(COMMON) }
 __bss_end = .;
 /DISCARD/ : { *(.eh_frame*) *(.note*) *(.comment*) }
}
