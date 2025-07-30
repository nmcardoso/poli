from typing import Dict, List, Tuple

import numpy as np


def print_latex(
  events_map: Dict[Tuple[int, int], List[float]], 
  events: List[Tuple[int, int]], 
  prior: List[float]
):
  events_probs = [v for k, v in events_map.items() if k in events]
  
  labels = ['\lambda^{{ {i},' + str(k) + '}}_{{' + str(j) + '}}' for k, j in events] + ['P(H{i})']
  print('\\begin{equation}')
  print('\\alpha = \\frac{1}{', end='')
  for i in range(len(prior)):
    print(''.join([l.format(i) for l in labels]), end='')
    print('+', end='')
  print('}')
  print('\\end{equation}')
  
  print('\\begin{equation}')
  print('\\begin{bmatrix}', end='')
  print('\\\\'.join([f'P(H_{{{i}}}|e)' for i in range(len(prior))]), end='')
  print('\\end{bmatrix}')
  print('=')
  for e, label in zip(events_probs + [prior], events + ['prior']):
    print('\\underbrace{', end='')
    print('\\begin{bmatrix}', end='')
    print('\\\\'.join([f'{_e:.4f}' for _e in e]), end='')
    print('\\end{bmatrix}', end='')
    print(f'}}_{{{label}}}')
    print('\\otimes')
  print('\\,\\alpha')
  print('\\end{equation}')
  


def compute_posterior(events: List[List[float]], prior: List[float]) -> float:
  prod = np.prod(events, axis=0) * prior
  alpha_inv = np.sum(prod)
  probas = prod / alpha_inv
  return probas



def main():
  events = {
    (1, 1): [0.5, 0.06, 0.5, 1],
    (1, 2): [0.4, 0.5, 0.1, 0],
    (1, 3): [0.1, 0.44, 0.4, 0],
    (2, 1): [0.5, 0.06, 0.5, 1],
    (2, 2): [0.4, 0.5, 0.1, 0],
    (2, 3): [0.1, 0.44, 0.4, 0]
  }
  prior = [0.099, 0.0099, 0.0001, 0.891]

  posterior = compute_posterior([events[(1,3)], events[(2, 1)], events[(2, 3)]], prior)
  print_latex(events, [(1, 3), (2, 1), (2, 3)], prior)





if __name__ == "__main__":
  main()
