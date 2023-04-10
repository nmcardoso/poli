@ Descrição do algoritmo
@ ----------------------
@ Algoritmo de divisão inteira usando subtrações
@ sucessivas
@
@
@ Destrição dos Registradores
@ ---------------------------
@ R1 - Dividendo (Numerador)
@ R2 - Divisor (Denominador)
@ R3 - Quociente
@ R5 - Resto
@
@
@ Instruções de uso
@ -----------------
@ arm build ex_3_10_7.s (montagem)
@ arm debug (depuração) 

.text
.global main

main:
    LDR R1, =12     @ Carrega dividendo/numerador
    LDR R2, =5      @ Carrega divisor/denominador

    MOV R5, R1      @ Inicia resto com valor de numerador
    LDR R3, =0      @ Inicia quociente com 0

    B while_loop    @ Inicio do loop de subtrações

    LDR R7, =0x1    @ exit(0)
    SWI 0x0         @ Termina o programa


while_loop:
    CMP R5, R2      @ Compara resto e denominador
    BLO while_done  @ Sai do loop caso resto < denom.

    SUB R5, R5, R2  @ Subtrai o valor do divisor do resto
    ADD R3, R3, #1  @ Incrementa o quociente

    B while_loop    @ Retorna ao loop


while_done:
