@ex_3_10_4.s
    .text
    .globl main
main: 
    LDR r0, =0xF631024C @ carrega valor no primeiro registrador
    LDR r1, =0x17539ABD @ carrega valor no segundo registrador
    BL  swap            @ chamada da função
    LDR r0, =0x0  
    LDR r7, =0x1        @ exit(0)
    SWI 0x0             @ termina o programa
swap:
    EOR r0, r0, r1      @ calcula r0 = r0 eor r1
    EOR r1, r0, r1      @ calcula r0 = r1 eor r1
    EOR r0, r0, r1      @ calcula r0 = r0 eor r1
    MOV pc, lr          @ retorna da função
