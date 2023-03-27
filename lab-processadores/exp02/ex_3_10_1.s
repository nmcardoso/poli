@ex_3_10_1.s
    .text
    .globl main
main: 
    LDR r0, =0xFFFF0000 @ carrega valor no primeiro registrador
    LDR r1, =0x87654321 @ carrega valor no segundo registrador
    BL  firstfunc       @ chamada da função
    LDR r0, =0x0  
    LDR r7, =0x1 
    SWI 0x0             @ termina o programa
firstfunc:
    ADDS r2, r0, r1     @ calcula r2 = r0 + r1
    MOV pc, lr          @ retorna da função
