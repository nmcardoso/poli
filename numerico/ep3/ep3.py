# -*- coding: utf-8 -*-
"""
Exercício Programa 03: Modelo de um Sistema de Resfriamento de Chips


Este programa consiste em 3 "solvers": TridiagonalSolver (EP1), 
GaussQuadSolver (EP2) e RayleighRitzSolver (EP3). Este último é a 
implementação principal do EP3 e usa os dois primeiros como dependências.


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



class TridiagonalSolver:
  """
  Algorítmo de solução de sistemas tridiagonais por decomposição LU. Adaptado
  do EP1 e usado como dependência de RayleighRitzSolver (EP3)
  """
  def __init__(self):
    self.l = None
    self.u = None


  def decomp_lu(
    self,
    a: np.ndarray, 
    b: np.ndarray, 
    c: np.ndarray
  ):
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

    self.l = l
    self.u = u


  def solve(
    self,
    a: np.ndarray,
    b: np.ndarray,
    c: np.ndarray, 
    d: np.ndarray
  ) -> np.ndarray:
    """
    Algorítmo de solução de um sistema Ax = d, onde A é uma matriz tridiagonal nxn,
    a partir da decomposição LU de A.

    Parameters
    ----------
    a: numpy.ndarray
      vetor de dimensão n com os elementos da subdiagonal de A
    b: numpy.ndarray
      vetor de dimensão n com os elementos da diagonal de A
    c: numpy.ndarray
      vetor de dimensão n com os elementos da supradiagonal de A
    d: numpy.ndarray
      vetor de dimensão n com os elementos da matrix coluna d (termos independentes)

    Returns
    -------
    numpy.ndarray
      vetor de dimensão n com os valores das incógnitas do sistema
    """
    if self.l is None or self.u is None:
      self.decomp_lu(a, b, c)
    
    l, u = self.l, self.u
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



class GaussQuadSolver:
  """
  Algorítmo de integração numérica usando quadratura gaussiana com um número
  fixo de nós igual a 10. Adaptado do EP2 e usado como dependência de 
  RayleighRitzSolver (EP3).
  """
  DATA = {
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
  """
  Dicionário de dados contendo valores positivos dos nós e respectivos pesos
  """

  _transformed_xw = None
  """
  Cache da versão transformada das abscissas e pesos do polinômio de Legendre
  """


  def _get_pairs(self) -> Tuple[np.ndarray, np.ndarray]:
    """
    Acessa o dicionário de dados, calcula os valores negativos e retorna
    uma quantidade n=10 de nós e pesos do polinômio de Legendre

    Returns
    -------
    Tuple[np.ndarray, np.ndarray]
      uma tupla contendo um array de nós e outro de pesos, nesta ordem.
    """
    if GaussQuadSolver._transformed_xw is None:
      x = np.array(GaussQuadSolver.DATA['x'])
      w = np.array(GaussQuadSolver.DATA['w'])
      x = np.concatenate((-x[::-1], x))
      w = np.concatenate((w[::-1], w))
      GaussQuadSolver._transformed_xw = (x, w)
    return GaussQuadSolver._transformed_xw


  def solve(self, f: Callable, a: float, b: float) -> float:
    """
    Calcula a aproximação da integral em um intervalo qualquer da função f, 
    sendo a e b os limites inferior e superior da integral, respectivamente.
    O cálculo é feito usando quadratura gaussiana com n=10 nós.

    Parameters
    ----------
    f: Callable
      uma função real de uma variável real que define o integrando

    a: float
      limite inferior de integração

    b: float
      limite superior de integração

    Returns
    -------
    float
      aproximação da integral da função f no intervalo [a, b] usando
      quadratura gaussiana com n=10 nós.
    """
    nodes, weights = self._get_pairs()
    g1: float = (b - a) / 2
    g2: float = (b + a) / 2
    I = g1 * np.sum(weights * f(g1 * nodes + g2))
    return I

  

class RayleighRitzSolver:
  """
  Algorítmo de resolução de equações diferenciais para um intervalo [0, L] 
  com condições de contorno homogêneas ou não-homogêneas usando o método de 
  Rayleigh-Ritz com aproximação por splines lineares.
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
      -ku'' - k'u' + qu = f    (eq. 1)
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
    
    # funções-fábrica que geram as funções dos integrandos para cada i
    I1_integrand = lambda i: lambda x: (X[i+1] - x) * (x - X[i]) * q(x)
    I2_integrand = lambda i: lambda x: (x - X[i-1])**2 * q(x)
    I3_integrand = lambda i: lambda x: (X[i+1] - x)**2 * q(x)
    I4_integrand = lambda i: lambda x: k(x)
    I5_integrand = lambda i: lambda x: (x - X[i-1]) * f(x)
    I6_integrand = lambda i: lambda x: (X[i+1] - x) * f(x)

    qs = GaussQuadSolver()
    I1 = np.array([
      qs.solve(I1_integrand(i), X[i], X[i+1]) * h**-2 
      for i in range(1, n)
    ])
    I2 = np.array([
      qs.solve(I2_integrand(i), X[i-1], X[i]) * h**-2
      for i in range(1, n+1)
    ])
    I3 = np.array([
      qs.solve(I3_integrand(i), X[i], X[i+1]) * h**-2
      for i in range(1, n+1)
    ])
    I4 = np.array([
      qs.solve(I4_integrand(i), X[i-1], X[i]) * h**-2
      for i in range(1, n+2)
    ])
    I5 = np.array([
      qs.solve(I5_integrand(i), X[i-1], X[i]) * h**-1
      for i in range(1, n+1)
    ])
    I6 = np.array([
      qs.solve(I6_integrand(i), X[i], X[i+1]) * h**-1
      for i in range(1, n+1)
    ])

    A_diag = np.array([I4[i] + I4[i+1] + I2[i] + I3[i] for i in range(n)])
    A_sub = np.array([0] + [I1[i] - I4[i+1] for i in range(n-1)])
    A_sup = np.array([I1[i-1] - I4[i] for i in range(n-1)] + [0])
    d = np.array([I5[i] + I6[i] for i in range(n)])
    
    ts = TridiagonalSolver()
    c = ts.solve(A_sub, A_diag, A_sup, d)
    
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
      ponto onde o modelo Rayleigh-Ritz ajustado deve ser avaliado

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
    o método evaluate e armazena a versão vetorizada (cache) como um objeto 
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

  model = RayleighRitzSolver()
  model.fit(f, p, q, 20, 2)
  print(model.evaluate(0.8))
