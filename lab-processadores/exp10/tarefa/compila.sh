arm-none-eabi-as -c -mcpu=arm926ej-s -g irq.s -o irq.o
arm-none-eabi-gcc -c -mcpu=arm926ej-s -Wall -Wextra -g tasks.c -o tasks.o
arm-none-eabi-ld -T irq.ld irq.o tasks.o -o irq.elf
arm-none-eabi-objcopy -O binary irq.elf irq.bin
rm irq.o tasks.o
