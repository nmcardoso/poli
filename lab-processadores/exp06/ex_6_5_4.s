@ Descrição do algoritmo
@ ----------------------
@ Implementação de uma pilha
@
@
@ Lista de Registradores
@ ----------------------
@ R0 - Tipo de dado da elemento
@ R1 - Registrador estrito/lido pela pilha
@ R13 - Endereço da pilha
@
@
@ Instruções de uso
@ -----------------
@ 1. montagem:    arm ex_6_5_4.s
@ 2. depuração:   arm debug


.text
.globl main

main:
  LDR   r13, =stack       @ r13 recebe endereço de memória da pilha
e1:
  LDR   r0, =1            @ tipo de dado: byte
  LDR   r1, =1            @ valor: 1
  BL    push              @ push na pilha
e2:
  LDR   r0, =2            @ tipo de dado: half-word
  LDR   r1, =160          @ valor: 160
  BL    push              @ push na pilha
e3:
  BL    pop               @ pop na pilha
e4:
  LDR   r0, =4            @ tipo de dado: word
  LDR   r1, =3500         @ valor: 3500
  BL    push              @ push na pilha
e5:
  BL    pop               @ pop na pilha
e6:
  BL    pop               @ pop na pilha
fim:
  SWI   0                 @ termina execução


push:
  RSB   r2, r0, #4        @ r2 = 4 - r0
  LSL   r2, #3            @ calcula bits a serem deslocados
  LSL   r1, r2            @ shift left + shift right para fazer o
  LSR   r1, r2            @ truncamento da palavra para o tipo de dado
  SUB   r13, r13, #4      @ decrementa r13
  STR   r1, [r13]         @ armazena em stack[r13] o valor de r1
  MOV   pc, lr            @ retorna da função


pop:
  LDR   r1, [r13]         @ armazena em r1 o valor de stack[r13]
  ADD   r13, r13, #4      @ incrementa r13
  MOV   pc, lr            @ retorna da função


.data
stack: .space 80

.space 100
.align 1
