@ Descrição do algoritmo
@ ----------------------
@ Reconhece uma padrão genérico em uma sequência
@ de bits
@
@
@ Lista de Registradores
@ ----------------------
@ r1 : entrada X
@ r2 : saída - posições onde o padrão foi encontrado
@ r3 : contador
@ r8 : padrão a ser detectado
@ r9 : número de bits do padrão
@
@
@ Instruções de uso
@ -----------------
@ arm build 8914122.s (montagem)
@ arm debug (depuração)


.text
.global main

main:
  LDR 	r1, =0x5555AAAA	  @ r1 = x 
  LDR 	r2, =0		  	    @ r2 = z
  MOV 	r3, #0		  	    @ i = 0
  LDR	  r8, =5		        @ padrão a ser reconhecida
  LDR	  r9, =3		        @ tamanho em bits do padrão
  MOV 	r4, #32		  	    @ r4 = tamanho da sequência
  SUB	  r7, r4, r9		    @ r7 =tamanho sequência- tamanho do reconhecido
  RSB	  r5, r4, #32		    @ r5 = 32 - tamanho da sequência
  RSB	  r10, r9, #32		  @ tamanho da palavra - tamanho da sequência a ser reconhecida

loop:
  CMP 	r3, r7		  	    @ compara r3 com r4- condição de parada
  BGT 	fim			          @ encerra loop se maior
  ADD	  r6, r5, r3		    @ r6 = tamanho da palavra - tamanho da sequência + i
  MOV	  r6, r1, LSL r6		@ r6 = trecho de 4 bits a ser analisado deslocado p/ esquerda
  MOV	  r6, r6, LSR r10		@ desloca para direita para isolar segmento de 4 bits

setado:					          @ label para ajudar a imprimir os valores
  CMP	  r6, r8			      @ compara r6 com sequência fornecida
  ADDEQ	r2, r2, #1		    @ 1 em r2 se for igual
  MOV	  r2, r2, LSL #1		@ também passa r2 para próximo bit
  ADD	  r3, r3, #1		    @ incrementa contador
  B	loop

fim:
  MOV	  r2, r2, LSR #1		@ corrige o shift left a mais da última iteração

pronto:	
  SWI 	0x123456
