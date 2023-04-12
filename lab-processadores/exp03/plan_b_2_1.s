@ Descrição do algoritmo
@ ----------------------
@ Item B.2.a do planejamento
@
@ Multiplica o conteúdo de R4 por 132 e armazena em R2
@ Fatoração de 132: 3*4*11
@ Assim, R2 = R4*132 = R4*3*4*11


.text
.global main

main:
    LDR R4, =12             @ R4 = 12
    MOV R2, R4, LSL #2      @ R2 = R4 * 2^2
    ADD R2, R2, R2, LSL #5  @ R2 = R2 * (2^5 - 1)
    LDR R7, =0x1            @ exit(0)
    SWI 0x0                 @ termina o programa
