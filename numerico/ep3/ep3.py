# -*- coding: utf-8 -*-
"""
Exercício Programa 03: ...


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


from typing import Any, Callable, Tuple, Union
import numpy as np


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
    uma tupla contendo um array de pesos e outro de nós, nesta ordem.
  """
  x = np.array(DATA[n]['x'])
  w = np.array(DATA[n]['w'])
  x = np.concatenate((-x[::-1], x))
  w = np.concatenate((w[::-1], w))
  return x, w


def gauss_quad(f: Callable, a: float, b: float, n: int = 10) -> float:
  """
  Calcula a aproximação da integral em um intervalo qualquer da função f, 
  sendo a e b os limites da integral inferior e superior, respectivamente.
  O cálculo é feito usando quadratura gaussiana com n nós.

  Parameters
  ----------
  f: Callable
    uma função de duas variáveis a ser integrada

  a: float
    limite inferior de integração

  b: float
    limite superior de integração

  n: int
    número de nós e pesos a serem usados (raízes e coeficinetes do
    polinômio de Legendre)

  Returns
  -------
  float
    aproximação da integral da função f no intervalo [a, b] usando
    quadratura gaussiana com n nós.
  """
  nodes, weights = get_pairs(n)
  g1: float = (b - a) / 2
  g2: float = (b + a) / 2
  I = g1 * np.sum(weights * f(g1 * nodes + g2))
  return I



def decomp_lu(
  a: np.ndarray, 
  b: np.ndarray, 
  c: np.ndarray
) -> Tuple[np.ndarray, np.ndarray]:
  """
  Decomposição LU da matriz tridiagonal A nxn definida pelos vetores a, b e c

  Parameters
  ----------
  a: numpy.ndarray
    vetor de dimensão n com os elementos da subdiagonal de A
  b: numpy.ndarray
    vetor de dimensão n com os elementos da diagonal de A
  c: numpy.ndarray
    vetor de dimensão n com os elementos da supradiagonal de A

  Returns
  -------
  Tuple[numpy.ndarray, numpy.ndarray]
    tupla (L, U) com os vetores resultantes da decomposição LU.
  """
  n = len(a)
  u = np.zeros(shape=(n,))
  l = np.zeros(shape=(n,))

  u[0] = b[0]
  for i in range(1, n):
    l[i] = a[i] / u[i-1]
    u[i] = b[i] - l[i] * c[i-1]
  return l, u


def solve_tridiagonal(
  l: np.ndarray, 
  u: np.ndarray, 
  c: np.ndarray, 
  d: np.ndarray
) -> np.ndarray:
  """
  Algorítmo de solução de um sistema Ax = d, onde A é uma matriz tridiagonal nxn,
  a partir da decomposição LU de A.

  Parameters
  ----------
  l: numpy.ndarray
    vetor de dimensão n com os elementos de L da decomposição LU
  u: numpy.ndarray
    vetor de dimensão n com os elementos de U da decomposição LU
  c: numpy.ndarray
    vetor de dimensão n com os elementos da supradiagonal de A
  d: numpy.ndarray
    vetor de dimensão n com os elementos da matrix coluna d (termos independentes)

  Returns
  -------
  numpy.ndarray
    vetor de dimensão n com os valores das incógnitas do sistema
  """
  n = len(l)
  y = np.zeros(shape=(n,))
  x = np.zeros(shape=(n,))
  # Ly = d
  y[0] = d[0]
  for i in range(1, n):
    y[i] = d[i] - l[i]*y[i-1]
  
  # Ux = y
  x[-1] = y[-1]/u[-1]
  for i in range(n-2, -1, -1):
    x[i] = (y[i] - c[i] * x[i+1]) / u[i]

  return x



