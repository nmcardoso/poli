# -*- coding: utf-8 -*-
"""
Exercício Programa 02: Integração Numérica com Quadratura Gaussiana


Authors
-------
Natanael Magalhães Cardoso
Valber Marcelino Filho


Warning
-------
Este arquivo está codificado em UTF-8 (codificação padrão do Linux). Caso tenha
problemas de vizualização de alguns caracteres (especialmente acentuações),
reabra este arquivo indicando a codificação correta ao editor. Este problema 
pode ocorrer no Windows, já que ele usa, por padrão, a codificação Windows-125x.
"""


from typing import Callable, Tuple, Union
import numpy as np
from scipy.integrate import dblquad


DATA = {
  6: {
    'x': [
      0.2386191860831969086305017,
      0.6612093864662645136613996,
      0.9324695142031520278123016
    ],
    'w': [
      0.4679139345726910473898703,
      0.3607615730481386075698335,
      0.1713244923791703450402961
    ]
  },
  8: {
    'x': [
      0.1834346424956498049394761,
      0.5255324099163289858177390,
      0.7966664774136267395915539,
      0.9602898564975362316835609
    ],
    'w': [
      0.3626837833783619829651504,
      0.3137066458778872873379622,
      0.2223810344533744705443560,
      0.1012285362903762591525314
    ]
  },
  10: {
    'x': [
      0.1488743389816312108848260,
      0.4333953941292471907992659,
      0.6794095682990244062343274,
      0.8650633666889845107320967,
      0.9739065285171717200779640
    ],
    'w': [
      0.2955242247147528701738930,
      0.2692667193099963550912269,
      0.2190863625159820439955349,
      0.1494513491505805931457763,
      0.0666713443086881375935688
    ]
  }
}
"""
Dicionário de dados contendo valores positivos dos nós e respectivos pesos
"""


def get_pairs(n: int) -> Tuple[np.ndarray, np.ndarray]:
  """
  Acessa o dicionário de dados, calcula os valores negativos e retorna
  uma quantidade n de pesos e nós (raízes e coeficientes do polinômio 
  de Legendre)

  Parameters
  ----------
  n: int
    quantidades de pares (raiz, coeficiente) do polinômio de Legendre 
    a serem retornados

  Returns
  -------
  Tuple[np.ndarray, np.ndarray]
    Uma tupla contendo um array de pesos e outro de nós, nesta ordem.
  """
  x = np.array(DATA[n]['x'])
  w = np.array(DATA[n]['w'])
  x = np.concatenate((-x[::-1], x))
  w = np.concatenate((w[::-1], w))
  return x, w


def double_gauss_quadrature(
  f: Callable, 
  a: float, 
  b: float, 
  c: Union[Callable, float], 
  d: Union[Callable, float],
  n: int = 10, 
) -> float:
  """
  Calcula a aproximação da integral dupla em uma região qualquer
  da função f, sendo a e b os limites da integral mais externa e 
  c e d os limites da integral mais interna. O cálculo é feito 
  usando quadratura gaussiana com n nós.

  Parameters
  ----------
  f: Callable
    uma função de duas variáveis a ser integrada

  a: float
    limite inferior da integral mais externa

  b: float
    limite superior da integral mais externa

  c: Callable or float
    limite inferior da integral mais interna

  d: Callable or float
    limite superior da integral mais interna

  n: int
    número de nós e pesos a serem usados (raízes e coeficinetes do
    polinômio de Legendre)

  Returns
  -------
  float
    aproximação da integral da função f nos limites a, b, c, d usando
    quadratura gaussiana com n nós.
  """
  nodes, weights = get_pairs(n)
  g1: float = (b - a) / 2
  g2: float = (b + a) / 2
  I = 0

  for i in range(n):
    x: float = g1 * nodes[i] + g2
    di: float = d(x) if callable(d) else d
    ci: float = c(x) if callable(c) else c
    h1: float = (di - ci) / 2
    h2: float = (di + ci) / 2
    y: np.ndarray = h1 * nodes + h2
    I += weights[i] * h1 * np.sum(weights * f(x, y))
  I *= g1

  return I


to_sp = lambda z: lambda y, x: z(x, y)


def test_1a(n: int = 6) -> float:
  """
  Caso de teste 1.a: Volume do cubo com arestas de comprimento 1

  Parameters
  ----------
  n: int
    quantidade de nós e pesos a serem usados na aproximação

  Returns
  -------
  float
    o valor da integral calculado para o caso de teste 1.a
  """
  z = lambda x, y: 1
  i = double_gauss_quadrature(z, 0, 1, 0, 1, n)
  ii = dblquad(z, 0, 1, 0, 1)
  return i, ii


def test_1b(n: int = 6) -> float:
  """
  Caso de teste 1.b: Volume do tetraedro

  Parameters
  ----------
  n: int
    quantidade de nós e pesos a serem usados na aproximação

  Returns
  -------
  float
    o valor da integral calculado para o caso de teste 1.b
  """
  z = lambda x, y: 1 - x - y
  i = double_gauss_quadrature(z, 0, 1, 0, lambda x: 1-x, n)
  ii = dblquad(to_sp(z), 0, 1, 0, lambda x: 1-x)
  return i, ii


def test_2a(n: int = 6) -> float:
  """
  Caso de teste 2.a: Área da região limitada pela curva y=1-x^2 (dydx)

  Parameters
  ----------
  n: int
    quantidade de nós e pesos a serem usados na aproximação

  Returns
  -------
  float
    o valor da integral calculado para o caso de teste 2.a
  """
  z = lambda x, y: 1
  i = double_gauss_quadrature(z, 0, 1, 0, lambda x: 1 - x**2, n)
  ii = dblquad(to_sp(z), 0, 1, 0, lambda x: 1 - x**2)
  return i, ii


