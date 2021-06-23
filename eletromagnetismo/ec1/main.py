import numpy as np
import matplotlib.pyplot as plt
import progressbar

class FDM:
  def __init__(self):
    self.history = []
    self.phi = None
    self.Ex = None
    self.Ey = None
    self.k = 1
    self.epochs = None

  def _remove_nan(self, array):
    return array[~np.isnan(array)]

  def get_templete1(self, k):
    x, y = 40 * k, 80 * k
    m = np.empty((y, x), dtype=np.float)
    m[:] = 50
    m[0, :] = 100
    m[y - 1, :] = 0
    m[60*k : 74*k, 10*k : 30*k] = np.nan
    return m
  
  def compute_potential(self, epochs=50):
    self.epochs = epochs

    # Define initial state.
    m = self.get_templete1()
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

      # if epoch % 45 == 0:
      #   plt.imshow(m)
      #   plt.show()

      f_m = m[~np.isnan(m)]
      f_prev_m = prev_m[~np.isnan(prev_m)]
      self.history.append(np.sum((f_m - f_prev_m) ** 2) / f_m.shape[0])
      prev_m = np.copy(m)
    
    self.phi = m

    print(self.history[-1])
    # plt.plot(self.history)
    # plt.ylim(0, 6)
    # plt.show()
