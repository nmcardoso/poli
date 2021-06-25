import numpy as np
import matplotlib.pyplot as plt
import progressbar


def template1(k):
  x, y = 40 * k, 80 * k
  m = np.empty((y, x), dtype=np.float)
  m[:] = 50
  m[0, :] = 100
  m[y - 1, :] = 0
  m[60*k : 74*k, 10*k : 30*k] = np.nan
  return m


def remove_nan(array):
  return array[~np.isnan(array)]


def compute_potential(m, epochs=50):
  # self.epochs = epochs
  history = []

  # Define initial state.
  x, y = m.shape[1], m.shape[0]
  prev_m = np.copy(m)
  
  for epoch in progressbar.progressbar(range(epochs)):
    for j in range(1, y - 1):
      for i in range(x):
        if np.isnan(m[j, i]):
          continue

        # Define neighbor points
        if j - 1 < 0 or np.isnan(m[j - 1, i]):
          t = m[j + 1, i]
        else:
          t = m[j - 1, i]

        if j + 1 >= y or np.isnan(m[j + 1, i]):
          b = m[j - 1, i]
        else:
          b = m[j + 1, i]

        if i - 1 < 0 or np.isnan(m[j, i - 1]):
          l = m[j, i + 1]
        else:
          l = m[j, i - 1]

        if i + 1 >= x or np.isnan(m[j, i + 1]):
          r = m[j, i - 1]
        else:
          r = m[j, i + 1]

        m[j, i] = (t + b + l + r) / 4

    f_m = m[~np.isnan(m)]
    f_prev_m = prev_m[~np.isnan(prev_m)]
    history.append(np.sum((f_m - f_prev_m) ** 2) / f_m.shape[0])
    prev_m = np.copy(m)
  
  return m, history


def compute_ef(m, h):
  x, y = m.shape[1] - 1, m.shape[0] - 1
  Ex = np.empty((y, x), dtype=float)
  Ey = np.empty((y, x), dtype=float)
  Ex[:] = np.nan
  Ey[:] = np.nan

  for j in range(y):
    for i in range(x):
      if np.isnan(m[j, i]):
        continue

      Ex[j, i] = (m[j, i] + m[j+1, i] - m[j, i+1] - m[j+1, i+1]) / (2 * h)
      Ey[j, i] = (m[j, i] + m[j, i+1] - m[j+1, i] - m[j+1, i+1]) / (2 * h)

  p = m[~np.isnan(m)]

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
  k = 1
  p, h = compute_potential(template1(k), epochs=300)
  Ex, Ey = compute_ef(p, k * 1e-3)
  print(compute_resistence(100, k * 40e-3, k * 1e-3, 5, Ey))
