@ex_3_10_2b.s
    .text
    .globl main
main: 
    LDR r0, =0xFFFFFFFF @ carrega valor no primeiro registrador
    LDR r1, =0x80000000 @ carrega valor no segundo registrador
    LDR r2, =0x0        @ zera o reg. que armazena o resultado
    BL  firstfunc       @ chamada da função
    LDR r0, =0x0  
    LDR r7, =0x1 
    SWI 0x0             @ termina o programa
firstfunc:
    SMULLS r2, r3, r0, r1  @ calcula r3r2 = r0 * r1
    MOV pc, lr          @ retorna da função
