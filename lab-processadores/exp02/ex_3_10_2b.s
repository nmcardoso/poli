@ ex_3_10_2b.s
@ Exercício 3.10.2 - usando multiplicação longa
@
@ Descrição:
@ Multiplicação entre dois números usando dois registradores
@ para armazenar o resultado
@
@ Instrução de montagem:
@ arm build ex3_10_2b.s
@
@ Instrução de depuração:
@ arm debug
    .text
    .globl main
main: 
    LDR r0, =0xFFFFFFFF @ carrega valor no primeiro registrador
    LDR r1, =0x80000000 @ carrega valor no segundo registrador
    LDR r2, =0x0        @ zera o reg. que armazena o resultado
    BL  firstfunc       @ chamada da função
    LDR r7, =0x1        @ exit(0)
    SWI 0x0             @ termina o programa
firstfunc:
    SMULLS r2, r3, r0, r1  @ calcula r3r2 = r0 * r1
    MOV pc, lr          @ retorna da função
