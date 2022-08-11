from typing import Callable

import numpy as np
import sympy as sp
import matplotlib as mpl
import matplotlib.pyplot as plt
from scipy.special import erf
import sys

from ep3 import RayleighRitzSolver



sp.init_printing(use_unicode=True)
t = sp.symbols('x')
w = sp.symbols('u', cls=sp.Function)


SHOW = False


def K2C(K):
  return K - 273.15


def C2K(C):
  return C + 273.15


def plot_curves(f_func, k_func, q_func, L, n, filename, sol_eq=None):
  x = (L/(n+1))*np.arange(n+2)
  cc = np.arange(274, 305, 5)

  norm = mpl.colors.Normalize(np.min(cc), np.max(cc))
  cm = plt.cm.plasma
  colors = cm(norm(cc))
  model = RayleighRitzSolver()

  plt.figure(figsize=(8.8, 4))
  for i in range(len(cc)):
    model.fit(f_func, k_func, q_func, n, L, cc[i], cc[i])
    line = model.vec_evaluate(x)
    plt.plot(x, line, color=colors[i])
  plt.colorbar(plt.cm.ScalarMappable(norm=norm, cmap=cm), ticks=cc)

  if sol_eq is not None:
    diff_eq = sp.diff(sol_eq, t)
    dydx_eq = np.vectorize(sp.lambdify(t, diff_eq, 'numpy'))
    y_min, y_max = plt.gca().get_ylim()
    x1 = np.linspace(0, L, 28)
    y1 = np.linspace(y_min, y_max, 12)
    X, Y = np.meshgrid(x1, y1)
    U = 1
    V = dydx_eq(X)
    N = np.sqrt(U**2 + V**2)
    U /= N
    V = V / N
    plt.quiver(X, Y, U, V, angles='xy', pivot='mid')
  
  if sol_eq is None: plt.grid()
  plt.title('Distribuição de temperatura no chip')
  plt.xlabel('Comprimento (mm)')
  plt.ylabel('Temperatura (K)')
  plt.tick_params(
    axis='both', 
    direction='in', 
    top=True, 
    right=True, 
    grid_linestyle='--'
  )
  plt.savefig('plots/' + filename, pad_inches=0.01, bbox_inches='tight')
  
  if SHOW:
    plt.show()
  plt.close()


def plot_error(f_func, k_func, q_func, L, filename, sol_eq, eps=False):
  model = RayleighRitzSolver()
  errors = []
  N = np.arange(5, 101, 5)
  u = np.vectorize(sp.lambdify(t, sol_eq, 'numpy'))

  for n in N:
    model.fit(f_func, k_func, q_func, n, L)
    X = model.X
    y_pred = model.vec_evaluate(X)
    y_exact = u(X)
    error = np.abs(y_pred - y_exact)
    errors.append(np.max(error))

  errors = np.array(errors)

  plt.figure(figsize=(7.7, 4))
  plt.plot(N, errors, 'o-', markersize=3, label='erro absoluto')
  if eps:
    y_eps = np.ones(N.shape) * sys.float_info.epsilon
    plt.plot(N, y_eps, '--', c='tab:red', label='máx. precisão')
  plt.grid()
  plt.title('Erro em função do número de interpolações')
  plt.xlabel('Número de pontos interpolados')
  plt.ylabel('$||u_n - u||$')
  plt.gca().ticklabel_format(
    axis='y', 
    style='sci', 
    scilimits=(-2, 2), 
    useMathText=True
  )
  plt.tick_params(
    axis='both', 
    direction='in', 
    top=True, 
    right=True, 
    grid_linestyle='--'
  )
  plt.legend()
  plt.savefig('plots/' + filename, pad_inches=0.01, bbox_inches='tight')
  
  if SHOW:
    plt.show()
  plt.close()


