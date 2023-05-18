.text
.global main

main:
  LDR r0, =0x13             @ inicializa r0
  LDR r1, =0xffffffff       @ inicializa r1
  LDR r2, =0xeeeeeeee       @ inicializa r2
  LDR r3, =a                @ carrega posição endereço base do vetor a em r3
  LDMIA r3!, {r0,r1,r2}     @ transferência multipla
  LDR 	r4, [r3]
  SWI 0x0                   @ termina o programa


.data
a:
  .word 0xbabe0000, 0x12340000, 0x00008888, 0xfeeddeaf, 0x1

.space 100  @ abrindo um espaco de 100 bytes para armazenar a array
.align 1    @ align to even bytes REQUIRED!!!
