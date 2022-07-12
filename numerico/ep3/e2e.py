from typing import Callable

import numpy as np
import sympy as sp
import matplotlib as mpl
import matplotlib.pyplot as plt
from scipy.special import erf

from ep3 import RayleighRitzSolver



sp.init_printing(use_unicode=True)
t = sp.symbols('x')
w = sp.symbols('u', cls=sp.Function)



def K2C(K):
  return K - 273.15


def C2K(C):
  return C + 273.15



def print_values(model: RayleighRitzSolver, diff_eq: Callable, points: float, sol = None):
  if not sol:
    sol = sp.dsolve(diff_eq, w(t), ics={w(0): model.u0, w(model.L): model.uL})
    exact_func = sp.lambdify(t, sol.rhs, 'numpy')
  else:
    exact_func = sol

  X = np.linspace(0, model.L, points)
  y_pred = np.array(model.vec_evaluate(X))
  y_exact = exact_func(X)
  error = np.abs(y_pred - y_exact)
  max_error = np.max(error)

  sp.pprint(sol)
  print()

  for i in range(len(X)):
    print(f'x={X[i]:.3f}\t\typ={y_pred[i]:.5f}\ty={y_exact[i]:.5f}\te={error[i]:.4f}')

  print(f'Max Error: {max_error:.5f}')


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
  f = lambda x: 12*x*(1-x)-2
  k = lambda x: 1
  q = lambda x: 0
  L = 1
  u = lambda x: x**4 - 2*x**3 + x**2
  
  model = RayleighRitzSolver()
  errors = []
  h2 = []
  N = np.arange(5, 101, 5)

  for n in N:
    model.fit(f, k, q, n, L)
    
    X = np.linspace(0, model.L, n)
    y_pred = model.vec_evaluate(X)
    y_exact = u(X)
    error = np.abs(y_pred - y_exact)
    errors.append(np.max(error))
    h2.append(1/model.h**2)

  errors = np.array(errors)

  plt.plot(N, errors, 'o-', markersize=3)
  plt.plot(N, h2, '-', markersize=3)
  plt.grid()
  plt.title('Erro em função do número de pontos')
  plt.xlabel('Número de pontos')
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
  plt.savefig('val_1_plot_err.pdf', pad_inches=0.01, bbox_inches='tight')
  plt.show()


def val_1_compare_plot():
  f = lambda x: 12*x*(1-x)-2
  k = lambda x: 1
  q = lambda x: 0
  L = 1
  u = lambda x: x**4 - 2*x**3 + x**2
  
  colors = ['tab:orange', 'tab:red', 'tab:brown', 'tab:green']

  for i, n in enumerate((7, 15, 31, 63)):
    model = RayleighRitzSolver()
    model.fit(f, k, q, n, L)
    
    X = np.linspace(0, model.L, n)
    y_pred = model.vec_evaluate(X)
    y_exact = u(X)
    plt.plot(X, y_pred, '--', c=colors[i], label=f'n = {n}', markersize=2)
  plt.plot(X, y_exact, '-.', c='tab:cyan', label='Exato', markersize=2)

  plt.grid()
  plt.legend()
  plt.title('Erro em função do número de pontos')
  plt.xlabel('Número de pontos')
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
  plt.savefig('val_1_plot_compare.pdf', pad_inches=0.01, bbox_inches='tight')
  plt.show()


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
  f = lambda x: np.exp(x) + 1
  k = lambda x: np.exp(x)
  q = lambda x: 0
  L = 1
  u = lambda x: (x-1)*(np.exp(-x)-1)
  
  errors = []
  N = np.arange(5, 101, 5)

  for n in N:
    model = RayleighRitzSolver()
    model.fit(f, k, q, n, L)
    
    X = np.linspace(0, model.L, n)
    y_pred = model.vec_evaluate(X)
    y_exact = u(X)
    error = np.abs(y_pred - y_exact)
    errors.append(np.max(error))

  errors = np.array(errors)

  plt.plot(N, errors, 'o-', markersize=3)
  plt.grid()
  plt.title('Erro em função do número de pontos')
  plt.xlabel('Número de pontos')
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
  plt.savefig('val_2_plot_err.pdf', pad_inches=0.01, bbox_inches='tight')
  plt.show()