def plot_comparison(f_func, k_func, q_func, L, sol_eq, filename, T0=293.15, u_label='Exato'):
  colors = ['tab:orange', 'tab:red', 'tab:brown', 'tab:green']
  u = np.vectorize(sp.lambdify(t, sol_eq, 'numpy'))

  plt.figure(figsize=(7.7, 4))
  for i, n in enumerate((7, 15, 31, 63)):
    model = RayleighRitzSolver()
    model.fit(f_func, k_func, q_func, n, L, T0, T0)
    X = model.X
    y_pred = model.vec_evaluate(X)
    y_exact = u(X)
    plt.plot(X, y_pred, '--', c=colors[i], label=f'n = {n}', markersize=2)
  plt.plot(X, y_exact, '-.', c='tab:cyan', label=u_label, markersize=2)

  plt.grid()
  plt.legend()
  plt.title('Comparação da solução u(x)')
  plt.xlabel('Comprimento (mm)')
  plt.ylabel('Temperatura (K)')
  y_min, y_max = plt.gca().get_ylim()
  if np.abs(y_min - y_max) < 1:
    plt.gca().ticklabel_format(
      axis='y', 
      style='sci', 
      scilimits=(-2, 2), 
      useMathText=True
    )
  plt.tick_params(
    axis='both', 
    direction='in', 
    top=True, 
    right=True, 
    grid_linestyle='--'
  )
  plt.savefig('plots/' + filename, pad_inches=0.01, bbox_inches='tight')

  if SHOW:
    plt.show()
  plt.close()


def print_values(model: RayleighRitzSolver, diff_eq: Callable, points: float, sol = None):
  if not sol:
    sol = sp.dsolve(diff_eq, w(t), ics={w(0): model.u0, w(model.L): model.uL})
    exact_func = sp.lambdify(t, sol.rhs, 'numpy')
  else:
    exact_func = sol

  X = model.X
  y_pred = np.array(model.vec_evaluate(X))
  y_exact = exact_func(X)
  error = np.abs(y_pred - y_exact)
  max_error = np.max(error)

  sp.pprint(sol)
  print()

  for i in range(len(X)):
    print(f'x={X[i]:.3f}\t\typ={y_pred[i]:.5f}\ty={y_exact[i]:.5f}\te={error[i]:.4e}')

  print(f'Max Error: {max_error:.4e}')


def burden():
  f = lambda x: (2*np.pi**2) * np.sin(np.pi * x)
  k = lambda x: 1
  q = lambda x: np.pi ** 2
  n = 11

  diff_eq = sp.Eq(-w(t).diff(t, t) + w(t)*sp.pi**2, 2*sp.pi**2*sp.sin(sp.pi*t))
  
  model = RayleighRitzSolver()
  model.fit(f, k, q, n)
  print_values(model, diff_eq, n)


def val_1():
  f = lambda x: 12*x*(1-x)-2
  k = lambda x: 1
  q = lambda x: 0
  L = 1

  diff_eq = sp.Eq(-w(t).diff(t, t), 12*t*(1-t)-2)
  
  model = RayleighRitzSolver()

  for n in (7, 15, 31, 63):
    model.fit(f, k, q, n, L)
    print_values(model, diff_eq, n)
    print('\n' + ''.join(['-']*70) + '\n')


def val_1_plot():
  f_func = lambda x: 12*x*(1-x)-2
  k_func = lambda x: 1
  q_func = lambda x: 0
  L = 1
  sol_eq = t**4 - 2*t**3 + t**2

  plot_curves(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    n=80,
    filename='val_1.pdf',
    sol_eq=sol_eq,
  )
  
  plot_error(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    filename='val_1_err.pdf',
    sol_eq=sol_eq,
    eps=True
  )

  plot_comparison(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    filename='val_1_comp.pdf',
    sol_eq=sol_eq,
    T0=0
  )


def val_2():
  f = lambda x: np.exp(x) + 1
  k = lambda x: np.exp(x)
  q = lambda x: 0
  L = 1

  diff_eq = sp.Eq(-sp.exp(t)*w(t).diff(t, t) - sp.exp(t)*w(t).diff(t), sp.exp(t) + 1)
  sol = lambda x: (x-1)*(np.exp(-x)-1)
  # sol = None

  # for n in (7, 15, 31, 63):
  for n in (5,):
    model = RayleighRitzSolver()
    model.fit(f, k, q, n)
    pred = model.vec_evaluate(np.linspace(0, 1, n))
    true = sol(np.linspace(0, 1, n))
    print(np.max(np.abs(pred - true)))
    # print_values(model, diff_eq, n, sol=sol)
    # print('\n' + ''.join(['-']*70) + '\n')


def val_2_plot():
  f_func = lambda x: np.exp(x) + 1
  k_func = lambda x: np.exp(x)
  q_func = lambda x: 0
  L = 1
  sol_eq = (t-1)*(sp.exp(-t)-1)
  
  plot_error(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    filename='val_2_err.pdf',
    sol_eq=sol_eq
  )

  plot_comparison(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    filename='val_2_comp.pdf',
    sol_eq=sol_eq
  )


