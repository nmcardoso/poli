.text
.globl main

main:
  MOV r0, #10
  LDR r1, =4294967022
  ADDS r0,r0,r1
  BPL PosOrZ

done:      
  MOV r0, #0
  MOV pc, lr

PosOrZ:    
  MOV r0,#1
  B done
  SWI 0x0 

