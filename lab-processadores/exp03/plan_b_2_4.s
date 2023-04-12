@ Descrição do algoritmo
@ ----------------------
@ Item B.2.d do planejamento
@
@ Multiplica o conteúdo de R4 por 16384 e armazena em R2
@ 16384 = 2^14

.text
.global main

main:
    LDR R4, =12             @ R4 = 12
    MOV R2, R4, LSL #14     @ R2 = R4 * (2^14)
    LDR R7, =0x1            @ exit(0)
    SWI 0x0                 @ termina o programa