def test_2b(n: int = 6) -> float:
  """
  Caso de teste 2.b: Área da região limitada pela curva y=1-x^2 (dxdy)

  Parameters
  ----------
  n: int
    quantidade de nós e pesos a serem usados na aproximação

  Returns
  -------
  float
    o valor da integral calculado para o caso de teste 2.b
  """
  z = lambda x, y: 1
  i = double_gauss_quadrature(z, 0, 1, 0, lambda y: np.sqrt(1 - y), n)
  ii = dblquad(to_sp(z), 0, 1, 0, lambda y: np.sqrt(1 - y))
  return i, ii


def test_3a(n: int = 6) -> float:
  """
  Caso de teste 3.a: Área da superfície descrita por z=exp(y/x)

  Parameters
  ----------
  n: int
    quantidade de nós e pesos a serem usados na aproximação

  Returns
  -------
  float
    o valor da integral calculado para o caso de teste 3.a
  """
  z = lambda x, y: np.sqrt(((-y*np.exp(y/x))/(x**2))**2 + (np.exp(y/x)/x)**2 + 1)
  i = double_gauss_quadrature(z, 0.1, 0.5, lambda x: x**3, lambda x: x**2, n)
  ii = dblquad(to_sp(z), 0.1, 0.5, lambda x: x**3, lambda x: x**2)
  return i, ii


def test_3b(n: int = 6) -> float:
  """
  Caso de teste 3.b: Volume da superfície descrita por z=exp(y/x)

  Parameters
  ----------
  n: int
    quantidade de nós e pesos a serem usados na aproximação

  Returns
  -------
  float
    o valor da integral calculado para o caso de teste 3.b
  """
  z = lambda x, y: np.exp(y/x)
  i = double_gauss_quadrature(z, 0.1, 0.5, lambda x: x**3, lambda x: x**2, n)
  ii = dblquad(to_sp(z), 0.1, 0.5, lambda x: x**3, lambda x: x**2)
  return i, ii


def test_4a(n: int = 6) -> float:
  """
  Caso de teste 4.a: Volume da calota esférica

  Parameters
  ----------
  n: int
    quantidade de nós e pesos a serem usados na aproximação

  Returns
  -------
  float
    o valor da integral calculado para o caso de teste 4.a
  """
  z = lambda x, y: np.exp(y/x)
  i = double_gauss_quadrature(z, 0.1, 0.5, lambda x: x**3, lambda x: x**2, n)
  ii = dblquad(to_sp(z), 0.1, 0.5, lambda x: x**3, lambda x: x**2)
  return i, ii


def test_4b(n: int = 6) -> float:
  """
  Caso de teste 4.b: Volume do sólido de revolução

  Parameters
  ----------
  n: int
    quantidade de nós e pesos a serem usados na aproximação

  Returns
  -------
  float
    o valor da integral calculado para o caso de teste 4.b
  """
  z = lambda x, y: np.exp(y/x)
  i = double_gauss_quadrature(z, 0.1, 0.5, lambda x: x**3, lambda x: x**2, n)
  ii = dblquad(to_sp(z), 0.1, 0.5, lambda x: x**3, lambda x: x**2)
  return i, ii


def heading(msg: str, sep: str = '-'):
  """
  Função auxiliar: exibe uma mensagem no terminal com uma regua abaixo
  do mesmo tamanho da mensagem

  Parameters
  ----------
  msg: str
    mensagem a ser exibida
  sep: str
    caractere de separação
  """
  print(msg)
  print(''.join([sep]*len(msg)))


def print_test(title: str, description: str, test_func: Callable):
  """
  Função auxiliar: exibe o valor da integral para diferentes valores
  de pesos e nós

  Parameters
  ----------
  title: str
    título do caso de teste
  description: str
    descrição do caso de teste
  test_func: Callable
    função a ser invocada para obter o valor da integral
  """
  heading(title)
  print(description)
  for n in (6, 8, 10):
    print('n = {}\tI = {:0.22f}\tI\' = {:0.22f}\tE = {:e}'.format(n, test_func(n)[0], test_func(n)[1][0], test_func(n)[0] - test_func(n)[1][0]))
  print()


def main():
  """
  Ponto de entrada do programa
  Mostra o sumário de todos os testes no terminal
  """
  heading('Exercício Programa 02: Integração Numérica', '=')
  print()
  heading('Sumário dos testes', ':')
  print()
  print_test('Teste 1.a', 'Volume do cubo com arestas de comprimento 1', test_1a)
  print_test('Teste 1.b', 'Volume do tetraedro', test_1b)
  print_test('Teste 2.a', 'Área da região limitada pela curva y=1-x^2 (dydx)', test_2a)
  print_test('Teste 2.b', 'Área da região limitada pela curva y=1-x^2 (dxdy)', test_2b)
  print_test('Teste 3.a', 'Área da superfície descrita por z=exp(y/x)', test_3a)
  print_test('Teste 3.b', 'Volume da superfície descrita por z=exp(y/x)', test_3b)
  print_test('Teste 4.a', 'Volume da calota esférica', test_4a)
  print_test('Teste 4.b', 'Volume do sólido de revolução', test_4b)
  print()
  heading('Legenda')
  print('n: quantidade de nós e pesos usados')
  print('I: resultado da integração dupla')


if __name__ == '__main__':
  main()
