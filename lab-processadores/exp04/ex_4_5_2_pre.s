@ Descrição do algoritmo
@ ----------------------
@ Implementação da operação array[10] = array[5] + y
@ na forma pré-indexada
@
@
@ Lista de Registradores
@ ----------------------
@ r1 : valor y na operação acima
@ r2 : endereço base do array
@ r8 : valor do índide de acesso
@ r9 : valor do índice de armazenamento
@ r7 : registrador de trabalho
@
@
@ Instruções de uso
@ -----------------
@ arm build ex_4_5_2_pre.s (montagem)
@ arm debug (depuração) 

.text
.globl main

main:
  LDR r1, =100                @ valor de y
  LDR r2, =arr                @ posição base do array
  LDR r8, =5                  @ índice de load
  LDR r9, =10                 @ índice de store

  LDR r7, [r2, r8, LSL #2]    @ calcula a posição de memória relativa ao índice 5 (r8) do vetor e carrega arr[5] em r7
  ADD r7, r7, r1              @ adiciona o valor de y em r7
  STR r7, [r2, r9, LSL #2]    @ calcula a posição na memória de arr[10] e armazena o conteúdo de r7 em arr[10]
  SWI 0x0                     @ termina o programa


.data
  arr: .word 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
