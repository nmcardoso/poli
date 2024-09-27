@ Descrição do algoritmo
@ ----------------------
@ Exercício 7.5.4
@ Mostra o conteúdo de um array armazenado na memória
@ no display de 7 segmentos
@
@
@ Lista de Registradores
@ ----------------------
@ R0 - IOPMOD
@ R1 - Máscara de leitura/escrita no dispositivo
@ R2 - Posição base da tabela de segmentos
@ R3 - Tamanho do array
@ R4 - Valor da tabela de segmentos
@
@
@ Instruções de uso
@ -----------------
@ 1. montagem:    gcc item-7-5-4.s
@ 2. depuração:   e7t


.text
.global main

main:
  LDR	  r0, =0x3ff5000 				  @ IOPMOD
  LDR	  r1, =0x1FC00				    @ seta 1 nos bits [16:10]
  STR	  r1, [r0]					      @ seta IOPMOD como output
  LDR   r1, =memory					    @ r1 = palavra de memoria
  LDR	  r2, =tabela_segmentos		@ carrega tabela de segmentos
  LDR   r3, =size               @ carrega tamanho array 
  LDR   r3, [r3]                @ tamanho array
  MOV   r5, #0                  @ contador
  LDR		r0, =0x3ff5008 			    @ IOPDATA
  LDR 	r6, =0xFFFFF			      @ contador para delay
loop:
delay:
  SUBS 	r6, r6, #1			        @ subtrai um do contador
  BNE 	delay				            @ se > zero, loop
acende:
  LDR		r4, [r1, r5, LSL #2]    @ r4 = array[i]
  LDR		r4, [r2, r4, LSL #2]	  @ r4 = tabela_segmentos[palavra de memoria]
  STR 	r4, [r0]				        @ coloca tabela_segmentos[palavra de memoria] nos leds
  ADD     r5, r5, #1            @ incrementa i
  CMP     r5, r3                @ compara com tamanho
  LDR 	r6, =0xFFFFF			      @ contador para delay
  BNE     loop                  @ se não for igual, continua
fim:
  SWI 0x123456                  @ finaliza execução

data:
  memory:
    .word 	5, 2, 3, 7, 9, 10
  size:
    .word   6
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
