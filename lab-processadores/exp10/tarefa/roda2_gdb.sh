#!/bin/bash

#eabi-qemu -se irq.elf &
arm-none-eabi-gdb -tui --command=~/.gdbinit/qemu irq.elf

pkill qemu
