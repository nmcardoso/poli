@ Descrição do algoritmo
@ ----------------------
@ Implementa uma subrotina que executa a operação a = b * c + d 
@ usando apenas registradores. A subrotina espera que os valores
@ dos parâmetros b, c, d estejam na pilha.
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
@ 1. montagem:    arm ex_6_5_1b.s
@ 2. depuração:   arm debug

.text
.globl main


main:
  LDR   r1, =4          @ carrega valor de b em r1
  LDR   r2, =6          @ carrega valor de c em r2
  LDR   r3, =1          @ carrega valor de d em r3
  STMFA r13!, {r1-r3}   @ empilha b,c,d
  STMFA r13!, {r1-r3}   @ empilha b,c,d
  LDR   r1, =0          @ zera registradores
  LDR   r2, =0          @ zera registradores
  LDR   r3, =0          @ zera registradores
  BL    func1           @ branch and link para func1
  LDR   r1, =0          @ zera registradores
  LDR   r2, =0          @ zera registradores
  LDR   r3, =0          @ zera registradores
  BL    func2           @ branch and link para func2

fim:
  SWI   0               @ termina execução

func1:
  LDMFA r13!, {r1-r3}   @ carrega params. em r1, r2, r3
  MUL r0, r1, r2        @ a = b * c
  ADD r0, r0, r3        @ a = a + d
  MOV pc, lr            @ retorna da função

func2:
  LDMFA r13!, {r1-r3}   @ carrega params. em r1, r2, r3
  MUL r0, r1, r2        @ a = b * c
  ADD r0, r0, r3        @ a = a + d
  MOV pc, lr            @ retorna da função
