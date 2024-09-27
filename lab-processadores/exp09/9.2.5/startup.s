@ Descrição do algoritmo
@ ----------------------
@ Exercício 9.2.5
@ Este algorítmo implementa a mudança dos stack pointers dos
@ modos de operação supervisor e undefined ambos em Reset_Handler
@ através da mudança de estado programática pela alteração
@ dos bits de controle do registrador CPSR.
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
  LDR sp, =stack_top           @ seta pilha para o modo svc

  MRS r0, cpsr                 @ salvando o modo corrente em R0
  MSR cpsr_ctl, #0b11011011    @ alterando o modo para undefined - o SP é automaticamente chaveado ao chavear o modo
  LDR sp, =undefined_stack_top @ seta pilha para o modo undefined
  MSR cpsr, r0                 @ volta para o modo anterior
  
  BL c_entry                   @ inicializa execução do programa
  B fim                        @ finaliza


Undefined_Handler:
  BL print_undefined           @ executa rotina de manuseio de erro
  B fim                        @ finaliza


fim:
  SWI 0x0                      @ termina execução
