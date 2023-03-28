@ item-2-2.s
@ Exercício 2.2 - Planejamento
@ Adiciona dois números usando ADDS, que altera as flags
@ do registrador CPRS
  .text
  .globl main
main:
  MOV	r0, #15	      @ carrega valor no primeiro registrador
  MOV	r1, #20       @ carrega valor no segundo registrador
  BL	firstfunc     @ desvia para funcao, coloca o enderenco 
                    @ de retorno em R14 ou LR (link register).		
  MOV	r0, #0x0		  @ zera registrador
  MOV	r7, #0x1      @ exit(0)	
  SWI	0x0	          @ system call
firstfunc:
  ADDS	r0, r0, r1	@ calcula soma r0 = r0 + r1
  MOV	pc, lr	      @ retorna da funcao
