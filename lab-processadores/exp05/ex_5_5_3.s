@ Descrição do algoritmo
@ ----------------------
@ Encontra o máximo valor de um array de inteiros
@ 32-bits sem sinal e armazena o valor encontrado
@ no registrador r4
@
@
@ Lista de Registradores
@ ----------------------
@ r1 : endereço base do vetor a
@ r2 : contador
@ r4 : máximo valor encontrado
@ r5 : tamanho do vetor a
@
@
@ Instruções de uso
@ -----------------
@ arm build ex_5_5_3.s (montagem)
@ arm debug (depuração) 

.text
.global main

main:
  LDR r1, =a	  @ r1 = a 
  MOV r5, #8		@ r5 = 8 (tamnho da sequência)
  MOV	r2, #0		@ r2 = 0
  LDR	r4, [r1]	@ r4 = a[0]

loop:
  CMP   r2, #10		  	        @ compara r3 com 10
  BEQ	  fim                   @ sai do loop se contador = 10
  LDR	  r3, [r1, r2, LSL #2]	@ r3 recebe a[i]
  CMP	  r3, r4                @ compara a[i] com o maior valor atual
  MOVGT	r4, r3                @ r4 = a[i], se r4 > a[i]
  ADD	  r2, r2, #1            @ incrementa contador
  B	    loop                  @ retorna ao loop

fim:
  SWI 	0x123456              @ termina execução
  
.data
a:
  .word 5, 2, 3, 1, 8, 4, 2, 15

.space 100  @ abrindo um espaco de 100 bytes para armazenar a array
.align 1    @ align to even bytes REQUIRED!!!
