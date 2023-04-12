@ Descrição do algoritmo
@ ----------------------
@ Implementação da multiplicação longa com signal 
@ a partir da instrução UMULL
@
@
@ Descrição dos Registradores
@ ---------------------------
@ R0 - Primeiro Operando
@ R1 - Segundo Operando
@ R7 - Resultado (32-bits mais significativos)
@ R6 - Resultado (32-bits menos significativos)
@ R2, R3, R4 - Registradores de Trabalho
@
@
@ Instruções de uso
@ -----------------
@ arm build ex_3_10_5.s (montagem)
@ arm debug (depuração) 

.text
.globl main

main:
  LDR r0, = -4			  @ operando 1
  LDR r1, = -2			  @ operando 2

preparingRegisters:
  MOV r4, #0			    @ r4 recebe 0
  MOVS r2, r0			    @ r2 recebe operando 1 com atualização de flags
  RSBMI r2, r0, #0		@ r2 = modulo(operando 1) - (r2 = 0 -r2 se r2 é negativo)
  MOVMI r4, #1			  @ se r2 é negativo marca r4 como 1
  MOVS r3, r1			    @ r3 recebe operando 2 com atualização de flags
  EORMI r4, r4, #1		@ se operando 2 também é negativo, r4 fica 0 (1 XOR 1 ou 0 X0R 0). Se o sinal é diferente r4 = 1 
  RSBMI r3, r1, #0		@ r3 = modulo(operando 2) -> (r3 = 0 -r3 se r3 é negativo)

multiplication:
  UMULL r6, r7, r2, r3  @ multiplicação de r2 por r3
  CMP r4, #0			      @ atualiza o cpsr da flag que setamos em r4
  BNE invert 			      @ se r4 != 0
  B fim                 @ sai do loop

invert:
  MVN r7, r7			    @ troca o sinal do mais significativo
  MVN r6, r6			    @ troca o sinal do menos significativo
  ADDS r6, r6, #1	    @ adiciona 1 pela correção da inversão na troca do sinal
  ADC r7, r7, #0	    @ adiciona o carry ao r7

fim:
  SWI 0x1234			    @ fim do programa
