arm-none-eabi-as -c -mcpu=arm926ej-s -g irq.s -o irq.o
arm-none-eabi-gcc -c -mcpu=arm926ej-s -Wall -Wextra -g handler.c -o handler.o
arm-none-eabi-ld -T irq.ld irq.o handler.o -o irq.elf
arm-none-eabi-objcopy -O binary irq.elf irq.bin
rm irq.o handler.o
