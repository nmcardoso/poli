volatile unsigned int *const UART0DR = (unsigned int *)0x101f1000;

/**
 * Imprime uma cadeia de caracteres usando o protocolo UART
 */
void print_uart0(const char *s)
{
  while (*s != '\0')
  {                                /* Loop until end of string */
    *UART0DR = (unsigned int)(*s); /* Transmit char */
    s++;                           /* Next char */
  }
}

/**
 * Função Hello Word, usada para testes
 */
void c_entry()
{
  print_uart0("Hello world!\n");
}
