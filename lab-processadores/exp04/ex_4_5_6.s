@ Descrição do algoritmo
@ ----------------------
@ Item 4.5.6
@ Implementação da sequência de Fibonacci. Com o resultado 
@ final f(n) armazenado no registrador R0.
@
@
@ Instruções de uso
@ -----------------
@ arm build ex_4_5_6.s (montagem)
@ arm debug (depuração) 

.text
.global main

main:
  ldr		r0, =fibonaci		@ carrega array em r0
  mov		r5, r0			    @ só para consultar na memória depois
  mov		r1, #10	 		    @ tamanho da sequência
  mov 	r2, #0 			    @ f(0)
  mov		r3, #1 			    @ f(1)
  str		r2, [r0]		    @ fib[0] = f(0)
  str 	r3, [r0, #4]	  @ fib[1] = f(1)
  sub		r1, r1, #1

loop:
  ldr		r2, [r0]		    @ carrega primeiro da soma em r2
  add		r0, r0, #4		  @ incrementa "ponteiro"
  ldr 	r3, [r0]		    @ carrega segundo da soma em r3
  add		r4, r3, r2		  @ soma os dois
  str		r4, [r0, #4]		@ guarda r4 em r0
  
  subs	r1, r1, #1		  @ decrementa contador 
  bne		loop			      @ se contador =1, para, se não continua
  b		  fim
  
fim: 
  mov		r0, r4			    @ resultado final em r0
  swi		0x0 			      @ resultado final em r4

  
.data
  fibonaci:
  .word 0, 0, 0, 0, 0, 0, 0, 0
.space 100 @ abrindo um espaco de 100 bytes para armazenar a array
.align 1 @ align to even bytes REQUIRED!!!
