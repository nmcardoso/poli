Str:
        .ascii  "Tom %d, %d, %d.\000" @imprimir 3 pararametros do tipo int
Lstr:
        .word   Str
.text
        .global main
main:
       @Prologo - setup
        mov     ip, sp                @obter a copia de sp
        stmfd   sp!, {fp, ip, lr, pc} @Salvar o frame na pilha
        sub     fp, ip, #4            @Setar no novo frame pointer
        sub     sp, sp, #12           @alocar o espaço para 3 variaveis int na pilha
        

        ldr     r3, =1602                 @primeiro valor
        str     r3, [fp, #-16]
        ldr     r3, =98                @segundo valor
        str     r3, [fp, #-20]
        ldr     r3, =9300881               @terceito valor
        str     r3, [fp, #-24]


        ldr     r0, Lstr    @carrega string para printf
        ldr     r1, [fp, #-16] @carrega pagametro 1 da pilha
        ldr     r2, [fp, #-20] @carrega pagametro 2 da pilha
        ldr     r3, [fp, #-24] @carrega pagametro 3 da pilha
        bl      printf


        sub     sp, fp, #12    @libera o espaco das variaveis na pilha
        @ epilogo - return
       ldmfd   sp, {fp, sp, pc}  @ restaura a pilha, fp e o lr
