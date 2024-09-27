@ Descrição do algoritmo
@ ----------------------
@ Implementação da sequência de Fibonacci
@
@
@ Instruções de uso
@ -----------------
@ arm build 8914122.s (montagem)
@ arm debug (depuração) 

.text
.global main
main:
  ldr		r0, =array		@ carrega array em r0
  mov		r1, #22	 		  @ tamanho da sequência
  mov		r6, r1			  @ copia do tamanho
  mov 	r2, #0 			  @ f(0)
  mov		r3, #1 			  @ f(1)
  str		r2, [r0]		  @ fib[0] = f(0)
  str 	r3, [r0, #4]	@ fib[1] = f(1)
  sub		r1, r1, #1    @ decrementa r1

loop:
  ldr		r2, [r0]		  @ carrega primeiro da soma em r2
  add		r0, r0, #4		@ incrementa "ponteiro"
  ldr 	r3, [r0]		  @ carrega segundo da soma em r3
  adds	r4, r3, r2		@ soma os dois
  bmi		negativo
  str		r4, [r0, #4]	@ guarda r4 em r0	
  subs	r1, r1, #1		@ decrementa contador 
  bne		loop			    @ se contador =1, para, se não continua
  b		  fim

negativo:
  mov		r4, r3			  @ volta para maior número não negativo

fim: 
  ldr 	r5, = ultimo 	@ carrega ultimo na memória
  str		r4, [r5]		  @ salva resultado em ultimo
  mov		r0, r6

pronto:	
  swi		0x0 			    @resultado final em r4
  
  
.data
  array:
    .space 400 @abrindo um espaco de 100 bytes para armazenar a array

  ultimo:
    .word 0
