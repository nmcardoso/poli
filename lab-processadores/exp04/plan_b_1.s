.data
valor:  .space 64

.text
.globl main


main:
  LDR r0, =0x06
  LDR r1, =valor
  STR r0, [r1, #36]

  LDR r0, =0xFC
  @ LDR r1, =0x25
  STR r0, [r1, #37]

  LDR r0, =0x03
  @ LDR r1, =0x26
  STR r0, [r1, #38]

  LDR r0, =0xFF
  @ LDR r1, =0x27
  STR r0, [r1, #39]

  LDR r0, =0x24

  @ STR r1, =0x06
  @ STR r2, =0xFC
  @ STR r3, =0x03
  @ STR r4, =0xFF
  @ STR r0, =0x1

  LDRSB r1, [r0]
  LDRSH r1, [r0]
  LDR   r1, [r0]
  LDRB  r1, [r0]
