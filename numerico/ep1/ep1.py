from typing import Tuple
import numpy as np
import argparse


def get_values(
  n: int, 
  cyclic: bool = False
) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
  a = np.array([(2*i - 1) / (4*i) for i in range(1, n)] + [(2*n - 1)/(2*n)])
  b = np.array([2]*n)
  c = 1. - a
  d = np.array([np.cos((2*np.pi*i**2)/(n**2)) for i in range(1, n+1)])

  if not cyclic:
    a[0] = 0
    c[-1] = 0
  return a, b, c, d


def decomp_lu(
  a: np.ndarray, 
  b: np.ndarray, 
  c: np.ndarray
) -> Tuple[np.ndarray, np.ndarray]:
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


def solve_cyclic(
  a: np.ndarray, 
  b: np.ndarray, 
  c: np.ndarray, 
  d: np.ndarray
) -> np.ndarray:
  n = len(a)

  T_a = np.copy(a[:-1])
  T_b = np.copy(b[:-1])
  T_c = np.copy(c[:-1])
  T_d = np.copy(d[:-1])
  T_a[0] = 0
  T_c[-1] = 0

  l, u = decomp_lu(T_a, T_b, T_c)
  y = solve_tridiagonal(l, u, T_c, T_d)

  v = np.zeros(shape=(n-1,))
  v[0] = a[0]
  v[-1] = c[-2]

  z = solve_tridiagonal(l, u, T_c, v)

  x = np.zeros(shape=(n,))

  x[-1] = (d[-1] - c[-1]*y[0] - a[-1]*y[-1]) / (b[-1] - c[-1]*z[0] - a[-1]*z[-1])
  x[:-1] = y - x[-1]*z
  return x