def val_2_compare_plot():
  f = lambda x: np.exp(x) + 1
  k = lambda x: np.exp(x)
  q = lambda x: 0
  L = 1
  u = lambda x: (x-1)*(np.exp(-x)-1)
  
  colors = ['tab:orange', 'tab:red', 'tab:brown', 'tab:green']

  for i, n in enumerate((7, 15, 31, 63)):
    model = RayleighRitzSolver()
    model.fit(f, k, q, n, L)
    
    X = np.linspace(0, model.L, n)
    y_pred = model.vec_evaluate(X)
    y_exact = u(X)
    plt.plot(X, y_pred, '-', c=colors[i], label=f'n = {n}', markersize=3)
  plt.plot(X, y_exact, '--', c='tab:cyan', label='Exato', markersize=3)

  plt.grid()
  plt.legend()
  plt.title('Erro em função do número de pontos')
  plt.xlabel('Número de pontos')
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
  plt.savefig('val_2_plot_compare.pdf', pad_inches=0.01, bbox_inches='tight')
  plt.show()


def test_eq_1():
  """
  Aquecimento: Constante
  Resfriamento: Constante
  """
  L = 2.5
  n = 30
  k = 4
  Q_heat = 8000
  Q_cool = 7000
  Q = Q_heat - Q_cool
  f_func = lambda x: Q
  k_func = lambda x: k
  q_func = lambda x: 0

  model = RayleighRitzSolver()
  diff_eq = sp.Eq(-k*w(t).diff(t, t), Q)
  sol = sp.dsolve(diff_eq, w(t), ics={w(0): 0, w(L): 0})
  sp.pprint(sol)

  x = np.linspace(0, L, n)
  y = np.arange(0, 240, 20)
  ci = np.arange(-10, 33, 5)

  X, Y = np.meshgrid(x, y)
  U = 1
  # V = -250*(X + L/(n+1)) + 312.5
  V = -250*X + 312.5
  N = np.sqrt(U**2 + V**2)
  U /= N
  V = V / N

  norm = mpl.colors.Normalize(np.min(ci), np.max(ci))
  cm = plt.cm.plasma
  colors = cm(norm(ci))

  plt.figure(figsize=(8, 4.5))
  for i in range(len(ci)):
    model.fit(f_func, k_func, q_func, n, L, ci[i], ci[i])
    line = model.vec_evaluate(x)
    plt.plot(x, line, color=colors[i])

  plt.quiver(X, Y, U, V, angles='xy', pivot='mid')
  plt.xlabel('time')
  plt.ylabel('y(t)')
  plt.colorbar(plt.cm.ScalarMappable(norm=norm, cmap=cm))

  plt.title('Temperatura ao longo do chip')
  plt.xlabel('Comprimento/Largura')
  plt.ylabel('Temperatura')
  plt.tick_params(
    axis='both', 
    direction='in', 
    top=True, 
    right=True, 
    grid_linestyle='--'
  )
  plt.savefig('test_1.pdf', pad_inches=0.01, bbox_inches='tight')
  plt.show()


