.global _start
.text
_start:
  b _Reset @posição 0x00 - Reset
  ldr pc, _undefined_instruction @posição 0x04 - Intrução não-definida
  ldr pc, _software_interrupt @posição 0x08 - Interrupção de Software
  ldr pc, _prefetch_abort @posição 0x0C - Prefetch Abort
  ldr pc, _data_abort @posição 0x10 - Data Abort
  ldr pc, _not_used @posição 0x14 - Não utilizado
  ldr pc, _irq @posição 0x18 - Interrupção (IRQ)
  ldr pc, _fiq @posição 0x1C - Interrupção(FIQ)

_undefined_instruction: .word undefined_instruction
_software_interrupt: .word software_interrupt
_prefetch_abort: .word prefetch_abort
_data_abort: .word data_abort
_not_used: .word not_used
_irq: .word irq
_fiq: .word fiq
_taskB: .word taskB

INTPND: .word 0x10140000 @Interrupt status register
INTSEL: .word 0x1014000C @interrupt select register( 0 = irq, 1 = fiq)
INTEN: .word 0x10140010 @interrupt enable register
TIMER0L: .word 0x101E2000 @Timer 0 load register
TIMER0V: .word 0x101E2004 @Timer 0 value registers
TIMER0C: .word 0x101E2008 @timer 0 control register

_Reset:
  LDR sp, =supervisor_stack_top

  @ Inicializacao das stacks
  MRS r0, cpsr    @ salvando o modo corrente em R0
  MSR cpsr_ctl, #0b11010010 @ alterando o modo para irq - o SP eh automaticamente chaveado ao chavear o modo
  LDR sp, =irq_stack_top @ a pilha de irq eh setada 
  MSR cpsr, r0 @ volta para o modo anterior

  bl timer_init @ initialize interrupts and timer 0

  MRS r0, cpsr @ valor de cpsr para taskB
  LDR r1, _taskB @ valor de pc para taskB
  SUB r2, sp, #0x500 @ valor de sp para taskB

  ADR r3, linhaB
  STR r1, [r3, #52] @ guarda pc
  STR r0, [r3, #56] @ guarda cpsr
  STR r2, [r3, #60] @ guarda sp

  b taskA

undefined_instruction:
  b .
software_interrupt:
  b do_software_interrupt @ vai para o handler de interrupções de software
prefetch_abort:
  b .
data_abort:
  b .
not_used:
  b .
irq:
  b do_irq_interrupt @vai para o handler de interrupções IRQ
fiq:
  b .

do_software_interrupt: @Rotina de Interrupçãode software
  add r1, r2, r3 @r1 = r2 + r3
  mov pc, r14 @volta p/ o endereço armazenado em r14

do_irq_interrupt: @ Rotina de interrupções IRQ
  @ Corrige lr
  SUB lr, lr, #4

  STMFD sp!, {r10-r11}
  
  ADR r11, nproc @ r11 = endereco de nproc
  LDR r10, [r11] @ r10 = valor de nproc
  CMP r10, #0

  @ Guarda o r0 na primeira posição
  @ Usa r0 como base para indexar e armazena registradores
  STREQ r0, linhaA
  ADREQ r0, linhaA
  
  STRNE r0, linhaB
  ADRNE r0, linhaB
  
  LDMFD sp!, {r10-r11}
  
  ADD r0, r0, #4
  STMIA r0!, {r1-r12, lr}

  @ Guarda spsr
  MRS r1, spsr
  STMIA r0!, {r1}
  
  @ Mudando do modo para aramzenar sp e lr
  MRS r1, cpsr
  MSR cpsr_ctl, #0b11010011
  STMIA r0!, {sp, lr}
  MSR cpsr, r1
  @ ordem de armazenamento: r0 a r12 - pc - cpsr - sp - lr

  @@ Interrupçao
  LDR r0, INTPND @Carrega o registrador de status de interrupção
  LDR r0, [r0]
  TST r0, #0x0010 @verifica se é uma interupção de timer
  BLNE timer_irq

  @ Preparando o processo para a proxima task
  ADR r11, nproc @ r11 = endereco de nproc
  LDR r10, [r11] @ r10 = valor de nproc
  CMP r10, #0

  @@ Restaura todos os registradores para a proxima task
  ADREQ r0, linhaA
  ADRNE r0, linhaB
  ADD r0, r0, #68

  MRS   r1, cpsr
  MSR   cpsr_ctl, #0b11010011 @ Modo supervisor
  LDMDB r0!, {sp, lr} @ Restaura sp e lr
  vesp_saida:
  MSR   cpsr, r1 @ Sai modo supervisor

  LDMDB r0!, {r1}
  MSR   spsr, r1 @ Restaura spsr
  vespsr_saida:

  LDMDB r0, {r0 - r12, pc}^ @ Restaura r0-r12 e pc

  
timer_irq: 
  STMFD sp!, {r10-r11, lr}
  BL handler_timer @vai para o rotina de tratamento da interupção de timer
  
  ADR r11, nproc @ r11 = endereco de nproc
  LDR r10, [r11] @ r10 = valor de nproc
  CMP r10, #0

  @ Guarda o r0 na primeira posição
  @ Usa r0 como base para indexar e armazena registradores
  MOVEQ r10, #1    
  MOVNE r10, #0
  
  STR r10, [r11] @ Chaveamento de um processo para o outro

  LDMFD sp!, {r10-r11, lr}
  MOV pc, lr
  
timer_init:
  @ Enable timer0 interrupt
  LDR r0, INTEN
  LDR r1,=0x10 @bit 4 for timer 0 interrupt enable
  STR r1,[r0]

  @ Set timer value
  LDR r0, TIMER0L
  LDR r1, =0xff @setting timer value
  STR r1,[r0]

  @ Enable timer0 counting
  LDR r0, TIMER0C
  MOV r1, #0xE0 @enable timer module
  STR r1, [r0]

  @ Enable processor interrupt in CPSR
  mrs r0, cpsr
  bic r0,r0,#0x80
  msr cpsr_c,r0 @enabling interrupts in the cpsr

  mov pc, lr

linhaA:
  .space 68

linhaB:
  .space 68

nproc:
  .word 0x0
