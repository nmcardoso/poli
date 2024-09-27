@ Descrição do algoritmo
@ ----------------------
@ Exercício 9.2.2
@ Implementação simples de startup com o objetivo apenas de
@ chamar uma rotina do programa C.
@
@
@ Instruções de uso
@ -----------------
@ Em um terminal, executar:
@   make
@ Em outro terminal, executar:
@   eabi-qemu -se program.elf
@
@ Ver Makefile para mais detalhes

.global _Reset
_Reset:
 LDR sp, =stack_top   @ configura posição inicial do stack pointer
 BL c_entry           @ chama rotina do programa C
 B .                  @ branch pc + 0
