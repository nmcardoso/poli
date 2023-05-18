.text
.global main

main:
  LDR r0, =0x12340000       @ inicializa r0
  LDR r1, =0xbabe2222       @ inicializa r1
  LDR r2, =0x0              @ inicializa r2
  LDR r3, =0x0              @ inicializa r3
  LDR r4, =0x0              @ inicializa r4
  LDR r5, =0x0              @ inicializa r5
  LDR r13, =arr             @ carrega posição endereço base

e_a:
  STMDB r13!, {r1}          @ carrega valor do estado A

e_b:
  STMDB r13!, {r0}          @ carrega valor do estado B

e_c:
  STMDB r13!, {r0,r1}       @ descarrega valores do estado C
  LDMIA r13!, {r2,r3,r4,r5}   

fim:
  SWI 0x0                   @ termina o programa


.data
arr:
  .word 0xfeeddeaf, 0x1

.space 100  @ abrindo um espaco de 100 bytes para armazenar a array
.align 1    @ align to even bytes REQUIRED!!!
