void imprime(int N, int a, int b, int c, int d)
{
  if (N < 0)
  {
    return;
  }
  printf("numero = %d\n", N);
  imprime(N - 1, a, b, c, d);
}

int main(void)
{
  imprime(5, 10, 20, 30, 40);
}
