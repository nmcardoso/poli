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
  imprime(5);
}