def test_eq_1():
  """
  Aquecimento: Constante
  Resfriamento: Constante
  """
  L = 20
  n = 80
  k = 3.6
  Q_heat = 60
  Q_cool = 55
  Q = Q_heat - Q_cool
  f_func = lambda x: Q
  k_func = lambda x: k
  q_func = lambda x: 0

  # -3.6y'' = 5, y(0)=293.15, y(20)=293.15
  sol_eq = 5863/20 - (t*(25*t - 500))/36

  plot_curves(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    n=n,
    filename='test_1.pdf',
    sol_eq=sol_eq
  )

  plot_comparison(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    sol_eq=sol_eq,
    filename='test_1_comp.pdf'
  )


def test_eq_2():
  """
  Aquecimento: Distribuição Gaussiana
  Resfriamento: Constante
  """
  L = 20
  n = 80
  k = 3.6
  sigma_heat = 5.5
  Q0_heat = 60
  Q0_cool = 35
  Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma_heat**2)
  Q = lambda x: Q_heat(x) - Q0_cool
  f_func = Q
  k_func = lambda x: k
  q_func = lambda x: 0

  # -3.6*y'' = 60*exp(-(t-20/2)^2 / 5.5^2) - 35, y(0)=293.15, y(20)=293.15
  sol_eq = (3025*sp.exp(-400/121))/12 - (875*t)/9 - (3025*sp.exp(-(4*(t - 10)**2)/121))/12 + (1375*sp.pi**(1/2)*sp.erf(20/11))/3 + (1375*sp.pi**(1/2)*sp.erf((2*t)/11 - 20/11))/3 + (175*t**2)/36 - (275*sp.pi**(1/2)*t*sp.erf((2*t)/11 - 20/11))/6 + 5863/20
  
  plot_curves(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    n=n,
    filename='test_2.pdf',
    sol_eq=sol_eq
  )

  plot_comparison(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    sol_eq=sol_eq,
    filename='test_2_comp.pdf'
  )


def test_eq_3():
  """
  Aquecimento: Distribuição Gaussiana
  Resfriamento: Distribuição Gaussiana
  """
  L = 20
  n = 80
  k = 3.6
  sigma_heat = 3
  sigma_cool = 3
  Q0_heat = 60
  Q0_cool = 40
  Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma_heat**2)
  Q_cool = lambda x: Q0_cool * np.exp(-(x - L/2)**2 / sigma_cool**2)
  Q = lambda x: Q_heat(x) - Q_cool(x)
  f_func = Q
  k_func = lambda x: k
  q_func = lambda x: 0

  # -3.6*y'' = (60-40)*exp(-(t-20/2)^2 / 4^2), y(0)=293.15, y(20)=293.15
  sol_eq = (400*sp.exp(-25/4))/9 - (400*sp.exp(-(t - 10)**2/16))/9 + (1000*sp.pi**(1/2)*sp.erf(5/2))/9 - (400*sp.pi**(1/2)*sp.erf(t/4 - 5/2)*(t/4 - 5/2))/9 + 5863/20
  
  plot_curves(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    n=n,
    filename='test_3.pdf',
    # sol_eq=sol_eq
  )

  plot_comparison(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    sol_eq=sol_eq,
    filename='test_3_comp.pdf',
    u_label='Matlab'
  )


def test_eq_3_1():
  """
  Aquecimento: Distribuição Gaussiana
  Resfriamento: Distribuição Gaussiana
  """
  L = 20
  n = 80
  k = 3.6
  sigma_heat = 3
  sigma_cool = 4.5
  Q0_heat = 60
  Q0_cool = 40
  Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma_heat**2)
  Q_cool = lambda x: Q0_cool * np.exp(-(x - L/2)**2 / sigma_cool**2)
  Q = lambda x: Q_heat(x) - Q_cool(x)
  f_func = Q
  k_func = lambda x: k
  q_func = lambda x: 0

  # -3.6*y'' = 60*exp(-(t-20/2)^2 / 3^2) - (-40)*exp(-(t-20/2)^2 / 4.5^2), y(0)=293.15, y(20)=293.15
  sol_eq = 75*sp.exp(-100/9) + (225*sp.exp(-400/81))/2 - 75*sp.exp(-(t - 10)**2/9) - (225*sp.exp(-(4*(t - 10)**2)/81))/2 + 250*sp.pi**(1/2)*sp.erf(10/3) + 250*sp.pi**(1/2)*sp.erf(20/9) - 75*sp.pi**(1/2)*sp.erf(t/3 - 10/3)*(t/3 - 10/3) - (225*sp.pi**(1/2)*sp.erf((2*t)/9 - 20/9)*((2*t)/9 - 20/9))/2 + 5863/20

  plot_curves(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    n=n,
    filename='test_3_1.pdf'
  )

  plot_comparison(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    sol_eq=sol_eq,
    filename='test_3_1_comp.pdf',
    u_label='Matlab'
  )


