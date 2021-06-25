import numpy as np
import matplotlib.pyplot as plt
import progressbar


def template1(k, initial_value):
  a, b, c, d, e = 40*k, 120*k, 20*k, 14*k, 6*k
  f = int((a-c)/2)

  x, y = a, b
  t = np.empty((y, x), dtype=np.float)
  t[:] = initial_value
  t[0, :] = 100
  t[-1, :] = 0
  t[-(d+e):-e, f:f+c] = np.nan
  return t


def template2(k, initial_value):
  a, b, c, d, e = 40*k, 120*k, 20*k, 14*k, 6*k
  f, g = d+e, int(c/2)

  x, y = int((a/2)), b
  t = np.empty((y, x), dtype=float)
  t[:] = initial_value
  t[:, 0] = 0
  t[:, -1] = 100
  t[-f:-e, -g:] = np.nan
  t[-f, -g:] = 100
  t[-e, -g:] = 100
  t[-f:-e, -g] = 100
  return t


def remove_nan(array):
  return array[~np.isnan(array)]


def compute_potential(template, axis, epochs=50, callbacks=[]):
  history = []
  p = np.copy(template)
  prev = np.copy(template)
  x, y = p.shape[1], p.shape[0]

  def get_neighbors(i, j, p):
    if (j - 1) < 0 or np.isnan(p[j - 1, i]):
      t = p[j + 1, i]
    else:
      t = p[j - 1, i]

    if (j + 1) >= y or np.isnan(p[j + 1, i]):
      b = p[j - 1, i]
    else:
      b = p[j + 1, i]

    if (i - 1) < 0 or np.isnan(p[j, i - 1]):
      l = p[j, i + 1]
    else:
      l = p[j, i - 1]

    if (i + 1) >= x or np.isnan(p[j, i + 1]):
      r = p[j, i - 1]
    else:
      r = p[j, i + 1]
    return t, b, l, r
  
  for epoch in progressbar.progressbar(range(epochs)):
    if axis == 0:
      for j in range(1, y - 1):
        for i in range(x):
          if np.isnan(p[j, i]):
            continue
          t, b, l, r = get_neighbors(i, j, p)
          p[j, i] = (t + b + l + r) / 4.
    else:
      for i in range(1, x - 1):
        for j in range(y):
          if np.isnan(p[j, i]):
            continue
          t, b, l, r = get_neighbors(i, j, p)
          p[j, i] = (t + b + l + r) / 4.

    f_p = remove_nan(p)
    f_prev = remove_nan(prev)
    history.append(np.sum((f_p - f_prev) ** 2) / f_p.shape[0])
    prev = np.copy(p)

    for callback in callbacks:
      callback({ 'history': history, 'potential': p, 'epoch': epoch })
  return p, history


def compute_ef(p, h):
  x, y = p.shape[1] - 1, p.shape[0] - 1
  Ex = np.empty((y, x), dtype=float)
  Ey = np.empty((y, x), dtype=float)
  Ex[:] = np.nan
  Ey[:] = np.nan

  for j in range(y):
    for i in range(x):
      if np.isnan(p[j, i]):
        continue
      Ex[j, i] = (p[j, i] + p[j+1, i] - p[j, i+1] - p[j+1, i+1]) / (2 * h)
      Ey[j, i] = (p[j, i] + p[j, i+1] - p[j+1, i] - p[j+1, i+1]) / (2 * h)
  return Ex, Ey


def compute_resistence(V, l, h, sigma, E, axis):
  if axis == 0:
    R = np.empty(E.shape[0])
    for j in range(E.shape[0]):
      R[j] = V / (l * sigma * h * np.sum(np.abs(remove_nan(E[j, :]))))
  else:
    R = np.empty(E.shape[1])
    for i in range(E.shape[1]):
      R[i] = V / (l * sigma * h * np.sum(np.abs(remove_nan(E[:, i]))))
  return R

  lvl = np.linspace(np.amin(p), np.amax(p), int((np.amax(p) - np.amin(p)) / 10))
  X, Y = np.meshgrid(np.linspace(0,x,x),np.linspace(0,y,y))
  X1, Y1 = np.meshgrid(np.linspace(0,x + 1,x + 1),np.linspace(0,y +1,y+1))
  # print(X.shape, Y.shape, Ex.shape, Ey.shape)
  cs = plt.contour(X1, Y1, m, colors='red', levels=lvl)
  plt.clabel(cs, lvl, fontsize=8, inline_spacing=2, rightside_up=True, use_clabeltext=True)
  # cb = plt.colorbar(cp)
  # plt.show()
  plt.streamplot(X, Y, Ex, Ey)
  plt.gca().invert_yaxis()
  # plt.title(f'Iterações: {self.epochs}')
  plt.show()

  return Ex, Ey


def compute_resistence(V, l, h, sigma, Ey):
  R = np.empty(Ey.shape[0])
  for j in range(Ey.shape[0]):
    R[j] = V / (l * sigma * h * np.sum(remove_nan(Ey[j])))

  plt.plot(R)
  # plt.title(f'Iterações: {self.epochs}')
  plt.show()
  
  return R



if __name__ == '__main__':
  template2(1, 50)
  # k = 1
  # p, h = compute_potential(template1(k), epochs=300)
  # Ex, Ey = compute_ef(p, k * 1e-3)
  # print(compute_resistence(100, k * 40e-3, k * 1e-3, 5, Ey))