def solve(x: float, f: Callable, p: Callable, q: Callable, n: int) -> float:
  h = 1 / (n + 1)
  X = np.arange(n + 2) * h
  
  Q1_integrand = lambda i: lambda x: (X[i+1] - x) * (x - X[i]) * q(x)
  Q2_integrand = lambda i: lambda x: (x - X[i-1])**2 * q(x)
  Q3_integrand = lambda i: lambda x: (X[i+1] - x)**2 * q(x)
  Q4_integrand = lambda i: lambda x: p(x)
  Q5_integrand = lambda i: lambda x: (x - X[i-1]) * f(x)
  Q6_integrand = lambda i: lambda x: (X[i+1] - x) * f(x)

  Q1 = np.array([
    gauss_quad(Q1_integrand(i), X[i], X[i+1]) * h**-2 
    for i in range(1, n)
  ])
  Q2 = np.array([
    gauss_quad(Q2_integrand(i), X[i-1], X[i]) * h**-2
    for i in range(1, n+1)
  ])
  Q3 = np.array([
    gauss_quad(Q3_integrand(i), X[i], X[i+1]) * h**-2
    for i in range(1, n+1)
  ])
  Q4 = np.array([
    gauss_quad(Q4_integrand(i), X[i-1], X[i]) * h**-2
    for i in range(1, n+2)
  ])
  Q5 = np.array([
    gauss_quad(Q5_integrand(i), X[i-1], X[i]) * h**-1
    for i in range(1, n+1)
  ])
  Q6 = np.array([
    gauss_quad(Q6_integrand(i), X[i], X[i+1]) * h**-1
    for i in range(1, n+1)
  ])

  A_diag = np.array([Q4[i] + Q4[i+1] + Q2[i] + Q3[i] for i in range(n)])
  A_sub = np.array([0] + [Q1[i] - Q4[i+1] for i in range(n-1)])
  A_sup = np.array([Q1[i-1] - Q4[i] for i in range(n-1)] + [0])
  d = np.array([Q5[i] + Q6[i] for i in range(n)])
  
  l, u = decomp_lu(A_sub, A_diag, A_sup)
  c = solve_tridiagonal(l, u, A_sup, d)


  basis = np.empty((n,))

  for i in range(1, n + 1):
    if X[i-1] < x and x <= X[i]:
      basis[i-1] = (x - X[i-1]) / h
    elif X[i] < x and x <= X[i+1]:
      basis[i-1] = (X[i+1] - x) / h
    else:
      basis[i-1] = 0.0

  print('L', len(l))
  print('U', len(u))
  print('d', len(d))
  print('c', len(c))
  print('basis', len(basis))

  print('c', c)
  print('basis', basis)

  return np.sum(c * basis)

  

