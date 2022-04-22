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
