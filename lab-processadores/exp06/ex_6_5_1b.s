@ Descrição do algoritmo
@ ----------------------
@ Implementa uma subrotina que executa a operação a = b * c + d 
@ usando apenas registradores. A subrotina espera que os endereços
@ b, c, d, e armazena o valor de a em r0
@
@
@ Lista de Registradores
@ ----------------------
@ R0 - Valor de a (resultado)
@ R1 - Endereço de b
@ R2 - Endereço de c
@ R3 - Endereço de d
@
@
@ Instruções de uso
@ -----------------
@ 1. montagem:    arm ex_6_5_1b.s
@ 2. depuração:   arm debug


.text
.global main

main:
  LDR r1, =b        @ carrega endereço de a
  LDR r2, =c        @ carrega endereço de c
  LDR r3, =d        @ carrega endereço de d
  BL  func          @ branch e link para função

fim:
  SWI 0             @ termina o programa

func:
  LDR r1, [r1]      @ r1 = a
  LDR r2, [r2]      @ r2 = c
  LDR r3, [r3]      @ r3 = d
  MUL r0, r1, r2    @ a = b * c
  ADD r0, r0, r3    @ a = a + d
  MOV pc, lr        @ retorna da função


.data
b: .word 4
c: .word 6
d: .word 1

.space 100  @ abrindo um espaco de 100 bytes para armazenar a array
.align 1    @ align to even bytes REQUIRED!!!
