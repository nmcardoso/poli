@ Descrição do algoritmo
@ ----------------------
@ Exercício 7.5.5
@ Liga os segmentos do display led baseado nos valores
@ do DIP Switch
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
@ 1. montagem:    gcc item-7-5-5.s
@ 2. depuração:   e7t


.text
.global main

main:
    LDR R0, =0x3ff5000  @ IOPMOD
    LDR R1, =0xf0       @ seta 0 em [3:0] e 1 em [7:4]
    STR R1, [R0]        @ seta IOPMOD como input para [3:0] e output para [7:4]
    LDR R2, =0x3ff5008  @ IOPDATA
    LDR R3, [R2]        @ le switches [3:0]
    MOV R3, R3, LSL #4  @ shifta para [7:4]
    STR R3, [R2]        @ valor dos switches nos leds
fim:
    SWI 0x0             @ finaliza execução
