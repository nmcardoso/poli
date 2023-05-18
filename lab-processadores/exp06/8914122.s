@ Descrição do algoritmo
@ ----------------------
@ Implementação do algoritmo dos quadrados mágicos.
@
@
@ Instruções de uso
@ -----------------
@ 1. montagem:    arm 8914122.s
@ 2. depuração:   arm debug


.text
.global main

main:
	LDR 	r1, =0x4		              @ r1 = tamanho
	LDR 	r2, =quadrado		          @ r2 = recebe quadrado
	LDR 	r10, =numeros_encontrados @ posição para armazenar numeros encontrados
	MOV	r3, #0			                @ r3 = 0 -> i
	MOV	r7, #0			                @ segundo contador
	MOV	r4, #0			                @ soma
	MUL	r7, r1, r1		              @ r7 = n^2
numeros_presentes:
	LDR	r5, [r2, r3, LSL #2] 	      @ r5 = quadrado[i]
	LDR	r6, [r10, r5, LSL #2]       @ r6 = numeros_encontrados [ quadrado [i]]
	ADD	r6, r6, #1		              @ r6 ++
	STR	r6, [r10, r5, LSL #2]	      @ armazena r6
	ADD	r3, r3, #1                  @ incrementa r3
	CMP	r3, r7			                @ i = n² ?
	MOVEQ	r3, #1			              @ r3 = 1
	BEQ	checa_numeros
	B	numeros_presentes
checa_numeros:
	LDR	r6, [r10, r3, LSL #2]	      @ r6 = numeros_encontrados[2]
	CMP	r6, #1			                @ r6 = 1 -> numero esta presente?
	BNE	nao_magico		              @ se diferente de 1, não é magico
	CMP	r3, r7			                @ i = n²?
	MOVEQ	r3, #0			              @ r3 = 0 na hora de sair do laço
	MOVEQ	r7, #0			              @ r7 = 0 na hora de sair do laço
	BEQ	constante		                @ se for, começar outras verificações
	ADD	r3, r3, #1		              @ i++
	B	checa_numeros
constante:
	MUL	r5, r1, r1		              @ r5 = n^2
	ADD	r5, r5, #1		              @ r5 = ^2 +1
	MUL	r5, r5, r1		              @ r5 = n( n^2 + 1)
	MOV	r5, r5, LSR #1		          @ r5 = n(n^2 +1)/2
colunas:
	MUL	r6, r3, r1		              @ r6 = contador * n
	ADD	r6, r6, r7		              @ contador * n + j
	LDR	r6, [r2, r6, LSL #2]	      @r r6 recebe quadrado[i]
	ADD	r4, r4, r6		              @ soma = soma + quadrado[i]
	ADD	r3, r3, #1		              @ i ++
	CMP	r3, r1			                @ i = n ?
	BEQ	proxima_coluna		          @ se sim, coluna acabou
	B colunas			                  @ se não, prox elemento da coluna
	
proxima_coluna:
	CMP	r4, r5			                @ compara soma obtida com teórica
	BNE	nao_magico		              @ se for diferente acaba
	MOV	r4, #0			                @ soma = 0
	MOV	r3, #0			                @ i = 0
	ADD	r7, r7, #1		              @ j ++
	CMP	r7, r1			                @ se j = n, proxima etapa
	MOVEQ	r7, #0
	BEQ	linhas
	B	colunas			                  @ se não, proxima coluna
linhas:
	MUL	r6, r7, r1		              @ r6 = j * n = linha atual *n
	ADD	r6, r6, r3		              @ "indice" = j*n + i
	LDR	r6, [r2, r6, LSL #2]	      @ r6 recebe quadrado["indice"]
	ADD	r4, r4, r6		              @ soma = soma + quadrado["indice"]
	ADD	r3, r3, #1		              @ i ++
	CMP	r3, r1			                @ i = n ?
	BEQ	proxima_linha		            @ se sim, linha acabou
	B 	linhas			                @ se não, prox elemento da linha
	
proxima_linha:
	CMP	r4, r5			                @ compara soma obtida com teórica
	BNE	nao_magico		              @ se for diferente acaba
	MOV	r4, #0			                @ soma = 0
	MOV	r3, #0			                @ i = 0
	ADD	r7, r7, #1		              @ j ++
	CMP	r7, r1			                @ se j = n, proxima etapa
	MOVEQ	r7, #0
	BEQ	diagonais
	B	linhas		                    @ se não, proxima coluna

diagonais:
diagonal_principal:
	LDR	r6, [r2, r7, LSL #2]	      @ r6 recebe quadrado["indice"]
	ADD	r4, r4, r6		              @ soma = soma + quadrado["indice"]
	ADD	r3, r3, #1		              @ i ++
	ADD	r7, r7, r1		
	ADD	r7, r7, #1		              @ r7 = r7 + (n + 1)
	CMP	r3, r1			                @ i = n ?
	BEQ	testa_diagonal_p	          @ se sim, linha acabou
	B 	diagonal_principal	        @ se não, prox elemento da linha

testa_diagonal_p:
	CMP	r4, r5			                @ compara soma obtida com teórica
	BNE	nao_magico		              @ se for diferente acaba
	MOV	r4, #0			                @ soma = 0
	MOV	r3, #0			                @ i = 0
	SUB	r7, r1, #1		              @ j = n - 1
	B	diagonal_secundaria
diagonal_secundaria:
	LDR	r6, [r2, r7, LSL #2]	      @ r6 recebe quadrado["indice"]
	ADD	r4, r4, r6		              @ soma = soma + quadrado["indice"]
	ADD	r3, r3, #1		              @ i ++
	ADD	r7, r7, r1		      
	SUB	r7, r7, #1		              @ r7 = r7 + (n - 1)
	CMP	r3, r1			                @ i = n ?
	BEQ	testa_diagonal_s	          @ se sim, linha acabou
	B 	diagonal_secundaria	        @ se não, prox elemento da linha
	
testa_diagonal_s:
	CMP	r4, r5			                @ compara soma obtida com teórica
	BNE	nao_magico		              @ se for diferente acaba
	MOV	r4, #1			                @ guarda constante 1
	LDR	r8, =eh_magico
	STR	r4, [r8]		                @ salva 1 em eh_magico
	MOV	r9, #1
	B	fim
fim:
	SWI 	0x123456
	
nao_magico:
	MOV	r9, #0
	B 	fim
	
.data
quadrado:
    .word 16, 3, 2, 13, 5, 10, 11, 8, 9, 6, 7, 12, 4, 15, 14, 1
eh_magico:
    .word 0
numeros_encontrados:
    .space 100 @abrindo um espaco de 100 bytes para armazenar a array
.align 1 @ align to even bytes REQUIRED!!!
