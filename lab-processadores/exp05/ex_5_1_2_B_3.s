.text
.globl main

main:
  mov r0, #10           @ valor de x
  ldr r1, =230          @ valor de y = 230

  adds  r0, r0, r1      @ calcula x + y e atualiza flags CPRS
  movpl r0, #0          @ r0 = 0, se x + y >= 0
  movmi r0, #1          @ r0 = 1, se x + y < 0
  swi   0x0             @ termina o programa
