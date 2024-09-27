@ Descrição do algoritmo
@ ----------------------
@ Algoritmo de divisão inteira
@
@
@ Descrição dos Registradores
@ ---------------------------
@ R1 - Dividendo (Numerador)
@ R2 - Divisor (Denominador)
@ R3 - Quociente
@ R5 - Resto
@
@
@ Instruções de uso
@ -----------------
@ arm build ex_3_10_7.s (montagem)
@ arm debug (depuração) 

  .text
  .globl main
main:
    LDR r1, =8914122	    @ inicializa dividendo
    LDR r2, =1000         @ inicializa divisor
    MOV r3, #0			      @ inicializa quociente
    MOV r5, #0			      @ inicializa resto
    MOV	r4, r2			      @ copia de divisor
    MOV r9, r1            @ copia do dividendo
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
    ADDGE r3, r3, r6, LSL r7	@ quociente recebe resto 1 shiftado do numero de alinhamentos
    SUB	r7, r7, #1            @ subtrai 1 do contador
    MOV r4, r4, LSR #1		    @ divisor shiftado para esquerda n vezes
    CMP	r7, #0                @ compara contador com 0
    BPL	loop			            @ continua se positivo ou 0
    MOV	r5, r9			          @ r5 recebe o resto
fim:
    SWI	0x0                   @ fim do programa	