def test_eq_2():
  """
  Aquecimento: Distribuição Gaussiana
  Resfriamento: Constante
  """
  L = 2.5
  n = 30
  k = 4
  sigma = 1.5
  Q0_heat = 8850
  Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma**2)
  Q0_cool = 7000
  Q = lambda x: Q_heat(x) - Q0_cool
  f_func = Q
  k_func = lambda x: k
  q_func = lambda x: 0

  model = RayleighRitzSolver()

  # -4*y'' = 8850*exp(-(t-2.5/2)^2 / 1.5^2) - 7000, y(0)=20, y(2.5)=0
  sol_eq = (2941.17*t-3676.46)*sp.erf(0.83333-0.6666*t) - 1242.92*sp.exp(t*(1.111-0.444*t)) + 875*t**2 - 2187.5*t + 4042.2
  diff_eq = sp.diff(sol_eq, t)
  dydx_eq = np.vectorize(sp.lambdify(t, diff_eq, 'numpy'))

  x = np.linspace(0, L, n)
  y = np.arange(0, 240, 20)
  ci = np.arange(-10, 33, 5)

  X, Y = np.meshgrid(x, y)
  U = 1
  V = dydx_eq(X)
  # V = 2941.17*erf(0.83333-0.6666*X) - 1242.92*np.exp(X*(1.111-0.444*X))*(1.111-0.888*X) - 0.752178*(2941.17*X-3676.46)*np.exp(-(0.83333-0.6666*X)**2) + 1750*X - 2187.5
  N = np.sqrt(U**2 + V**2)
  U /= N
  V = V / N

  norm = mpl.colors.Normalize(np.min(ci), np.max(ci))
  cm = plt.cm.plasma
  colors = cm(norm(ci))

  plt.figure(figsize=(8, 4.5))
  
  for i in range(len(ci)):
    model.fit(f_func, k_func, q_func, n, L, ci[i], ci[i])
    line = model.vec_evaluate(x)
    plt.plot(x, line, color=colors[i])

  plt.quiver(X, Y, U, V, angles='xy', pivot='mid')
  plt.xlabel('time')
  plt.ylabel('y(t)')
  plt.colorbar(plt.cm.ScalarMappable(norm=norm, cmap=cm))

  # plt.plot(x, (2941.17*x-3676.46)*erf(0.83333-0.6666*x) - 1242.92*np.exp(x*(1.111-0.444*x)) + 875*x**2 - 2187.5*x + 4042.2, c='red')

  plt.title('Temperatura ao longo do chip')
  plt.xlabel('Comprimento/Largura')
  plt.ylabel('Temperatura')
  plt.tick_params(
    axis='both', 
    direction='in', 
    top=True, 
    right=True, 
    grid_linestyle='--'
  )
  plt.savefig('test_2.pdf', pad_inches=0.01, bbox_inches='tight')
  plt.show()


def test_eq_3():
  """
  Aquecimento: Distribuição Gaussiana
  Resfriamento: Distribuição Gaussiana
  """
  L = 2.5
  n = 30
  k = 4
  sigma = 1.5
  Q0_heat = 8850
  Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma**2)
  Q0_cool = 7000
  Q_cool = lambda x: Q0_cool * np.exp(-(x - L/2)**2 / sigma**2)
  Q = lambda x: Q_heat(x) - Q_cool(x)
  f_func = Q
  k_func = lambda x: k
  q_func = lambda x: 0

  model = RayleighRitzSolver()

  # -4*y'' = (8850-7000)*exp(-(t-2.5/2)^2 / 1.5^2), y(0)=20, y(2.5)=0
  sol_eq = (614.82*t - 768.525)*sp.erf(0.8333 - 0.6666*t) - 259.819*sp.exp(t*(1.111-0.444*t)) - 8*t + 864.979
  diff_eq = sp.diff(sol_eq, t)
  dydx_eq = np.vectorize(sp.lambdify(t, diff_eq, 'numpy'))
  # y'(t) = 2941.17*erf(0.83333-0.6666*t) - 259.819*exp(t*(1.111-0.444*t))*(1.111-0.888*t) - 0.752178*(614.82*t-768.525)*exp(-(0.83333-0.6666*t)^2) - 8

  x = np.linspace(0, L, n)
  y = np.arange(0, 375, 25)
  ci = np.arange(-10, 33, 5)

  X, Y = np.meshgrid(x, y)
  U = 1
  V = dydx_eq(X)
  # V = 2941.17*erf(0.83333-0.6666*X) - 259.819*np.exp(X*(1.111-0.444*X))*(1.111-0.888*X) - 0.752178*(614.82*X-768.525)*np.exp(-(0.83333-0.6666*X)**2) - 8
  N = np.sqrt(U**2 + V**2)
  U /= N
  V = V / N

  norm = mpl.colors.Normalize(np.min(ci), np.max(ci))
  cm = plt.cm.plasma
  colors = cm(norm(ci))

  plt.figure(figsize=(8, 4.5))
  
  for i in range(len(ci)):
    model.fit(f_func, k_func, q_func, n, L, ci[i], ci[i])
    line = model.vec_evaluate(x)
    plt.plot(x, line, color=colors[i])

  plt.quiver(X, Y, U, V, angles='xy', pivot='mid')
  plt.xlabel('time')
  plt.ylabel('y(t)')
  plt.colorbar(plt.cm.ScalarMappable(norm=norm, cmap=cm))

  # plt.plot(x, (2941.17*x-3676.46)*erf(0.83333-0.6666*x) - 1242.92*np.exp(x*(1.111-0.444*x)) + 875*x**2 - 2187.5*x + 4042.2, c='red')

  plt.title('Temperatura ao longo do chip')
  plt.xlabel('Comprimento/Largura')
  plt.ylabel('Temperatura')
  plt.tick_params(
    axis='both', 
    direction='in', 
    top=True, 
    right=True, 
    grid_linestyle='--'
  )
  plt.savefig('test_3.pdf', pad_inches=0.01, bbox_inches='tight')
  plt.show()


