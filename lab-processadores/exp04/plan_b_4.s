@ Descrição do algoritmo
@ ----------------------
@ Implementação do algoritmo
@ for (i=0; i<8; i++) {
@   a[i] = b[7-i];
@ }
@ em linguagem de montagem
@
@ Instruções de uso
@ -----------------
@ arm build plan_b_4.s (montagem)
@ arm debug (depuração) 

.data
  a:
  .word 0,0,0,0,0,0,0,0
  b:
  .word 1,2,3,4,5,6,7,8


.text
.globl main

main:  
  LDR r0, =a @ r0 apota para vetor a
  LDR r1, =b @ r1 aponta para vetor b
  MOV r2, #0 @ contador (i)
  MOV r3, #8 @ tamanho do vetor

loop:
  CMP r2, r3  @ verifica se chegou se as it. terminaram
  BEQ end_loop  @ se terminou, salta para fim do loop
  RSB r4, r2, #7 @ r4 = 7 - contador
  LDR r5, [r1, r4, LSL #2] @ armazena em r5 o valor na posição 7-i do vetor b 
  MOVS r6, r2, LSL #2 @ move o cursor para próxima palavra (4 bytes)
  CMP r6, #0 @ verifica se é a primeira palavra do vetor
  STREQ r5, [r0] @ a = b[7 - i], se r6 = 0 (primeio elemento)
  STRNE r5, [r0, r6] @ demais elementos
  ADD r2, r2, #1 @ incrementa contador
  B loop @ retorna para loop

end_loop:
  SWI 0x0 @ envia sinal de terminação para SO
