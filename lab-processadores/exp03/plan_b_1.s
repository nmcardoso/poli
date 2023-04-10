.text
.global main

main:
    ADD r3,r7, #1023            @ adição com imediato
    SUB r11, r12, r3, LSL #32   @ subtração com shift
    LDR R7, =0x1                @ exit(0)
    SWI 0x0                     @ Termina o programa
