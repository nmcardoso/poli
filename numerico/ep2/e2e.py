"""
Teste de ponta-a-ponta (E2E) do EP2


Este programa foi feito para testar o EP2 como uma "caixa preta". Ele 
importa o EP2 como um módulo do Python, insere entradas e analisa a saída.


Warning
-------
Esta não é a implementação principal do EP2. Este programa é usado apenas 
para testes e comparações com o Scipy. O arquivo ep2.py precisa estar na 
mesma pasta deste arquivo.
"""

import numpy as np
from scipy.integrate import dblquad
from ep2 import double_gauss_quadrature


to_sp = lambda z: lambda y, x: z(x, y) # adaptação da função para o Scipy


def test():
  """
  Testa o resultado do EP2 e o compara com o resultado obtido pelo Scipy
  """

  # Parâmetros
  f = lambda x, y: np.exp(y/x) # função a ser integrada
  a = 0.1 # limite inferior da integral mais externa
  b = 0.5 # limite superior da integral mais externa
  c = lambda x: x**3 # limite inferior da integral mais interna
  d = lambda x: x**2 # limite superior da integral mais interna
  n = 10 # número de nós (6, 8 ou 10)
  
  I1 = double_gauss_quadrature(f, a, b, c, d, n)
  I2 = dblquad(to_sp(f),  a, b, c, d)[0]

  print('Result. EP2:\t{:.22f}'.format(I1))
  print('Result. Scipy:\t{:.22f}'.format(I2))
  print('Erro:\t\t{:e}'.format(np.abs(I2-I1)))


if __name__ == '__main__':
  test()
