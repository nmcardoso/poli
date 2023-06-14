@ Descrição do algoritmo
@ ----------------------
@ Exercício 9.2.4
@ Implementação de um tratador de exceções do tipo undefined
@ em Undefined_Handler para verificar a mudança do modo de
@ execução do processador.
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


.section INTERRUPT_VECTOR, "x"
.global _Reset
_Reset:
  B Reset_Handler /* Reset */
  B Undefined_Handler
  B . /* Undefined */
  B . /* SWI */
  B . /* Prefetch Abort */
  B . /* Data Abort */
  B . /* reserved */
  B . /* IRQ */
  B . /* FIQ */
 
Reset_Handler:
  LDR sp, =stack_top      @ seta pilha para o modo svc
  BL c_entry              @ inicializa execução do programa
  .word 0xffffffff        @ instrução inválida
  B .                     @ branch pc + 0

Undefined_Handler:
  LDR sp, =stack_top      @ seta pilha para o modo undefined
  BL undefined            @ branch para undefined

undefined:
