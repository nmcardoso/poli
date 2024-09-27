@ Descrição do algoritmo
@ ----------------------
@ Exercício 7.5.8
@ Armazena valor do switch em uma posição de memória
@
@
@ Lista de Registradores
@ ----------------------
@ R0 - IOPMOD
@ R1 - Máscara de leitura/escrita no dispositivo
@ R2 - IOPDATA
@ R3 - Valor do switch
@ R4 - Endereço da memória
@ R5 - Elemento da Tabela de segmentos
@
@
@ Instruções de uso
@ -----------------
@ 1. montagem:    gcc item-7-5-8.s
@ 2. depuração:   e7t


.text
.global main

main:
  LDR	r0, =0x3ff5000 		        @ IOPMOD
  LDR	r1, =0x1FC00		          @ seta 0 em [3:0] e 1 em [16:10]
  LDR r4, =tabela_segmentos     @ pega endereço de tabela_segmentos
  STR	r1, [r0]		              @ seta IOPMOD como input para [3:0] e output para [16:10]
  LDR	r2, =0x3ff5008 		        @ IOPDATA
  LDR r3, [r2]		              @ le switches [3:0]
  LDR r5, [r4, r3, LSL #2]      @ tabela_segmentos[r3] 
  STR	r5, [r2]		              @ valor dos switches nos display
fim:
  SWI 0x123456
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
