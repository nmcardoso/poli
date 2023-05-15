@ Descrição do algoritmo
@ ----------------------
@ Algoritmo de divisão inteira
@
@
@ Lista de Registradores
@ ----------------------
@ R0 - Dividendo (Numerador)
@ R1 - Divisor (Denominador)
@ R2 - Quociente
@ R3 - Resto
@
@
@ Instruções de uso
@ -----------------
@ 1. montagem:    arm build terca-b6-t2-t1-parte1a1b-8914122.s
@ 2. depuração:   arm debug

.text
.global main


main:
  LDR   r0, =12         @ valor de N = 12

pronto:
  SUB   r1, r0, #1      @ r1 = N-1

menosum:  
  MOV r2, #0			      @ inicializa quociente
  MOV r3, #0			      @ inicializa resto
  MOV	r4, r1			      @ copia de divisor
  MOV r9, r0            @ copia do dividendo
  MOV r7, #0			      @ inicializa contador
  MOV	r6, #1			      @ constante = 1
alinhamento:
  MOV r4, r4, LSL #1		@ divisor shiftado para esquerda
  ADD	r7, r7, #1		    @ incrementa contador de shifts
  CMP r4, r9			      @ verifica se o divisor é maior que o dividendo
  BLT alinhamento		    @ volta para mais um shift left
  MOV	r4, r4, LSR #1		@ garantia que ao final do loop da pra dividir um pelo outro
  SUB	r7, r7, #1		    @ decrementa o contador após o shift right
loop:
  CMP	r9, r4			          @ compara divisor e dividendo
  SUBGE	r9, r9, r4		      @ subtrai divisor de dividendo
  ADDGE r2, r2, r6, LSL r7	@ quociente recebe resto 1 shiftado do numero de alinhamentos
  SUB	r7, r7, #1            @ subtrai 1 do contador
  MOV r4, r4, LSR #1		    @ divisor shiftado para esquerda n vezes
  CMP	r7, #0                @ compara contador com 0
  BPL	loop			            @ continua se positivo ou 0
  MOV	r3, r9			          @ r3 recebe o resto
fim:
  SWI	0x0                   @ fim do programa	

