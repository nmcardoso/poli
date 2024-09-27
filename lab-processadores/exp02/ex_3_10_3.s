@ ex_3_10_3.s
@ Exercício 3.10.3
@
@ Descrição:
@ Algoritmo de multiplicação eficiente utilizando deslocamento
@ lógico para esquerda para multiplicar um número por 32
@
@ Instrução de montagem:
@ arm build ex3_10_3.s
@
@ Instrução de depuração:
@ arm debug
    .text
    .globl main
main: 
    LDR r0, =0x95A      @ carrega valor no primeiro registrador
    LDR r2, =0x0        @ zera o reg. que armazena o resultado
    BL  firstfunc       @ chamada da função
    LDR r7, =0x1        @ exit(0)
    SWI 0x0             @ termina o programa
firstfunc:
    LSLS r2, r0, #5     @ calcula r2 = r0 * 2^5
    MOV pc, lr          @ retorna da função
