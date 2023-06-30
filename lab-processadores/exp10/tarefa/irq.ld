ENTRY(_start)
SECTIONS
{
    . = 0x0;
    .text : { * (.text); }
    . = ALIGN(8);
    . = . + 0x1000; /* 4kB of stack memory */
    supervisor_stack_top = .;
    . = . + 0x1000; /* 4kB of stack memory for undefined */
    irq_stack_top = .;
}