	.text
	.globl   int2str
			
int2str:                     	@ r0 = inteiro, r1 = pontstr
	STMFD 	sp!, {r4-r11, lr}	@salvando registradores
	MOV 	r9, r1			@guardando pontstr
	LDR 	r1, =10			@divisor = 10
	LDR 	r4, =0			@contador do numero de digitos
loop:
	BL 	div			@ divisão -QUOCIENTE EM R3, RESTO EM R5
	CMP	r3, #0			@ se quociente é 0, chega ao fim
	ADD	r5, r5, #0x30		@ r5 = resto + 0x30
	STMFD 	sp!, {r5}		@ salvando registradores
	ADD	r4, r4, #1		@ incrementa contador
	@STRB	r5, [r9, r4]		@ guarda byte em r1 + n de divisões
	MOVEQ	r7, #0			@ novo contador
	BEQ	pops		
	MOV	r0, r3			@ dividendo = quociente
	LDR 	r1, =10			@ divisor = 10
	B	loop			@ refaz a divisão
pops:
	LDMFD 	sp!, {r5}		@ pop de r5
	STRB	r5, [r9, r7]		@ guarda byte em r1 pointstr
	ADD	r7, r7, #1		@ incrementa r1
	CMP	r7, r4			
	BEQ	fim
	B 	pops
fim:
	LDMFD 	sp!, {r4-r11, lr}	@salvando registradores
	mov	pc, lr           	@  Return by branching to the address in the link register.

a:
     .space 100
