// para montar este código basta usar "arm-elf-gcc imprime.c div.s int2str.s"
// para debuger gdb a.out
#include <stdio.h>
					
extern void int2str(int num, char *pontstr);

void impnum(int num)
{
    __asm__( 
    "inic_imprime: nop\n\t"
    );
	if (num <= 0) {
        return;
    }
    
    char pontstr[50] = "";
	int2str(num, pontstr);
	puts(pontstr);
    __asm__( 
    "fim_imprime: nop\n\t"
    );
    impnum(num/10);
	return;
}
					
int main()
{
    __asm__( 
    "pronto: nop\n\t"
    );
    impnum(881);
	return 0;
}
