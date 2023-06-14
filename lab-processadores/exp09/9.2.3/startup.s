@ Descrição do algoritmo
@ ----------------------
@ Exercício 9.2.3
@ Inclui uma instrução inválida para testar a execução
@ de Undefined_Handler e a mudança do modo de operação
@ do processador.
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
  B Reset_Handler /* Reset */
  B Undefined_Handler /* Undefined */
  B . /* SWI */
  B . /* Prefetch Abort */
  B . /* Data Abort */
  B . /* reserved */
  B . /* IRQ */
  B . /* FIQ */


Reset_Handler:
  LDR sp, =stack_top    @ seta pilha para o modo svc
  BL c_entry            @ inicializa execução do programa
  .word 0xffffffff      @ instrução inválida
  B fim                 @ finaliza


Undefined_Handler:
  LDR sp, =stack_top    @ seta pilha para o modo undefined
  BL print_undefined    @ executa rotina de manuseio de erro
  B fim                 @ finaliza


fim:
  SWI 0                 @ termina execução
