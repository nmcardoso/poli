@ Descrição do algoritmo
@ ----------------------
@ Exercício 10
@ Kernel simples com chaveamento de dois processos
@
@
@ Instruções de uso
@ -----------------
@ Em um terminal, executar:
@   make
@ Em outro terminal, executar:
@   make gdb
@
@ Ver Makefile para mais detalhes


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
  MRS r0, cpsr    @ salvando o modo original
  MSR cpsr_ctl, #0b11010010 @ alterando o modo para irq - o SP eh automaticamente chaveado ao chavear o modo
  LDR sp, =irq_stack_top @ inicializa pilha
  MSR cpsr, r0 @ volta para o modo original

  bl timer_init @ initialize interrupts and timer 
  bl stackB_init @ prepara linhaB
  b taskA @ começa a rodar task A
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
do_irq_interrupt: @Rotina de interrupções IRQ
  SUB lr, lr, #4  @ corrige lr

  STMFD sp!, {r10-r11} @ guarda r10 e r11 para podermos manipular regs
  
  LDR r11, =nproc
  LDR r10, [r11] @ r10 = id do processo

  CMP r10, #0  @ se proc 0 (A)
  STREQ r0, linhaA @ salva r0
  LDREQ r0, =linhaA @ r0 = linhaA[0]

  CMP r10, #1  @ se proc 1 (B)
  STREQ r0, linhaB @ salva r0
  LDREQ r0, =linhaB @ r0 = linhaB[0]
  
  LDMFD sp!, {r10-r11} @ restora r10 e r11 para erro original
  
  ADD r0, r0, #4 @ pula espaço que armazenamos r0
  STMIA r0!, {r1-r12, lr} @ armazena r1 a r12 e pc

  @ Guarda spsr
  MRS r1, spsr
  STMIA r0!, {r1} @ armazena cpsr
  
  @ Mudando do modo para aramzenar sp e lr
  MRS r1, cpsr
  MSR cpsr_ctl, #0b11010011
  STMIA r0!, {sp, lr}
  MSR cpsr, r1


  @**** Interrupção ****
  LDR r0, INTPND @Carrega o registrador de status de interrupção
  LDR r0, [r0]
  TST r0, #0x0010 @verifica se é uma interupção de timer
  BLNE proc_swap @vai para o rotina de tratamento da interupção de timer
  @ fim do tratamento da interrupção
  

  @ início da recuperação dos registradores
  LDR r1, =nproc
  LDR r1, [r1] @ id do proc

  CMP r1, #0 @ se proc A
  STREQ r0, linhaA @ r0 na primeira posição da linhaA
  LDREQ r0, =linhaA @ r0 = endereço de linhaA

  CMP r1, #1 @ se proc B
  STREQ r0, linhaB @ r0 na primeira posição da linhaB
  LDREQ r0, =linhaB @ r0 = endereço de linhaB

  ADD r0, r0, #68 @ última posição de linha B
  MRS r1, cpsr @ moda atual em r1
  MSR cpsr_ctl, #0b11010011 @ altera modo para supervisor
  LDMDB r0!, {sp, lr} @ desempilha sp e lr do modo supervisor
  MSR cpsr, r1 @ retorna para cpsr anterior
  LDMDB r0!, {r1} @ desempilha spsr do modo supervisor
  MSR spsr, r1 @ substitui spsr pelo valor da pilha
vesaida:
  LDMDB r0, {r0 - r12, pc}^ @ Restaura outro regs (pc recebe lr)

stackB_init:
  MRS r0, cpsr @ salva cpsr corrente
  LDR r1, _taskB @ pc da func taskB definida em handler.c
  SUB r2, sp, #0x500 @ valor de sp para taskB

  ADR r3, linhaB
  STR r1, [r3, #52] @ guarda pc
  STR r0, [r3, #56] @ guarda cpsr
  STR r2, [r3, #60] @ guarda sp
  MOV pc, lr @ retorna

proc_swap:
  STMFD sp!, {r10-r12, lr} @ guarda regs que vamos manipular
  BL handler_timer @vai para o rotina de tratamento da interupção de timer
  
  LDR r11, =nproc 
  LDR r10, [r11] @ id do proc

  LDR r12, =num_proc 
  LDR r12, [r12] @ numero de procs
  
  ADD r10, r10, #1 @ incrementa
  CMP r10, r12     @ se igual número de procs, vai pra 0 (porque proc a tem id = 0)
  MOVEQ r10, #0
  
  STR r10, [r11] @ salva id do proc

  LDMFD sp!, {r10-r12, lr} @ restaura regs alterados
  MOV pc, lr @ retorna

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

linhaA: .space 68
linhaB: .space 68
nproc: .word 0
num_proc: .word 2