class RayleighRitz:
  """
  Implementação do método de Rayleigh Ritz para resolução de equações
  diferenciais para um intervalo [0, L] com condições de contorno
  homogêneas ou não-homogêneas.
  """
  def __init__(self):
    self.coeficients = None
    self.h = None
    self.X = None
    self.n = None
    self.L = None
    self.u0 = None
    self.uL = None
    self._vectorized_evaluator = None

    
  def fit(
    self, 
    f: Callable, 
    k: Callable, 
    q: Callable, 
    n: int, 
    L: float = 1,
    u0: float = 0,
    uL: float = 0
  ):
    """
    Ajusta o modelo para da solução de equações diferenciais da forma
      -ku'' - k'u' + qu = f    (1)
    no intervalo [0, L] e com condições iniciais u(0) = u0 e u(L) = uL
    
    Se os parâmetros L, u0 e uL não forem fornecidos, o modelo ajusta
    a sulução para o intervalo [0, 1] com condições iniciais homogêneas
    
    Notes
    -----
    Como não é preciso recalcular os coeficientes para avaliar o modelo
    em diferentes pontos do intervalo [0, L], este método calcula os
    coeficientes e os armazena na instância da classe para serem usados
    para avaliar um ponto específico usado o método `evaluate` ou avaliar
    vários pontos de forma eficiente usando `vec_evaluate`

    Parameters
    ----------
    f: Callable
      a função f(x) da equação (1)

    k: Callable
      a função k(x) da equação (1)

    q: Callable
      a função q(x) da equação (1)

    n: int
      o número de pontos a serem interpolados, de forma que n-1 é a
      quantidade de intervalos da spline.

    L: float
      limite do intervalo [0, L] onde a solução é calculada

    u0: float
      valor da condição de contorno u(0) = u0

    u1: float
      valor da condição de contorno u(L) = uL
    """
    h = L / (n + 1)
    X = np.arange(n + 2) * h
    
    Q1_integrand = lambda i: lambda x: (X[i+1] - x) * (x - X[i]) * q(x)
    Q2_integrand = lambda i: lambda x: (x - X[i-1])**2 * q(x)
    Q3_integrand = lambda i: lambda x: (X[i+1] - x)**2 * q(x)
    Q4_integrand = lambda i: lambda x: k(x)
    Q5_integrand = lambda i: lambda x: (x - X[i-1]) * f(x)
    Q6_integrand = lambda i: lambda x: (X[i+1] - x) * f(x)

    Q1 = np.array([
      gauss_quad(Q1_integrand(i), X[i], X[i+1]) * h**-2 
      for i in range(1, n)
    ])
    Q2 = np.array([
      gauss_quad(Q2_integrand(i), X[i-1], X[i]) * h**-2
      for i in range(1, n+1)
    ])
    Q3 = np.array([
      gauss_quad(Q3_integrand(i), X[i], X[i+1]) * h**-2
      for i in range(1, n+1)
    ])
    Q4 = np.array([
      gauss_quad(Q4_integrand(i), X[i-1], X[i]) * h**-2
      for i in range(1, n+2)
    ])
    Q5 = np.array([
      gauss_quad(Q5_integrand(i), X[i-1], X[i]) * h**-1
      for i in range(1, n+1)
    ])
    Q6 = np.array([
      gauss_quad(Q6_integrand(i), X[i], X[i+1]) * h**-1
      for i in range(1, n+1)
    ])

    A_diag = np.array([Q4[i] + Q4[i+1] + Q2[i] + Q3[i] for i in range(n)])
    A_sub = np.array([0] + [Q1[i] - Q4[i+1] for i in range(n-1)])
    A_sup = np.array([Q1[i-1] - Q4[i] for i in range(n-1)] + [0])
    d = np.array([Q5[i] + Q6[i] for i in range(n)])
    
    l, u = decomp_lu(A_sub, A_diag, A_sup)
    c = solve_tridiagonal(l, u, A_sup, d)
    
    self.coeficients = c
    self.X = X
    self.h = h
    self.n = n
    self.L = L
    self.u0 = u0
    self.uL = uL
    self._vectorized_evaluator = None
  

  def evaluate(self, x: float) -> float:
    """
    Carrega os coeficientes calculados pelo método `fit` e avalia o modelo
    para um determinado `x` usando uma aproximação linear por partes.

    Parameters
    ----------
    x: float
      ponto onde a estimativa deve ser avaliada

    Returns
    -------
    float
      estimativa da solução da equação diferencial avaliada em `x`
    """
    assert self.coeficients is not None, (
      'Execute o método fit antes de avaliar o modelo para algum valor'
    )

    basis = np.empty((self.n,))

    for i in range(1, self.n + 1):
      if self.X[i-1] < x <= self.X[i]:
        basis[i-1] = (x - self.X[i-1]) / self.h
      elif self.X[i] < x <= self.X[i+1]:
        basis[i-1] = (self.X[i+1] - x) / self.h
      else:
        basis[i-1] = 0.0

    return np.sum(self.coeficients * basis) + self.u0 + (self.uL - self.u0) * x


  def vec_evaluate(self, x: Union[np.ndarray, Any]) -> Union[np.ndarray, Any]:
    """
    Versão vetorizada do método `evaluate` feita para avaliar o modelo em
    grande quantidade de pontos de forma eficiente. Este método vetoriza
    o método evaluate e armazena (cache) a versão vetorizada como um objeto 
    de primeira ordem para usos futuros. 

    Paramenters
    -----------
    x: Any
      arranjo de pontos onde a estimativa deve ser avaliada

    Returns
    -------
    Any
      um arranjo com mesma dimensão de `x` contendo a avaliação do modelo
      ajustado nos pontos definidos por `x`.
    """
    if self._vectorized_evaluator is None:
      self._vectorized_evaluator = np.vectorize(self.evaluate)
    return self._vectorized_evaluator(x)




if __name__ == '__main__':
  f = lambda x: (2*np.pi**2) * np.sin(np.pi * x)
  p = lambda x: 1
  q = lambda x: np.pi ** 2
  # y = solve(0.8, f, p, q, 9)
  # print(y)

  model = RayleighRitz()
  model.fit(f, p, q, 20, 2)
  print(model.evaluate(0.8))


