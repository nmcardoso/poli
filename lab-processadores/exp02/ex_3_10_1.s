@ ex_3_10_1.s
@ Exercício 3.10.1
@ Programa para calcular a soma entre dois números atualizando
@ as flags do registrador CPSR
    .text
    .globl main
main: 
    LDR r0, =0xFFFF0000 @ carrega valor no primeiro registrador
    LDR r1, =0x87654321 @ carrega valor no segundo registrador
    BL  firstfunc       @ chamada da função
    LDR r7, =0x1        @ exit(0)
    SWI 0x0             @ termina o programa
firstfunc:
    ADDS r2, r0, r1     @ calcula r2 = r0 + r1
    MOV pc, lr          @ retorna da função
