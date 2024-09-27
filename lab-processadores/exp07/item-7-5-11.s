@ Descrição do algoritmo
@ ----------------------
@ Exercício 7.5.11
@ Conta as mudanças de estado do switch e exibe no
@ display de 7 segmentos
@
@
@ Lista de Registradores
@ ----------------------
@ R0 - IOPMOD
@ R1 - Posição base da tabela de segmentos
@ R2 - Endereço do dispositivo
@ R3 - Valor lido da placa
@ R4 - Último valor do switch
@ R5 - Contador de mudanças de estado
@ R6 - Valor da tabela de segmentos correspondente ao valor atual do switch
@ R7 - Define leitura/escrita dos dispositivos
@ R8 - Máscara do switch
@
@
@ Instruções de uso
@ -----------------
@ 1. montagem:    gcc item-7-5-11.s
@ 2. depuração:   e7t


.text
.global main

main:
    LDR R0, =0x3ff5000          @ IOPMOD
    LDR	R1, =tabela_segmentos		@ carrega tabela de segmentos
    LDR R2, =0x3ff5008          @ IOPDATA
    LDR R7, =0x1FC00            @ seta 0 em [3:0] e 1 em [16:10]
    LDR R8, =0xf                @ máscara do switch
    STR R7, [R0]                @ seta IOPMOD como input para [3:0] e output para [7:4]
    LDR R3, [R2]                @ lê dados
    AND R3, R3, R8              @ aplica máscara para obter valor do switch
    MOV R4, R3                  @ valor dos switches no registrador auxiliar
    LDR R5, =0                  @ inicializa contador com 0
loop:
    LDR R3, [R2]                @ le switches [3:0]
    AND R3, R3, R8              @ aplica máscara para obter valor do switch
    CMP R3, R4                  @ compara r3 com r4
    BNE incrementa              @ incrementa se r3 != r4
    B   loop                    @ volta para o loop
incrementa:
    CMP R5, #15                 @ compara mudança de estado com valor máximo
    BGT fim                     @ finaliza loop se mudança de estado > 15
    LDR R6, [R1, R5, LSL #2]	  @ R6 = tabela_segmentos[palavra de memoria]
    STR R6, [R2]                @ seta IOPMOD como input para [3:0] e output para [7:4]
    ADD R5, R5, #1              @ incrementa contador
    MOV R4, R3                  @ atualiza registrador auxiliar de estado
    B   loop                    @ volta para o loop            
fim:
    SWI 0x0                     @ finaliza execução


data:
  tabela_segmentos:
    .word	0b010111110000000000	@0
    .word	0b000001100000000000	@1
    .word	0b001110110000000000	@2
    .word	0b001011110000000000	@3
    .word	0b011001100000000000	@4
    .word	0b011011010000000000	@5
    .word	0b011111010000000000	@6
    .word	0b000001110000000000	@7
    .word	0b011111110000000000	@8
    .word	0b011011110000000000	@9
    .word	0b011101110000000000	@A
    .word	0b011111000000000000	@B
    .word	0b010110010000000000	@C
    .word	0b001111100000000000	@D
    .word	0b011110010000000000	@E
    .word	0b011100010000000000	@F
