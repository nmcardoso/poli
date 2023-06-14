ENTRY(_Reset)
SECTIONS
{
 . = 0x0; /* define o símbolo . como 0x0 */
 .startup . : { startup.o(.text) } /* define o símbolo .startup como o programa-objeto no arquivo startup.o */
 .text : { *(.text) }
 .data : { *(.data) }
 .bss : { *(.bss COMMON) }
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 stack_top = .; /* Endereço inicial da pilha para modo svc */
}
