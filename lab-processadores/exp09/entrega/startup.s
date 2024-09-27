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

  .word 0xffffffff             @ instrução inválida
  
  BL c_entry                   @ inicializa execução do programa
  B fim                        @ finaliza


Undefined_Handler:
  STMFD sp!, {R0-R12,lr}       @ salva o estado atual na pilha
  BL print_undefined           @ executa rotina de manuseio de erro

vesaida:
  LDMFD sp!, {R0-R12,pc}^      @ restaura estado de execução anterior


fim: 
  SWI 0x0                      @ finaliza execução
