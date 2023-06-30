volatile unsigned int * const TIMER0X = (unsigned int *)0x101E200c;
volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;
 
void print_uart0(const char *s) {
    while(*s != '\0') { /* Loop until end of string */
        *UART0DR = (unsigned int)(*s); /* Transmit char */
        s++; /* Next char */
    }
}

void handler_timer() {
    *TIMER0X = 0;
    print_uart0("#");
}

void hello_world() {
    print_uart0("Hello World\n");
}

void print_space() {
    int i = 0;
    print_uart0(".");
    for (i = 0; i < 99999999; i++) {
       if(i%1000000 == 0) print_uart0("+");
    }
}
