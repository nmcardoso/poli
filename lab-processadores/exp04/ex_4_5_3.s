.text
.global main

main:
  LDR 	r1, =a		  	        @ r1 = a 
  LDR 	r2, =b		  	        @ r2 = b
  MOV 	r3, #0		  	        @ i = 0
  MOV 	r4, #5		  	        @ c = 5 (constante arbitraria)
  MOV	  r6, r1			          @ copia endereço de a

loop:
  CMP 	r3, #10		  	        @ compara r3 com 10
  BGT 	fim			              @ encerra loop se i > 10 
  LDR 	r5, [r2, r3, LSL #2]  @ se i != 0, r2 = b[i]
  ADD 	r5, r5, r4		        @ r5 = b[i] + c
  STR 	r5, [r1, r3, LSL #2]  @ a[i] = r5
  ADD	  r3, r3, #1            @ incrementa r3 em 1 unidade
  B	loop                      @ retorna ao loop

fim:
  SWI 	0x123456              @ termina a execução


.data
a:
  .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
b:
  .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

.space 100 @ abrindo um espaco de 100 bytes para armazenar a array
.align 1 @ align to even bytes REQUIRED!!!
