@ Descrição do algoritmo
@ ----------------------
@ Exercício 9.2.7
@ Implementação de um exeprimento para verificar a presença de
@ difetentes modos de operação do processador.
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
  LDR sp, =stack_top        @ configuração do SP no modo svc
  MRS r0, cpsr              @ salvando o modo corrente em R0
  MSR cpsr_ctl, #0b11011011 @ modo undefined
indefinido:
  NOP 
  MSR cpsr_ctl, #0b11010011 @ modo supervisor
supervisor:
  NOP 
  MSR cpsr_ctl, #0b11010001 @ modo fiq
fiq:
  NOP
  MSR cpsr, r0              @ volta para o modo anterior 
modo_original:
  BL c_entry                @ executa rotina C
  B .

Undefined_Handler:
  LDR sp, =stack_top        @ configuração do SP no modo undef
  BL undefined

undefined:
