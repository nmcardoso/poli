	.file	"item-8-2-2.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"numero = %d\n\000"
	.text
	.align	2
	.global	imprime
	.type	imprime, %function
imprime:
	@ args = 0, pretend = 0, frame = 4
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	sub	sp, sp, #4
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bge	.L2
	b	.L1
.L2:
	ldr	r0, .L3
	ldr	r1, [fp, #-16]
	bl	printf
	ldr	r3, [fp, #-16]
	sub	r3, r3, #1
	mov	r0, r3
	bl	imprime
.L1:
	ldmfd	sp, {r3, fp, sp, pc}
.L4:
	.align	2
.L3:
	.word	.LC0
	.size	imprime, .-imprime
	.align	2
	.global	main
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	ldr	r3, .L6
	mov	r2, #1
	str	r2, [r3, #0]
	ldr r0, =0x30030
	ldr r1, =100
	str r1, [r0, #0]
	
	mov	r0, #5
	bl	imprime
	mov	r0, r3
	ldmfd	sp, {fp, sp, pc}
.L7:
	.align	2
.L6:
	.word	mostra
	.size	main, .-main
	.comm	mostra,4,4
	.ident	"GCC: (GNU) 3.4.3"
