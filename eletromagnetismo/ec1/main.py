import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
import matplotlib.patches as mpatches
import progressbar



###########################
##   Utility functions   ##
###########################

def remove_nan(array):
  return array[~np.isnan(array)]



############################
##   Template functions   ##
############################

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


###############################
##   Computation functions   ##
###############################

def compute_potential(template, axis, epochs=50, max_error=None, callbacks=[]):
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

  if max_error is None:
    bar = progressbar.ProgressBar(max_value=epochs)
  else:
    bar = progressbar.ProgressBar(max_value=progressbar.UnknownLength)
  curr_epoch = 0
  curr_error = 1e12
  while True:
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
    curr_error = np.sum((f_p - f_prev) ** 2) / f_p.shape[0]
    curr_epoch += 1
    history.append(curr_error)
    prev = np.copy(p)

    stop_signal = False
    for callback in callbacks:
      r = callback({ 'history': history, 'potential': p, 'epoch': curr_epoch })
      if isinstance(r, dict) and 'stop' in r.keys() and r['stop'] == True:
        stop_signal = stop_signal or True

    bar.update(curr_epoch)

    if stop_signal or \
      (max_error is None and curr_epoch > epochs) or \
      (max_error is not None and curr_error < max_error):
      break

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


def compute_resistence(V, l, h, condutivity, Ex, Ey, axis):
  if axis == 0:
    R = np.empty(Ey.shape[0])
    for j in range(Ey.shape[0]):
      flux = h * np.sum(np.abs(remove_nan(Ey[j, :])))
      R[j] = V / (l * condutivity * flux + 1e-12) # 1e-12: avoid division by 0
  else:
    R = np.empty(Ex.shape[1])
    for i in range(Ex.shape[1]):
      flux = h * np.sum(np.abs(remove_nan(Ex[:, i])))
      R[i] = V / (l * condutivity * flux)
  return R



#################################
##   Vizualization functions   ##
#################################

def plot_equipotential(potential, k=1, title='', show=True, filename=None):
  p = remove_nan(potential)
  x, y = potential.shape[1] - 1, potential.shape[0] - 1
  
  lvl = np.arange(np.amin(p), np.amax(p) + 1, 2) # Delta Phi = 2V
  X1, Y1 = np.meshgrid(np.linspace(0, x+1, x+1), np.linspace(0, y+1, y+1))
  fig = plt.figure()
  ax = fig.add_subplot(111)
  cs = ax.contour(X1, Y1, potential, levels=lvl, cmap='viridis')
  
  norm= mpl.colors.Normalize(vmin=cs.cvalues.min(), vmax=cs.cvalues.max())
  sm = plt.cm.ScalarMappable(norm=norm, cmap = cs.cmap)
  sm.set_array([])
  fig.colorbar(sm, ticks=np.arange(np.amin(p), np.amax(p) + 1, 10))

  ax.invert_yaxis()
  ax.set_aspect('equal')
  ax.set_title(title)
  ax.set_xlabel('Largura')
  ax.set_ylabel('Altura')

  if filename is not None:
    plt.savefig(filename, bbox_inches='tight', pad_inches=0.05)
  if show:
    plt.show()
  plt.close()


def plot_field(Ex, Ey, title='', show=True, filename=None):
  x, y = Ex.shape[1], Ex.shape[0]
  X, Y = np.meshgrid(np.linspace(0, x, x), np.linspace(0, y, y))
  fig = plt.figure(figsize=(5, 12))
  ax = fig.add_subplot(111)
  ax.quiver(
    X, Y, Ex, -Ey,
    scale=1e4, 
    scale_units='xy',
    color='tab:blue'
  )
  ax.invert_yaxis()
  ax.set_aspect('equal')
  ax.set_title(title)
  if filename is not None:
    plt.savefig(filename, bbox_inches='tight', pad_inches=0.05)
  if show:
    plt.show()
  plt.close()


