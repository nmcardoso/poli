@ Descrição do algoritmo
@ ----------------------
@ Item 4.5.4.b: 
@ Inicialia array com zeros usando ponteiros
@
@
@ Instruções de uso
@ -----------------
@ arm build ex_4_5_4_pointer.s (montagem)
@ arm debug (depuração) 

.text
.global main

main:
  LDR 	r1, =a		  	      @ r1 = a 
  MOV 	r2, #5		  	      @ s = 5
  MOV	  r4, #0			        @ constante 0
  ADD	  r2, r1, r2, LSL #2	@ r2 = &array[s] 

loop:
  CMP 	r1, r2		  	      @ compara r1 com r2
  BEQ 	fim			            @ encerra loop se i = s
  STR 	r4, [r1]  		      @ a[i] = 0
  ADD 	r1, r1, #4		      @ incremente r1 com 1 word
  B	loop    
                  @ retorna para o loop
fim:
  SWI 	0x123456            @ termina o programa
  
.data
a:
  .word 1, 2, 3, 4, 5

.space 100 @abrindo um espaco de 100 bytes para armazenar a array
.align 1 @ align to even bytes REQUIRED!!!
