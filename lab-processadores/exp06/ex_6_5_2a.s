@ Descrição do algoritmo
@ ----------------------
@ Implementa do algoritmo Bubble Sort. Recebe um array
@ e ornada seus elementos.
@
@
@ Lista de Registradores
@ ----------------------
@ R1 - Endereço base do vetor a
@ R2 - Tamanho do vetor
@ R3 - Contador maior
@ R4 - Contador menor
@ R5-R9 - Registradores de Trabalho
@
@
@ Instruções de uso
@ -----------------
@ 1. montagem:    arm ex_6_5_2a.s
@ 2. depuração:   arm debug

.text
.global main

main:
  LDR   r1, =a        @ carrega o valor base do vetor a
  LDR   r2, =size     @ carrega a posição de size
  LDR   r2, [r2]      @ carrega o valor de size
  MOV   r3, #0        @ inicialização do contador maior
  MOV   r4, #0        @ inicialização do contador menor
  SUB   r9, r2, #1    @ r9 = tamanho - 1

loop_menor:
  MOV   r7, r4                @ copia contador menor
  ADD   r8, r7, #1            @ incrementa contador menor
  LDR   r5, [r1, r7, LSL #2]  @ carrega elemento atual
  LDR   r6, [r1, r8, LSL #2]  @ carrega elemento subsequente
  CMP   r5, r6                @ compara r5 e r6
  BLGT  swap                  @ troca r5 com r6 se r5 > r6
  STR   r5, [r1, r7, LSL #2]  @ carrega elemento atual
  STR   r6, [r1, r8, LSL #2]  @ carrega elemento subsequente
  ADDS  r4, r4, #1            @ incrementa contador menor
  CMP   r4, r9                @ compara contador menor com tamanho
  BEQ   teste_loop_maior      @ salta para teste se r4 = r9
  B     loop_menor            @ retorna ao loop

teste_loop_maior:
  CMP   r3, r9        @ compara contador maior com tamanho do vetor
  ADD   r3, r3, #1    @ incrementa contador maior
  BEQ   fim           @ salta para fim se chegar ao fim do vetor
  MOV   r4, #0        @ reinicializa contador menor
  B     loop_menor    @ volta para o loop

fim:
  SWI   0x0           @ fim da execução

swap:                 @ troca os valores de r5 e r6 e retorna
  EOR   r5, r5, r6    @ r5 = r5 xor r6
  EOR   r6, r5, r6    @ r6 = r5 xor r6
  EOR   r5, r5, r6    @ r5 = r5 xor r6
  MOV   pc, lr        @ retorna da subrotina


.data
a:
  .word 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
size:
  .word 10

.space 100
.align 1
