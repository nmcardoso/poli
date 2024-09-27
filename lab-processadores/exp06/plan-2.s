.text
.global main

main:
  LDR r6, =a                @ carrega posição endereço base do vetor a em r6
  LDMIA r6, {r0,r4,r7,lr}   @ transferência multipla
  SWI 0x0                   @ termina o programa


.data
a:
  .word 10, 20, 30, 40, 50, 60, 70

.space 100  @ abrindo um espaco de 100 bytes para armazenar a array
.align 1    @ align to even bytes REQUIRED!!!