def test_eq_4():
  """
  Aquecimento: Distribuição Gaussiana
  Resfriamento: Mais instenso nos extremos
  """
  L = 2.5
  n = 30
  k = 4
  sigma = 1.5
  theta = 1.52
  Q0_heat = 8850
  Q_heat = lambda x: Q0_heat * np.exp(-(x - L/2)**2 / sigma**2)
  Q0_cool = 7000
  Q_cool = lambda x: Q0_cool * (np.exp(-(x)**2 / theta**2) + np.exp(-(x-L)**2 / theta**2))
  Q = lambda x: Q_heat(x) - Q_cool(x)
  f_func = Q
  k_func = lambda x: k
  q_func = lambda x: 0

  model = RayleighRitzSolver()

  # -4*y'' = 8850*exp(-(t-2.5/2)^2 / 1.5^2) - 7000 * (exp(-(t)^2 / 1.52^2) + exp(-(t-2.5)^2 / 1.52^2)), y(0)=0, y(2.5)=0
  sol_eq = (2941.17*t-3676.46)*sp.erf(0.8333-0.6666*t) + (6785.17-2714.07*t)*sp.erf(1.42857-0.571429*t) - 1242.92*sp.exp(t*(1.111-0.444*t)) + 348.152*sp.exp(t*(1.63265-0.326531*t)) + 2714.07*t*sp.erf(0.571429*t) + 2679.69*sp.exp(-0.326531*t**2) - 1.45519e-12*t - 5456.67
  diff_eq = sp.diff(sol_eq, t)
  dydx_eq = np.vectorize(sp.lambdify(t, diff_eq, 'numpy'))


  x = np.linspace(0, L, n)
  y = np.arange(-10, 160, 20)
  ci = np.arange(-10, 33, 5)

  X, Y = np.meshgrid(x, y)
  U = 1
  V = dydx_eq(X)
  # V = (2765.63-2212.5*X)/np.exp(0.444445*(1.25 - X)**2) - 117.005*np.exp((2.16413 - 0.432825*X)*X)*(-2.50001 + X) + 1104.82*np.exp((1.11111 - 0.444444*X)*X)*(-1.25 + X) + (-4375. + 1750*X)/np.exp(0.432826*(2.5 - X)**2) + 2941.17*erf(0.833333 - 0.666667*X) - 2357.36*erf(1.64474 - 0.657895*X) + np.exp(-0.432826*(X + 5.13012e-16)**2)*(2357.36*np.exp((0.657895*X + 3.37508e-16)**2)*erf(0.657895*X + 3.37508e-16) + np.exp((8.31025e-7*X + 6.513e-22)*X)*(-1750*X - 8.9777e-13) + 1750*X + 8.97774e-13)
  N = np.sqrt(U**2 + V**2)
  U /= N
  V = V / N

  norm = mpl.colors.Normalize(np.min(ci), np.max(ci))
  cm = plt.cm.plasma
  colors = cm(norm(ci))

  plt.figure(figsize=(8, 4.5))
  
  for i in range(len(ci)):
    model.fit(f_func, k_func, q_func, n, L, ci[i], ci[i])
    line = model.vec_evaluate(x)
    plt.plot(x, line, color=colors[i])

  plt.quiver(X, Y, U, V, angles='xy', pivot='mid')
  plt.xlabel('time')
  plt.ylabel('y(t)')
  plt.colorbar(plt.cm.ScalarMappable(norm=norm, cmap=cm))

  # plt.plot(x, (2941.17*x-3676.46)*erf(0.8333-0.6666*x) + (5893.41-2357.36*x)*erf(1.64474-0.657895*x) - 1242.92*np.exp(x*(1.111-0.444*x)) + 135.164*np.exp(x*(2.16413-0.432825*x)) + 2357.36*x*erf(0.657895*x + 3.37508e-16) + 1.20936e-12*erf(0.657895*x+3.37508e-16) + 2021.6*np.exp((-0.432825*x-4.44089e-16)*x) - 3890, c='red')

  plt.title('Temperatura ao longo do chip')
  plt.xlabel('Comprimento/Largura')
  plt.ylabel('Temperatura')
  plt.tick_params(
    axis='both', 
    direction='in', 
    top=True, 
    right=True, 
    grid_linestyle='--'
  )
  plt.savefig('test_4.pdf', pad_inches=0.01, bbox_inches='tight')
  plt.show()


