@ Descrição do algoritmo
@ ----------------------
@ Exercício 7.5.3
@ Mnipulação de um display de sete dígitos a partir
@ de um array armazenado na memória
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
@ 1. montagem:    gcc item-7-5-3.s
@ 2. depuração:   e7t


.text
.globl main

main:
    LDR R0, =0x3FF5000        @ IOPMOD
    LDR R1, =0xF0             @ seta 1 nos bits [7:4]
    STR R1, [R0]              @ seta IOPMOD como output
    LDR R1, =0                @ i = 0
    LDR R2, tabela_segmentos  @ carrega tabela de segmentos

acende_leds:
    LDR R0, =0x3FF5008        @ IOPDATA
    LDR R3, [R2, R1, LSL #2]  @ r3 = tabela_segmentos[i]
    STR R3, [R0]              @ coloca i nos leds
    ADD R1, R1, #1            @ soma um no número
    CMP R1, #16               @ parar no 16
    BNE acende_leds           @ se 16 para, se não volta para acender próximo
fim:
    SWI 0x0

data:
  tabela_segmentos:
    .space 15   @ valores corretos para marcar os números a serem acendidos na posição correspondente