def test_eq_4():
  """
  Aquecimento: Distribuição Gaussiana
  Resfriamento: Mais instenso nos extremos
  """
  L = 20
  n = 80
  k = 3.6
  sigma_heat = 1.2
  theta = 2.9
  Q0_heat = 60
  Q0_cool = 55
  Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma_heat**2)
  Q_cool = lambda x: Q0_cool * (np.exp(-(x)**2 / theta**2) + np.exp(-(x-L)**2 / theta**2))
  Q = lambda x: Q_heat(x) - Q_cool(x)
  f_func = Q
  k_func = lambda x: k
  q_func = lambda x: 0

  # -3.6*y'' = 50*exp(-(t-20/2)^2 / 1.3^2) - 45 * (exp(-(t)^2 / 2.2^2) + exp(-(t-20)^2 / 2.2^2)), y(0)=0, y(20)=0
  sol_eq = (845*sp.exp(-10000/169))/72 - (121*sp.exp(-10000/121))/4 + (121*sp.exp(-(25*t**2)/121))/4 + (121*sp.exp(-(25*(t - 20)**2)/121))/4 - (845*sp.exp(-(100*(t - 10)**2)/169))/72 - 275*sp.pi**(1/2)*sp.erf(100/11) + (1625*sp.pi**(1/2)*sp.erf(100/13))/18 + (55*sp.pi**(1/2)*t*sp.erf((5*t)/11))/4 + (121*sp.pi**(1/2)*sp.erf((5*t)/11 - 100/11)*((5*t)/11 - 100/11))/4 - (845*sp.pi**(1/2)*sp.erf((10*t)/13 - 100/13)*((10*t)/13 - 100/13))/72 + 2629/10
  
  plot_curves(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    n=n,
    filename='test_4.pdf',
    # sol_eq=sol_eq
  )

  plot_comparison(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    sol_eq=sol_eq,
    filename='test_4_comp.pdf',
    u_label='Matlab'
  )


def test_eq_5():
  """
  Equilíbrio com variação de material
  Aquecimento: Constante
  Resfriamento: Constante
  """
  L = 20
  n = 80
  ks = 3.6
  ka = 60
  d = 2.5
  Q_heat = 60
  Q_cool = 30
  Q = Q_heat - Q_cool
  f_func = lambda x: Q
  k_func = np.vectorize(lambda x: ks if L/2 - d < x < L/2 + d else ka)
  q_func = lambda x: 0

  plot_curves(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    n=n,
    filename='test_5.pdf'
  )


def test_eq_6():
  """
  Equilíbrio com variação de material
  Aquecimento: Distribuição gaussiana
  Resfriamento: Constante
  """
  L = 20
  n = 80
  ks = 3.6
  ka = 60
  d = 2.5
  sigma_heat = 5.5
  Q0_heat = 60
  Q0_cool = 35
  Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma_heat**2)
  Q = lambda x: Q_heat(x) - Q0_cool
  f_func = Q
  k_func = np.vectorize(lambda x: ks if L/2 - d < x < L/2 + d else ka)
  q_func = lambda x: 0

  plot_curves(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    n=n,
    filename='test_6.pdf'
  )


def test_eq_7():
  """
  Equilíbrio com variação de material
  Aquecimento: Distribuição Gaussiana
  Resfriamento: Distribuição Gaussiana
  """
  L = 20
  n = 80
  ks = 3.6
  ka = 60
  d = 2.5
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

  plot_curves(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    n=n,
    filename='test_7.pdf'
  )


def test_eq_8():
  """
  Equilíbrio com variação de material
  Aquecimento: Distribuição Gaussiana
  Resfriamento: Mais instenso nos extremos
  """
  L = 20
  n = 80
  ks = 3.6
  ka = 60
  d = 2.5
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

  plot_curves(
    f_func=f_func,
    k_func=k_func,
    q_func=q_func,
    L=L,
    n=n,
    filename='test_8.pdf'
  )



if __name__ == '__main__':
  val_1()
  # val_1_plot()
  # val_2_plot()

  # test_eq_1()
  # test_eq_2()
  # test_eq_3()
  # test_eq_3_1()
  # test_eq_4()
  # test_eq_5()
  # test_eq_6()
  # test_eq_7()
  # test_eq_8()
