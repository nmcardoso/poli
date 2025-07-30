	.text
	.globl main
main:
	MOV	r1, #3
	ADR	r2, quadrado
	MUL	r3,r1,r1
	ADD	r4,r3,#1
	MUL	r3,r1,r4
	MOV	r3, r3, LSR #1 @N(N**2+1)/2
	MOV 	r6, r3
	MUL	r4, r1, r1 @ aux - loops
	MOV	r7, r1
	MOV 	r9, #1

checanumerosdiferentes:
	CMP	r4, #0
	ADREQ	r2, quadrado
	BEQ	looptrocalinha
	LDR	r0, [r2], #4
	ADR	r5, vetordiferente
	SUB	r0, r0, #1
	MOV	r0, r0, LSL #2
	ADD	r5, r5, r0
	LDR	r10, [r5]
	CMP	r10, #0
	MOVNE	r9, #0
	BNE 	fim
	STR	r0, [r5]
	SUB	r4, r4, #1
	B checanumerosdiferentes

looptrocalinha:
	CMP	r6, r3
	MOVNE	r9, #0
	BNE	fim
	CMP	r7, #0
	MOVEQ	r7, r1
	MOV	r4, r1
	ADREQ	r2, quadrado
	BEQ	looptrocacoluna
	MOV	r6, #0
	SUB	r7, r7, #1
	B	looplinha
looplinha:
	CMP	r4, #0
	BEQ	looptrocalinha
	LDR	r5, [r2], #4
	ADD	r6, r6, r5
	SUB	r4, r4, #1
	B 	looplinha
looptrocacoluna:
	CMP	r6, r3
	MOVNE	r9, #0
	BNE	fim
	CMP	r7, #0
	MOVEQ	r7, r1
	MOVEQ	r6, #0
	MOV	r4, r1
	ADREQ	r2, quadrado
	BEQ	diagonalprincipal
	SUB	r5, r1, r7
	MOV	r5, r5, LSL #2
	ADR	r2, quadrado
	ADD	r2, r2, r5
	MOV	r6, #0
	SUB	r7, r7, #1
	B loopcoluna
loopcoluna:
	CMP	r4, #0
	BEQ	looptrocacoluna
	LDR	r5, [r2], r1, LSL #2
	ADD	r6, r6, r5
	SUB	r4, r4, #1
	B 	loopcoluna
diagonalprincipal:
	CMP	r4, #0
	BEQ	checkdp
	ADD	r8, r1, #1
	MOV	r8, r8, LSL #2
	LDR	r5, [r2], r8
	ADD	r6, r6, r5
	SUB	r4, r4, #1
	B diagonalprincipal
checkdp:
	MOV	r4, r1
	ADR	r2, quadrado
	SUB	r8, r1, #1
	MOV	r8, r8, LSL #2
	ADD	r2, r2,r8
	CMP	r6, r3
	MOVNE	r9, #0
	BNE	fim
	MOV	r6, #0
	B diagonalsecundaria
diagonalsecundaria:
	CMP	r4, #0
	BEQ	checkds
	LDR	r5, [r2], r8
	ADD	r6, r6, r5
	SUB	r4, r4, #1
	B diagonalsecundaria
checkds:
	CMP	r6, r3
	MOVNE	r9, #0
	B	carregaehmagico
carregaehmagico:
	ADR	r0, ehmagico
	STR	r9, [r0]
	B	fibonaci
fibonaci:
	adr		r0, fibi
	mov		r1, #10	 		@tamanho da sequencia
	mov 		r2, #0 			@f(0)
	mov		r3, #1 			@f(1)
	str		r2, [r0]		@r0 = f(1)
	str		r3, [r0, #4]
	sub		r1, r1, #1
loop:
	ldr		r2, [r0]		@carrega primeiro da soma em r2
	add		r0, r0, #4
	ldr 		r3, [r0]		@carrega segundo da soma em r3
	add		r4, r3, r2		@soma os dois
	str		r4, [r0, #4]		@guarda r4 em r8

	subs		r1, r1, #1
	bne		loop
	b		fim

	nop			@resultado final em r4
fim:
	
quadrado:
.word  2, 9, 4, 7, 5, 3, 6, 1, 8
ehmagico:
.word 0
vetordiferente:
.word  0, 0, 0, 0, 0, 0, 0, 0, 0
fib:
.word  1, 0, 0
