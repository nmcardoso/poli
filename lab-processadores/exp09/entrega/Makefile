.DEFAULT_GOAL := emulate

emulate:
		arm-none-eabi-gcc -c -mcpu=arm926ej-s -Wall -Wextra -g c_entry.c -o c_entry.o
		arm-none-eabi-as -c -mcpu=arm926ej-s -g startup.s -o startup.o
		arm-none-eabi-ld -T vector_table.ld c_entry.o startup.o -o program.elf
		arm-none-eabi-objcopy -O binary program.elf program.bin
		qemu-system-arm -M versatilepb -m 128M -nographic -s -S -kernel program.bin 
