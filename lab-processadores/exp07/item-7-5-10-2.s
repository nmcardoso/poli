@ Descrição do algoritmo
@ ----------------------
@ Exercício 7.5.10.2
@ Armazena valor do switch em uma posição de memória
@
@
@ Lista de Registradores
@ ----------------------
@ R0 - IOPMOD
@ R1 - Define leitura/escrita no dispositivo
@ R2 - IOPDATA
@ R3 - Valor do switch
@ R4 - Endereço da variável memória
@ R7 - Contador para delay
@ R8 - Máscara do switch
@
@
@ Instruções de uso
@ -----------------
@ 1. montagem:    gcc item-7-5-10-2.s
@ 2. depuração:   e7t


.text
.global main

main:
  LDR	r0, =0x3ff5000 		    @ IOPMOD
  LDR	r1, =0xF0			        @ seta 0 em [3:0] e 1 em [7:4]
  LDR r4, =memory           @ pega endereço de memory
  LDR r8, =0xF              @ constante = 0b1111
  STR	r1, [r0]		          @ seta IOPMOD como input para [3:0] e output para [7:4]
  LDR	r2, =0x3ff5008 		    @ IOPDATA
  LDR r7, =0xFFFFFF		      @ contador para delay
loop:
  SUBS    r7, r7, #1        @ loop bastante longo
  BEQ     fim               @ acaba no fim do loop
armazena:
  LDR r3, [r2]		          @ le switches [3:0]
  AND r3, r3, r8            @ só bits [3:0]
  LDR r5, [r4, r3, LSL #2]  @ busca memory[r3]
  MOV r5, r5, LSL #4        @ prepara valor do switch para leds
  STR	r5, [r2]		          @ valor dos switches nos leds
  B       loop              @ retorna ao loop
fim:
  SWI 0x123456              @ termina execução
data:
  memory:
  .word 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
