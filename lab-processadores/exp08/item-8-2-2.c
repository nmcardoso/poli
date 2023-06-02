/**
 * Programa criado para testar a funcionalidade
 * de inclusão de código assembly no código-fonte
 * de alto nível.
 * Este programa declara uma variável global
 * "mostra" e altera seu valor para 1 no início
 * da execução do programa usando programação alto
 * nível C. Em seguida, ele altera o valor da var.
 * global para 100 usando código de montagem.
 */

int mostra;

void imprime(int N)
{
  if (N < 0)
  {
    return;
  }
  printf("numero = %d\n", N);
  imprime(N - 1);
}

int main(void)
{
  mostra = 1;
  asm(
      "ldr r0, =0x30030\n\t"
      "ldr r1, =100\n\t"
      "str r1, [r0, #0]\n\t");
  imprime(5);
}