def plot_reistences(resistences, title='', show=True, filename=None):
  plt.plot(resistences, color='tab:blue')
  plt.hlines(np.median(resistences), xmin=0, xmax=len(resistences)-1, color='tab:red')
  plt.ylim((0, 25))
  plt.title(title)
  if filename is not None:
    plt.savefig(filename, bbox_inches='tight', pad_inches=0.05)
  if show:
    plt.show()
  plt.close()


def plot_templates(template1, template2, show=True, filename=None):
  fig, ax = plt.subplots(1, 2, figsize=(6, 10))
  color_100 = mpl.cm.get_cmap('viridis')(100/100)
  color_50 = mpl.cm.get_cmap('viridis')(50/100)
  color_0 = mpl.cm.get_cmap('viridis')(0/100)
  color_nan = mpl.cm.get_cmap('viridis')(np.nan)
  plt.legend(
    handles=[
      mpatches.Patch(color=color_100, label='V=100'),
      mpatches.Patch(color=color_50, label='V=50'),
      mpatches.Patch(color=color_0, label='V=0'),
      mpatches.Patch(color=color_nan, label='Indet.'),
    ], 
    bbox_to_anchor=(1.03, 0.5), 
    loc='center left'
  )
  ax[0].imshow(template1, aspect='auto')
  ax[1].imshow(template2, aspect='auto')
  if filename is not None:
    plt.savefig(filename, bbox_inches='tight', pad_inches=0.05)
  if show:
    plt.show()
  plt.close()



########################
##   Main Functions   ##
########################

def problem_1():
  k = 2
  h = (1/k)*1e-3
  max_error = 1e-10
  t = template1(k, 50)

  def plot_callback(params):
    if params['epoch'] % 1000 != 0:
      return

    Ex, Ey = compute_ef(params['potential'], h)
    resistences = compute_resistence(
      V=100, 
      l=100e-3, 
      h=h, 
      condutivity=5, 
      Ex=Ex, 
      Ey=Ey, 
      axis=0
    )
    plot_reistences(
      resistences, 
      title=f'Epoch {params["epoch"]}', 
      filename=f'p1/res_{params["epoch"]}.pdf',
      show=False
    )

  potential, history = compute_potential(
    template=t,
    axis=0,
    max_error=max_error,
    callbacks=[plot_callback]
  )
  np.save('p1_history.npy', np.array(history))
  np.save('p1_potential.npy', potential)
  
  plot_equipotential(
    potential, 
    k=k, 
    title='Equipotenciais', 
    filename='p1_equipotenciais.pdf'
  )

  Ex, Ey = compute_ef(potential, h=h)
  plot_field(
    Ex, Ey, 
    title='Campo Elétrico', 
    filename='p1_campo_eletrico.pdf'
  )

  resistence = compute_resistence(
    V=100, 
    l=100e-3, 
    h=h, 
    condutivity=5, 
    Ex=Ex,
    Ey=Ey, 
    axis=0
  )
  print(f'Resistencia: {resistence} Ohms')


def problem_2():
  k = 2
  h = (1/k)*1e-3
  max_error = 1e-10
  axis = 1
  t = template2(k, 50)

  potential, history = compute_potential(
    template=t,
    axis=axis,
    max_error=max_error
  )
  np.save('p2_history.npy', np.array(history))
  np.save('p2_potential.npy', potential)
  
  plot_equipotential(
    potential, 
    k=k, 
    title='Equipotenciais', 
    filename='p2_equipotenciais.pdf'
  )

  Ex, Ey = compute_ef(potential, h=h)
  plot_field(
    Ex, Ey, 
    title='Campo Elétrico', 
    filename='p2_campo_eletrico.pdf'
  )

  resistence = compute_resistence(
    V=100, 
    l=100e-3, 
    h=h, 
    condutivity=5, 
    Ex=Ex,
    Ey=Ey, 
    axis=axis
  )
  print(f'Resistencia: {resistence} Ohms')

if __name__ == '__main__':
  problem_1()
  problem_2()