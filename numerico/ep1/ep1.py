# -*- coding: utf-8 -*-
"""
EP1: Exercício Programa 01.


Authors
-------
Natanael Magalhães Cardoso
Valber Marcelino Filho


Warning
-------
Este arquivo está codificado em UTF-8 (codificação padrão do Linux). Caso tenha
problemas de vizualização de alguns caracteres (especialmente acentuações),
reabra este arquivo indicando a codificação correta ao editor. Embora alguns
editores modernos, como VSCode, identifiquem automaticamente a codigficação do
arquivo, este problema pode ocorrer no Windows, já que ele usa, por padrão, 
a codificação Windows-125x.
"""


from typing import Tuple
import numpy as np
import argparse


def get_values(
  n: int, 
  cyclic: bool = False
) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
  """
  Gera os valores de teste do programa a partir da expressão de sequências
  pré-definidas. Esses valores são os elementos da matriz A tridiagonal 
  cíclica ou acíclica do sistema Ax = d.

  Parameters
  ----------
  n: int
    dimensão da matriz quadrada A, e, consequentemente, dimensão dos 
    vetores a, b, c e d
  cyclic: bool
    parâmetro que indica se a função deve retornar uma matriz cíclia ou não

  Returns
  -------
  Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]
    vetores a, b e c que definem a matriz A e o vetor d que define a matriz
    coluna de termos independentes
  """
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
  """
  Decomposição LU da matriz tridiagonal A nxn definida pelos vetores a, b e c

  Parameters
  ----------
  a: numpy.ndarray
    vetor de dimensão n com os elementos da subdiagonal de A
  b: numpy.ndarray
    vetor de dimensão n com os elementos da diagonal primária de A
  c: numpy.ndarray
    vetor de dimensão n com os elementos da supradiagonal de A

  Returns
  -------
  Tuple[numpy.ndarray, numpy.ndarray]
    tupla com os vetores resultantes da decomposição LU.
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


def solve_cyclic(
  a: np.ndarray, 
  b: np.ndarray, 
  c: np.ndarray, 
  d: np.ndarray
) -> np.ndarray:
  """
  Algorítmo de solução de um sistema Ax = d, onde A é uma matriz tridiagonal
  nxn cíclica com a[0] != 0 e c[-1] != 0.

  Parameters
  ----------
  a: numpy.ndarray
    vetor de dimensão n com os elementos da subdiagonal de A
  b: numpy.ndarray
    vetor de dimensão n com os elementos da diagonal primária de A
  c: numpy.ndarray
    vetor de dimensão n com os elementos da supradiagonal de A
  d: numpy.ndarray
    vetor de dimensão n com os elementos da matrix coluna d (termos independentes)

  Returns
  -------
  numpy.ndarray
    vetor de dimensão n com os valores das incógnitas do sistema
  """
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


def print_table(
  a: np.ndarray, 
  b: np.ndarray, 
  c: np.ndarray, 
  d: np.ndarray, 
  x: np.ndarray, 
  width: int, 
  csv: bool = False
):
  """
  Exibe os vetores do sistema de forma tabular

  Parameters
  ----------
  a: numpy.ndarray
    vetor de dimensão n com os elementos da subdiagonal inferior de A
  b: numpy.ndarray
    vetor de dimensão n com os elementos da diagonal primária de A
  c: numpy.ndarray
    vetor de dimensão n com os elementos da supradiagonal superior de A
  d: numpy.ndarray
    vetor de dimensão n com os elementos da matrix coluna d (termos independentes)
  x: numpy.ndarray
    vetor de dimensão n com os valores das incógnitas do sistema
  width: int
    número de dígitos decimais a serem impressos
  csv: bool
    True, se a tabela deve ser impressa no formato csv; False, caso contrário.
  """
  n = len(a)
  if csv:
    print('i,a,b,c,d,x')
    for i in range(n):
      print(
        '{i},{a:.{w}f},{b:.{w}f},{c:.{w}f},{d:.{w}f},{x:.{w}f}'.format(
          i=i+1,
          a=a[i],
          b=b[i],
          c=c[i],
          d=d[i],
          x=x[i],
          w=width,
        )
      )
  else:
    for i in range(n):
      print(
        'i={i}\ta={a:.{w}f}\tb={b:.{w}f}\tc={c:.{w}f}\td={d:.{w}f}\tx={x:.{w}f}'.format(
          i=i+1,
          a=a[i],
          b=b[i],
          c=c[i],
          d=d[i],
          x=x[i],
          w=width,
        )
      )


def cli():
  """
  Interface de linha de comando do programa
  """
  parser = argparse.ArgumentParser(
    description='EP01: Decomposição LU para Matrizes Tridiagonais Cíclicas'
  )

  parser.add_argument(
    '-a', 
    action='store_true', 
    help='Testa a solução tridiagonal acíclica (não cíclica).'
  )
  parser.add_argument(
    '-c', 
    action='store_true', 
    help='Testa a solução tridiagonal cíclica.'
  )
  parser.add_argument(
    '-n', 
    action='store', 
    help='Define a dimensão `n` da matriz quadrada `A` do sistema `Ax = d`. Padrão: 20.', 
    type=int,  
    default=20
  )
  parser.add_argument(
    '-d', 
    action='store', 
    help='Define a quantidade de dígitos decimais da saída do programa. Padrão: 4.', 
    type=int, 
    default=4
  )
  parser.add_argument(
    '--csv', 
    action='store_true', 
    help='Exibe o resultado no formato csv'
  )

  def print_legend():
    print('\nLegenda:')
    print('i: índice')
    print('a: subdiagonal (abaixo da diagonal principal)')
    print('b: diagonal principal') 
    print('c: supradiagonal (acima da diagonal principal)') 
    print('d: termos independentes')
    print('x: solução')

  args = parser.parse_args()

  if not args.a and not args.c:
    print('Escolha um tipo de sistema -a (não cíclico) ou -c (cíclico)\n')
    parser.print_help()
  if args.a and args.c:
    print('Os argumentos -a e -c não podem ser usados simultaneamente.\nFaça cada teste separadamente.\n')
  elif args.a:  
    print(f'Sistema tridiagonal acíclico com n={args.n} e {args.d} dígitos decimais:\n')
    a, b, c, d = get_values(args.n, cyclic=False)
    l, u = decomp_lu(a, b, c)
    x = solve_tridiagonal(l, u, c, d)
    print_table(a, b, c, d, x, args.d, csv=args.csv)
    print_legend()
  elif args.c:
    print(f'Sistema tridiagonal cíclico com n={args.n} e {args.d} dígitos decimais:\n')
    a, b, c, d = get_values(args.n, cyclic=True)
    x = solve_cyclic(a, b, c, d)
    print_table(a, b, c, d, x, args.d, csv=args.csv)
    print_legend()



if __name__ == '__main__':
  cli()
