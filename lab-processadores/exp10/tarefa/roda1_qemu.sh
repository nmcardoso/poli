#!/bin/bash

#qemu irq.elf &
qemu-system-arm -M versatilepb -m 128M -nographic -s -S -kernel irq.elf
