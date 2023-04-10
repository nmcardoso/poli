@ a ideia é fazer a subtração dos 32 bits mais significativos 
@ de ambas as palavras armazenando as flags da ULA no registrador 
@ CPRS e depois subtrair os 32 bits menos significativos somente 
@ se a flag da ULA Z estiver setada, também atualizando o 
@ registrador CPRS. O motivo da segunda subtração ser condicional 
@ é preservar o resultado da primeira operação. Assim, um número 
@ de 64-bits será considerado igual ao outro se, ao final das 
@ operações, a flag Z do registrador CPRS estiver setada e 
@ diferente caso contrário.

.text
.global main

main:
    LDR R0, =2003   @ 32b mais significativos da palavra #1 (P#1)
    LDR R1, =29394  @ 32b menos significativos da P#1
    LDR R2, =2003   @ 32b mais significativos da palavra #2 (P#2)
    LDR R3, =29394  @ 32b menos significativos da P#2
    
    SUBS R4, R0, R2     @ subtrai os 32b + signif. da P#2 pela P#1 
                        @ e salva as flags da ULA no reg. CPRS
    SUBEQS R4, R1, R3   @ subtrai os 32b - signif. da P#2 pela P#1
                        @ se Z=1 e salva as flags da ULA no CPRS
    
    LDR R7, =0x1    @ exit(0)
    SWI 0x0         @ termina o programa
