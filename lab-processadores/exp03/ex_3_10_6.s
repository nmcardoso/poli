@ Descrição do algoritmo
@ ----------------------
@ Algoritmo de obtenção do valor absoluto de um
@ número armazenado no registrador R0
@
@
@ Descrição dos Registradores
@ ---------------------------
@ R0 - Número a ser calculado o valor absoluto
@
@
@ Instruções de uso
@ -----------------
@ arm build ex_3_10_6.s (montagem)
@ arm debug (depuração) 

.text
.global main

main:
    LDR R0, =-360     @ Carrega operando

    CMP R0, #0        @ Compara R0 com 0
    RSBLT R0, R0, #0  @ Efetua R0 = 0 - R0 condicionalmente,
                      @ se R0 < 0

    LDR R7, =0x1      @ exit(0)
    SWI 0x0           @ Termina o programa
