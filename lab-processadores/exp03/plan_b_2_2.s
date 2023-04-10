@ Multiplica o conteúdo de R4 por 255 e armazena em R2
@ 255 = 2^8 - 1

.text
.global main

main:
    LDR R4, =12             @ R4 = 12
    RSB R2, R4, R4, LSL #8  @ R2 = R4 * (2^8 - 1)
    LDR R7, =0x1            @ exit(0)
    SWI 0x0                 @ termina o programa
