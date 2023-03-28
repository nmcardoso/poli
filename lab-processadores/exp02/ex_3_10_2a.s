@ ex_3_10_2a.s
@ Exercício 3.10.2 - usando multiplicação simples
@
@ Descrição:
@ Cálculo do produto entre dois números, atualizando as
@ flags do registrador CPSR
@
@ Instrução de montagem:
@ arm build ex3_10_2a.s
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
    MULS r2, r0, r1     @ calcula r2 = r0 * r1
    MOV pc, lr          @ retorna da função
