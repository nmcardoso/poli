@ Descrição do algoritmo
@ ----------------------
@ Exercício 7.5.1
@ Algoritmo que liga os leds da placa sequencialmente
@
@
@ Lista de Registradores
@ ----------------------
@ R0 - Endereço do dispositivo
@ R1 - Estados ligado/desligado
@
@
@ Instruções de uso
@ -----------------
@ 1. montagem:    arm ex_7_5_1.s
@ 2. depuração:   arm debug

.text
.globl main

main:
    LDR R0, =0x3FF5000    @ IOPMOD
    LDR R1, =0xF0         @ seta 1 nos bits [7:4]
    STR R1, [R0]          @ seta IOPMOD como output
    LDR R1, =0            @ i = 0

acende_leds:
    LDR R0, =0x3FF5008    @ IOPDATA
    MOV R2, R1, LSL #4    @ i shiftado para [7:4]
    STR R2, [R0]          @ coloca i nos leds
    ADD R1, R1, #1        @ soma um no número
    CMP R1, #16           @ parar no 16
    BNE acende_leds       @ se 16 para, se não volta para acender próximo
fim:
    SWI 0x0
