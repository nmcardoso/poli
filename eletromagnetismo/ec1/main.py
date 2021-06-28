import numpy as np
import matplotlib.pyplot as plt
import progressbar
from statistics import mode


def template1(k, initial_value):
  a, b, c, d, e = int(40*k), int(120*k), int(20*k), int(14*k), int(6*k)
  f = int((a-c)/2)

  x, y = a, b
  t = np.empty((y, x), dtype=np.float)
  t[:] = initial_value
  t[0, :] = 100
  t[-1, :] = 0
  t[-(d+e):-e, f:f+c] = np.nan
  return t


def template2(k, initial_value):
  a, b, c, d, e = int(40*k), int(120*k), int(20*k), int(14*k), int(6*k)
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


def plot_field(Ex, Ey, potential, title='', show=True, filename=None):
  p = remove_nan(potential)
  x, y = potential.shape[1] - 1, potential.shape[0] - 1
  
  lvl = np.linspace(np.amin(p), np.amax(p), int((np.amax(p) - np.amin(p)) / 10))
  X1, Y1 = np.meshgrid(np.linspace(0, x+1, x+1), np.linspace(0, y+1, y+1))
  cs = plt.contour(X1, Y1, potential, colors='red', levels=lvl)
  plt.clabel(cs, lvl, fontsize=8, inline_spacing=1, rightside_up=True, use_clabeltext=True)

  X, Y = np.meshgrid(np.linspace(0, x, x), np.linspace(0, y, y))
  plt.streamplot(X, Y, Ex, Ey)
  plt.gca().invert_yaxis()
  plt.title(title)
  if filename is not None:
    plt.savefig(filename, bbox_inches='tight', pad_inches=0.05)
  if show:
    plt.show()
  plt.close()


if __name__ == '__main__':
  k = 2
  t = template1(k, 50)

  def plot_callback(opts):
    if opts['epoch'] % 100 != 0:
      return
    Ex, Ey = compute_ef(opts['potential'], k*1e-3)
    plot_field(Ex, Ey, opts['potential'], title=f'Epoch {opts["epoch"]}', show=False, filename=f'field_{opts["epoch"]}.png')
    resistences = compute_resistence(100, k*40e-3, k*1e-3, 5, Ey, axis=0)
    plt.plot(resistences)
    plt.hlines(np.median(resistences), xmin=0, xmax=len(resistences)-1, color="red")
    plt.hlines(mode(resistences), xmin=0, xmax=len(resistences)-1, color="green")
    plt.title(f'Epoch {opts["epoch"]}')
    plt.savefig(f'resistencia_{opts["epoch"]}.png', bbox_inches='tight', pad_inches=0.05)
    plt.close()
  
  potential, history = compute_potential(t, axis=0, epochs=4001, callbacks=[plot_callback])
  # Ex, Ey = compute_ef(potential, k*1e-3)
  # resistences = compute_resistence(100, k*40e-3, k*1e-3, 5, Ey, axis=1)

  # plot_field(Ex, Ey, potential)
  # plt.plot(resistences)
  # plt.hlines(np.median(resistences), xmin=0, xmax=len(resistences)-1, color="red")
  # plt.hlines(mode(resistences), xmin=0, xmax=len(resistences)-1, color="green")
  # plt.show()