def test_eq_5():
  """
  Equilíbrio com variação de material
  Aquecimento: Distribuição Gaussiana
  Resfriamento: Mais instenso nos extremos
  """
  L = 20e-3
  n = 80
  ks = 3.6
  ka = 60
  d = 5e-3
  Q_heat = 37.5e6
  Q_cool = 5e6
  Q = Q_heat - Q_cool
  f_func = lambda x: Q
  k_func = np.vectorize(lambda x: ks if L/2 - d < x < L/2 + d else ka)
  q_func = lambda x: 0

  model = RayleighRitzSolver()

  x = np.linspace(0, L, n)
  y = np.arange(0, 240, 20)
  ci = np.arange(263.15, 295.15, 5)

  norm = mpl.colors.Normalize(np.min(ci), np.max(ci))
  cm = plt.cm.plasma
  colors = cm(norm(ci))

  plt.figure(figsize=(8, 4.5))
  for i in range(len(ci)):
    model.fit(f_func, k_func, q_func, n, L, ci[i], ci[i])
    line = model.vec_evaluate(x)
    plt.plot(x, line, color=colors[i])

  plt.xlabel('time')
  plt.ylabel('y(t)')
  plt.colorbar(plt.cm.ScalarMappable(norm=norm, cmap=cm))

  plt.title('Temperatura ao longo do chip')
  plt.xlabel('Comprimento/Largura (m)')
  plt.ylabel('Temperatura (K)')
  plt.tick_params(
    axis='both', 
    direction='in', 
    top=True, 
    right=True, 
    grid_linestyle='--'
  )
  plt.savefig('test_5.pdf', pad_inches=0.01, bbox_inches='tight')
  plt.grid()
  plt.show()


def test_1():
  f_func = lambda x: (2*np.pi**2) * np.sin(np.pi * x)
  k_func = lambda x: 1
  q_func = lambda x: np.pi ** 2
  # y_func = lambda x: np.sin(np.pi * x)
  L = 1
  n = 30
  u0 = np.pi
  u1 = 0
  
  model = RayleighRitzSolver()
  model.fit(f_func, k_func, q_func, n, L, u0, u1)

  diff_eq = sp.Eq(0, 0) #sp.Eq(-u(t).diff(t, t), 12*t*(1-t)-2)

  print_values(model, diff_eq, 30)


def test_2():
  f_func = lambda x: 12*x*(1-x) - 2
  k_func = lambda x: 1
  q_func = lambda x: 0
  L = 1
  n = 40
  u0 = 0
  u1 = 0
  

  diff_eq = sp.Eq(-w(t).diff(t, t), 12*t*(1-t)-2)

  model = RayleighRitzSolver()
  model.fit(f_func, k_func, q_func, n, L, u0, u1)

  print_values(model, diff_eq, 30)


def test_3():
  L = 2
  sigma = 0.01
  Q0_heat = 20
  Q_heat = lambda x: Q0_heat*np.exp(-(x-L/2)**2 / sigma**2)
  Q_cool = lambda x: 2
  f_func = lambda x: 4
  k_func = lambda x: 3.6
  q_func = lambda x: 0
  L = 1
  n = 40
  u0 = 0
  u1 = 0
  
  diff_eq = sp.Eq(-w(t).diff(t, t), 12*t*(1-t)-2)

  model = RayleighRitzSolver()
  model.fit(f_func, k_func, q_func, n, L, u0, u1)

  print_values(model, diff_eq, 30, u0, u1)



if __name__ == '__main__':
  test_eq_5()
