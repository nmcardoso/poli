@ Descrição do algoritmo
@ ----------------------
@ Exercício 7.5.3
@ Manipulação de um display de sete dígitos a partir
@ de um array armazenado na memória para mostrar um número
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
.global main

main:
  LDR	r0, =0x3ff5000 				  @ IOPMOD
  LDR	r1, =0x1FC00				    @ seta 1 nos bits [16:10]
  STR	r1, [r0]					      @ seta IOPMOD como output
  LDR r1, =memory					    @ r1 = palavra de memoria
  LDR	r2, =tabela_segmentos		@ carrega tabela de segmentos
acende_led:
  LDR		r0, =0x3ff5008 			  @ IOPDATA
  LDR		r1, [r1]
  LDR		r3, [r2, r1, LSL #2]	@ r3 = tabela_segmentos[palavra de memoria]
  STR 	r3, [r0]				      @ coloca tabela_segmentos[palavra de memoria] nos leds
fim:
  SWI 0x123456                @ finaliza execução

data:
  memory:
    .word 5
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
