/* FerrumKern - x86_64 ELF64 higher-half linker script for Limine */
OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)
ENTRY(kmain)

PHDRS
{
  text PT_LOAD FLAGS(5);
  rodata PT_LOAD FLAGS(4);
  data PT_LOAD FLAGS(6);
}

SECTIONS
{
  . = 0xffffffff80000000;
  . = ALIGN(0x1000);

  .requests : {
    KEEP(*(.requests))
    KEEP(*(.requests_start_marker))
    KEEP(*(.requests_end_marker))
  } :text

  . = ALIGN(0x1000);
  .text : { *(.text .text.*) } :text
  . = ALIGN(0x1000);
  .rodata : { *(.rodata .rodata.*) } :rodata
  . = ALIGN(0x1000);
  .data : { *(.data .data.*) *(.sdata .sdata.*) } :data
  . = ALIGN(0x1000);
  .bss : { *(COMMON) *(.bss .bss.*) } :data
  . = ALIGN(0x1000);
  _kernel_end = .;

  /DISCARD/ : { *(.eh_frame) *(.comment) *(.note*) }
}
