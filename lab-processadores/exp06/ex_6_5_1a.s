@ Descrição do algoritmo
@ ----------------------
@ Implementa uma subrotina que executa a operação a = b * c + d 
@ usando apenas registradores. A subrotina espera que os 
@ parâmetros b, c. d estejam armazenados nos registradores 
@ r1, r2 e r3, respectivamente e escreve o resultado em r0
@
@
@ Lista de Registradores
@ ----------------------
@ R0 - Valor de a (resultado)
@ R1 - Valor de b
@ R2 - Valor de c
@ R3 - Valor de d
@
@
@ Instruções de uso
@ -----------------
@ 1. montagem:    arm ex_6_5_1a.s
@ 2. depuração:   arm debug


.text
.global main

main:
  LDR r1, =4    @ b = 4
  LDR r2, =6    @ c = 6
  LDR r3, =1    @ d = 1
  BL  func      @ branch e link para função
  SWI 0         @ termina o programa

func:
  MUL r0, r1, r2  @ a = b * c
  ADD r0, r0, r3  @ a = a + d
  MOV pc, lr      @ retorna da função
