@hello.s
	.text
	.globl div
div:	
	@ r0 é dividendo
	@ r1 é divisor
	STMFD	sp!, {r4, r6, r7, r8, r9}	@guarda o valor dos registradores na stack
	MOV 	r2, #0			@ quociente
	MOV 	r3, #0			@ resto
	MOV	r4, r1			@ copia de divisor
	MOV 	r5, #0			@ contador
	MOV	r6, #1			@ constante = 1
alinhamento:
	MOV 	r4, r4, LSL #1		@ divisor shitado para esquerda
	ADD	r5, r5, #1		@ incrementa contador de shifts
	CMP 	r4, r0			@ ve se o divisor já é maior que o dividendo
	BLT 	alinhamento		@ votla para mais um shift left
	MOV	r4, r4, LSR #1		@ garantia que ao final do loop da pra dividir um pelo outro
	SUB	r5, r5, #1		@ decrementa o contador após o shift right
loop:
	CMP	r0, r4			@ compara divisor e dividendo
	SUBGE	r0, r0, r4		@ subtrai divisor de dividendo
	ADDGE 	r2, r2, r6, LSL r5	@ quociente recebe resto 1 shiftado do numero de alinhamentos
	SUB	r5, r5, #1
	MOV 	r4, r4, LSR #1		@ divisor shitado para esquerda n vezes
	CMP	r5, #0
	BPL	loop			@ continua se positivo ou 0
	MOV	r5, r0			@ r5 recebe o resto
	MOV	r3, r2			@ r3 recebe o quociente
fim_div:
	LDMFD 	sp!, {r4, r6, r7, r8, r9}	@ pop na stack
	MOV 	pc, lr			@ retorna
