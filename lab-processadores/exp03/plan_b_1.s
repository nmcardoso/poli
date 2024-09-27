@ Descrição do algoritmo
@ ----------------------
@ Item B.1 do planejamento
@ 
@ Algorítmo para testar os valores de imediato para
@ os comandos de processamento de dados (ex ADD)
@ e deslocamento (LSL)

.text
.global main

main:
    ADD r3,r7, #1023            @ adição com imediato
    SUB r11, r12, r3, LSL #32   @ subtração com shift
    LDR R7, =0x1                @ exit(0)
    SWI 0x0                     @ Termina o programa
