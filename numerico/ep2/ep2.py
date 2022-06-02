

from typing import Callable, Tuple, Union
import numpy as np
from scipy.integrate import dblquad, quad


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

def get_pairs(n: int) -> Tuple[np.ndarray, np.ndarray]:
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
  nodes, weights = get_pairs(n)
  g1 = (b - a) / 2
  g2 = (b + a) / 2
  I = 0

  for i in range(n):
    I_partial = 0
    x = g1 * nodes[i] + g2
    di = d(x) if callable(d) else d
    ci = c(x) if callable(c) else c
    h1 = (di - ci) / 2
    h2 = (di + ci) / 2
    
    for j in range(n):
      y = h1 * nodes[j] + h2
      I_partial += weights[j] * f(x, y)
    
    I += weights[i] * h1 * I_partial

  I *= g1
  return I



