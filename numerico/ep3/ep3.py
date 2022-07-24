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
import argparse



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
    no intervalo [0, L] e com condições de contorno u(0) = u0 e u(L) = uL
    
    Se os parâmetros L, u0 e uL não forem fornecidos, o modelo ajusta
    a sulução para o intervalo [0, 1] com condições de contorno homogêneas
    
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



class View:
  """
  Interface de Usuário (UI)
  """
  def heading(self, msg: str, sep: str = '-'):
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
    print(sep*len(msg))


  def print_values(
    self, 
    model: RayleighRitzSolver, 
    exact_func: Callable = None,
    csv: bool = False
  ):
    """
    Avalia o modelos para n pontos e exibe os valores de forma tabular

    Parameters
    ----------
    model: RayleighRitzSolver
      um modelo já ajustado

    exact_func: Callable
      a função u(x)

    csv: bool
      exibe no formato csv
    """
    X = model.X
    u_pred = model.vec_evaluate(X)

    if exact_func is not None:
      u_exact = exact_func(X)
      error = np.abs(u_pred - u_exact)
      max_error = np.max(error)

      if csv:
        print('x,un,u,e')
        for i in range(len(X)):
          print(f'{X[i]:.6f},{u_pred[i]:.6f},{u_exact[i]:.6f},{error[i]:.2e}')
      else:
        for i in range(len(X)):
          print(f'x={X[i]:.6f}\tun={u_pred[i]:.6f}\tu={u_exact[i]:.6f}\te={error[i]:.2e}')
        print(f'Erro máx.: {max_error:.2e}')
    else:
      if csv:
        print('x,un')
        for i in range(len(X)):
          print(f'{X[i]:.6f},{u_pred[i]:.6f}')
      else:
        for i in range(len(X)):
          print(f'x={X[i]:.6f}\tun={u_pred[i]:.6f}')


  def model_summary(
    self, 
    model: RayleighRitzSolver,
    k: Any = None,
    ka: Any = None,
    ks: Any = None,
    d: Any = None,
    Q_heat: Any = None,
    Q_cool: Any = None,
    sigma_heat: Any = None,
    sigma_cool: Any = None,
    theta: Any = None,
    f_exp: str = None,
    k_exp: str = None,
    q_exp: str = None,
    u_exp: str = None,
    exact_func: Callable = None,
    csv: bool = False
  ):
    """
    Exibe um sumário do modelo

    Parameters
    ----------
    model: RayleighRitzSolver
      um modelo já ajustado

    f_exp: str
      expressão de f(x)

    k_exp: str
      expressão de k(x)

    q_exp: str
      expressão de q(x)

    u_exp: str
      expressão de u(x)

    exact_func: Callable
      a função u(x)

    csv: bool
      exibe no formato csv
    """
    if csv: return self.print_values(model, exact_func, csv)

    self.heading('Parâmetros')
    if f_exp:
      print('f(x) = {}'.format(f_exp))
    if k_exp:
      print('k(x) = {}'.format(k_exp))
    if q_exp:
      print('q(x) = {}'.format(q_exp))
    if d:
      print('d = {}'.format(d))
    if k:
      print('k = {}'.format(k))
    if ka:
      print('ka = {}'.format(ka))
    if ks:
      print('ks = {}'.format(ks))
    if Q_heat:
      print('Q0 (aquecimento) = {}'.format(Q_heat))
    if Q_cool:
      print('Q0 (resfriamento) = {}'.format(Q_cool))
    if sigma_heat:
      print('sigma (aquecimento) = {}'.format(sigma_heat))
    if sigma_cool:
      print('sigma (resfriamento) = {}'.format(sigma_cool))
    if theta:
      print('theta = {}'.format(theta))
    print('u(0) = {}'.format(model.u0))
    print('u({}) = {}'.format(model.L, model.uL))
    print('L = {}'.format(model.L))
    print('n = {}'.format(model.n))
    print()
    print()

    if exact_func is not None:
      self.heading('Solução Exata')
      print('u(x) = {}'.format(u_exp))
      print()
      print()

    self.heading('Avaliação do modelo')
    self.print_values(model, exact_func)
    print()
    print()

    self.heading('Legenda')
    print('x: ponto no intervalo [0, L] onde a EDO é avaliada')
    print('un: valor de u(x) aproximado pelo método Rayleigh-Ritz')
    print('u: valor exato de u(x)')
    print('e: erro |up - u|')
    print('Erro máx: max|up - u|')
    print('n: número de pontos usados na interpolação')


  def validation(self, n: int = 15, csv: bool = False):
    """
    Teste 0: Seção 4.2 do enunciado.
    Validação/Sanitização do algorítmo de solução de EDOs

    Parameters
    ----------
    n: int
      número de pontos considerados pelo modelo na resulução da EDO

    csv: bool
      exibe no formato csv
    """
    f = lambda x: 12*x*(1-x)-2
    k = lambda x: 1
    q = lambda x: 0
    u = lambda x: (x**2)*(1-x)**2

    model = RayleighRitzSolver()
    model.fit(f, k, q, n)

    if not csv:
      self.heading('Validação', '~')
      print()
      print()

    s = s or n
    self.model_summary(
      model, 
      f_exp='(1 - x)12x - 2',
      k_exp='1',
      q_exp='0',
      u_exp='(x^2)(1 - x)^2',
      exact_func=u,
      csv=csv
    )


  def test_1(self, n: int = 30, csv: bool = False):
    """
    Teste 1 - Seção 4.3 do enunciado: Equilíbrio com forçantes de calor
    Aquecimento: Constante
    Resfriamento: Constante

    Parameters
    ----------
    n: int
      número de pontos considerados pelo modelo na resulução da EDO

    csv: bool
      exibe no formato csv
    """
    L = 20
    k = 3.6
    Q_heat = 60
    Q_cool = 55
    T0 = 293.15
    Q = Q_heat - Q_cool
    f_func = lambda x: Q
    k_func = lambda x: k
    q_func = lambda x: 0
    u_func = lambda t: 293.15 - (t*(25*t - 500))/36
    
    model = RayleighRitzSolver()
    model.fit(f_func, k_func, q_func, n, L, u0=T0, uL=T0)

    if not csv:
      self.heading('Teste 01', '~')
      print('Equilíbrio com forçantes de calor com aquecimento')
      print('constante e resfriamento constante')
      print()
      print()

    self.model_summary(
      model, 
      k=k,
      Q_heat=Q_heat,
      Q_cool=Q_cool,
      u_exp='293.15 - (t(25t - 500))/36',
      exact_func=u_func,
      csv=csv
    )


  def test_2(self, n: int = 30, csv: bool = False):
    """
    Teste 2 - Seção 4.3 do enunciado: Equilíbrio com forçantes de calor
    Aquecimento: Distribuição Gaussiana
    Resfriamento: Constante

    Parameters
    ----------
    n: int
      número de pontos considerados pelo modelo na resulução da EDO

    csv: bool
      exibe no formato csv
    """
    L = 20
    k = 3.6
    sigma_heat = 5.5
    Q0_heat = 60
    Q0_cool = 35
    T0 = 293.15
    Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma_heat**2)
    Q = lambda x: Q_heat(x) - Q0_cool
    f_func = Q
    k_func = lambda x: k
    q_func = lambda x: 0
    
    model = RayleighRitzSolver()
    model.fit(f_func, k_func, q_func, n, L, u0=T0, uL=T0)

    if not csv:
      self.heading('Teste 02', '~')
      print('Equilíbrio com forçantes de calor com aquecimento')
      print('gaussiano e resfriamento constante')
      print()
      print()

    self.model_summary(
      model, 
      k=k,
      sigma_heat=sigma_heat,
      Q_heat=Q0_heat,
      Q_cool=Q0_cool,
      csv=csv
    )


  def test_3(self, n: int = 30, csv: bool = False):
    """
    Teste 3 - Seção 4.3 do enunciado: Equilíbrio com forçantes de calor
    Aquecimento: Distribuição Gaussiana
    Resfriamento: Distribuição Gaussiana

    Parameters
    ----------
    n: int
      número de pontos considerados pelo modelo na resulução da EDO

    csv: bool
      exibe no formato csv
    """
    L = 20
    k = 3.6
    sigma_heat = 3
    sigma_cool = 3
    Q0_heat = 60
    Q0_cool = 40
    T0 = 293.15
    Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma_heat**2)
    Q_cool = lambda x: Q0_cool * np.exp(-(x - L/2)**2 / sigma_cool**2)
    Q = lambda x: Q_heat(x) - Q_cool(x)
    f_func = Q
    k_func = lambda x: k
    q_func = lambda x: 0
    
    model = RayleighRitzSolver()
    model.fit(f_func, k_func, q_func, n, L, u0=T0, uL=T0)

    if not csv:
      self.heading('Teste 03', '~')
      print('Equilíbrio com forçantes de calor com aquecimento')
      print('gaussiano e resfriamento gaussiano')
      print()
      print()

    self.model_summary(
      model, 
      k=k,
      sigma_heat=sigma_heat,
      sigma_cool=sigma_cool,
      Q_heat=Q0_heat,
      Q_cool=Q0_cool,
      csv=csv
    )

  
  def test_4(self, n: int = 30, csv: bool = False):
    """
    Teste 4 - Seção 4.3 do enunciado: Equilíbrio com forçantes de calor
    Aquecimento: Distribuição Gaussiana
    Resfriamento: Distribuição Gaussiana mais intensa nos extremos

    Parameters
    ----------
    n: int
      número de pontos considerados pelo modelo na resulução da EDO

    csv: bool
      exibe no formato csv
    """
    L = 20
    k = 3.6
    sigma_heat = 1.2
    theta = 2.9
    Q0_heat = 60
    Q0_cool = 55
    T0 = 293.15
    Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma_heat**2)
    Q_cool = lambda x: Q0_cool * (np.exp(-(x)**2 / theta**2) + np.exp(-(x-L)**2 / theta**2))
    Q = lambda x: Q_heat(x) - Q_cool(x)
    f_func = Q
    k_func = lambda x: k
    q_func = lambda x: 0
    
    model = RayleighRitzSolver()
    model.fit(f_func, k_func, q_func, n, L, u0=T0, uL=T0)

    if not csv:
      self.heading('Teste 04', '~')
      print('Equilíbrio com forçantes de calor com aquecimento')
      print('gaussiano e resfriamento mais intenso nos extremos')
      print()
      print()

    self.model_summary(
      model, 
      k=k,
      sigma_heat=sigma_heat,
      Q_heat=Q0_heat,
      Q_cool=Q0_cool,
      theta=theta,
      csv=csv
    )


  def test_5(self, n: int = 30, csv: bool = False):
    """
    Teste 5 - Seção 4.4 do enunciado: Equilíbrio com variação de material
    Aquecimento: constante
    Resfriamento: constante

    Parameters
    ----------
    n: int
      número de pontos considerados pelo modelo na resulução da EDO

    csv: bool
      exibe no formato csv
    """
    L = 20
    ks = 3.6
    ka = 60
    d = 2.5
    T0 = 293.15
    Q_heat = 60
    Q_cool = 30
    Q = Q_heat - Q_cool
    f_func = lambda x: Q
    k_func = np.vectorize(lambda x: ks if L/2 - d < x < L/2 + d else ka)
    q_func = lambda x: 0
    
    model = RayleighRitzSolver()
    model.fit(f_func, k_func, q_func, n, L, u0=T0, uL=T0)

    if not csv:
      self.heading('Teste 05', '~')
      print('Equilíbrio com variação de material com aquecimento')
      print('constante e resfriamento constante')
      print()
      print()

    self.model_summary(
      model, 
      ks=ks,
      ka=ka,
      d=d,
      Q_heat=Q_heat,
      Q_cool=Q_cool,
      csv=csv
    )


  def test_6(self, n: int = 30, csv: bool = False):
    """
    Teste 6 - Seção 4.4 do enunciado: Equilíbrio com variação de material
    Aquecimento: Distribuição Gaussiana
    Resfriamento: constante

    Parameters
    ----------
    n: int
      número de pontos considerados pelo modelo na resulução da EDO

    csv: bool
      exibe no formato csv
    """
    L = 20
    ks = 3.6
    ka = 60
    d = 2.5
    T0 = 293.15
    sigma_heat = 5.5
    Q0_heat = 60
    Q0_cool = 35
    Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma_heat**2)
    Q = lambda x: Q_heat(x) - Q0_cool
    f_func = Q
    k_func = np.vectorize(lambda x: ks if L/2 - d < x < L/2 + d else ka)
    q_func = lambda x: 0
    
    model = RayleighRitzSolver()
    model.fit(f_func, k_func, q_func, n, L, u0=T0, uL=T0)

    if not csv:
      self.heading('Teste 06', '~')
      print('Equilíbrio com variação de material com aquecimento')
      print('gaussiano e resfriamento constante')
      print()
      print()

    self.model_summary(
      model, 
      ks=ks,
      ka=ka,
      d=d,
      Q_heat=Q0_heat,
      Q_cool=Q0_cool,
      sigma_heat=sigma_heat,
      csv=csv
    )

  
  def test_7(self, n: int = 30, csv: bool = False):
    """
    Teste 7 - Seção 4.4 do enunciado: Equilíbrio com variação de material
    Aquecimento: Distribuição Gaussiana
    Resfriamento: Distribuição Gaussiana

    Parameters
    ----------
    n: int
      número de pontos considerados pelo modelo na resulução da EDO

    csv: bool
      exibe no formato csv
    """
    L = 20
    ks = 3.6
    ka = 60
    d = 2.5
    T0 = 293.15
    sigma_heat = 2
    sigma_cool = 8
    Q0_heat = 60
    Q0_cool = 30
    Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma_heat**2)
    Q_cool = lambda x: Q0_cool * np.exp(-(x - L/2)**2 / sigma_cool**2)
    Q = lambda x: Q_heat(x) - Q_cool(x)
    f_func = Q
    k_func = np.vectorize(lambda x: ks if L/2 - d < x < L/2 + d else ka)
    q_func = lambda x: 0
    
    model = RayleighRitzSolver()
    model.fit(f_func, k_func, q_func, n, L, u0=T0, uL=T0)

    if not csv:
      self.heading('Teste 07', '~')
      print('Equilíbrio com variação de material com aquecimento')
      print('gaussiano e resfriamento gaussiano')
      print()
      print()

    self.model_summary(
      model, 
      ks=ks,
      ka=ka,
      d=d,
      Q_heat=Q0_heat,
      Q_cool=Q0_cool,
      sigma_heat=sigma_heat,
      sigma_cool=sigma_cool,
      csv=csv
    )


  def test_8(self, n: int = 30, csv: bool = False):
    """
    Teste 8 - Seção 4.4 do enunciado: Equilíbrio com variação de material
    Aquecimento: Distribuição Gaussiana
    Resfriamento: Mais intenso nos extremos

    Parameters
    ----------
    n: int
      número de pontos considerados pelo modelo na resulução da EDO

    csv: bool
      exibe no formato csv
    """
    L = 20
    ks = 3.6
    ka = 60
    d = 2.5
    T0 = 293.15
    sigma_heat = 2
    theta = 4
    Q0_heat = 60
    Q0_cool = 30
    Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma_heat**2)
    Q_cool = lambda x: Q0_cool * (np.exp(-(x)**2 / theta**2) + np.exp(-(x-L)**2 / theta**2))
    Q = lambda x: Q_heat(x) - Q_cool(x)
    f_func = Q
    k_func = np.vectorize(lambda x: ks if L/2 - d < x < L/2 + d else ka)
    q_func = lambda x: 0
    
    model = RayleighRitzSolver()
    model.fit(f_func, k_func, q_func, n, L, u0=T0, uL=T0)

    if not csv:
      self.heading('Teste 08', '~')
      print('Equilíbrio com variação de material com aquecimento')
      print('gaussiano e resfriamento mais intenso nos extremos')
      print()
      print()

    self.model_summary(
      model, 
      ks=ks,
      ka=ka,
      d=d,
      Q_heat=Q0_heat,
      Q_cool=Q0_cool,
      sigma_heat=sigma_heat,
      theta=theta,
      csv=csv
    )


  def cli(self):
    """
    Interface de linha de comando do programa
    """
    parser = argparse.ArgumentParser()

    parser.add_argument(
      '-t', 
      action='store', 
      help='Executa um teste pré-definido entre 0 e 4. Informações de cada teste em LEIAME.txt. Exemplo: -t 3',
      type=int,
      default=None
    )
    parser.add_argument(
      '-n',
      action='store',
      help='Opicional. Número de pontos usado. Valor padrão: 15. Exemplo -n 3',
      type=int,
      default=15
    )
    parser.add_argument(
      '--csv',
      action='store_true',
      help='Opicional. Exibe a avaliação do modelo no formato csv (usado no desenvolvimento). Exemplo --csv',
      default=False
    )
    args = parser.parse_args()

    if not args.csv:
      self.heading('Exercício Programa 3', '=')
      print()

    if args.t is not None:
      if args.n and args.n <= 2:
        print('o parâmetro n precisa ser maior que 2')
        return

      n = args.n - 2
      if args.t == 0:
        self.validation(n, args.csv)
      elif args.t == 1:
        self.test_1(n, args.csv)
      elif args.t == 2:
        self.test_2(n, args.csv)
      elif args.t == 3:
        self.test_3(n, args.csv)
      elif args.t == 4:
        self.test_4(n, args.csv)
      elif args.t == 5:
        self.test_5(n, args.csv)
      elif args.t == 6:
        self.test_6(n, args.csv)
      elif args.t == 7:
        self.test_7(n, args.csv)
      elif args.t == 8:
        self.test_8(n, args.csv)
      else:
        print('Teste especificado inválido')
    else:
      parser.print_help()



if __name__ == '__main__':
  view = View()
  view.cli()
