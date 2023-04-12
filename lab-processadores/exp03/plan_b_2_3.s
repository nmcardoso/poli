@ Descrição do algoritmo
@ ----------------------
@ Item B.2.c do planejamento
@
@ Multiplica o conteúdo de R4 por 18 e armazena em R2
@ 18 = 2 * 9 = 2 * (2^3 + 1)

.text
.global main

main:
    LDR R4, =12             @ R4 = 12
    MOV R2, R4, LSL #1      @ R2 = R4 * 2
    ADD R2, R2, R2, LSL #3  @ R2 = R2 * 9
    LDR R7, =0x1            @ exit(0)
    SWI 0x0                 @ termina o programa
