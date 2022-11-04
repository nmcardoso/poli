import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

D = 5e-2
relative_rugosity = 0.001
La = 50
Lb = 100
Lc = 200
Leq = 50
rho = 1000
upsilon = 1e-6
g = 10

nusp = ['11200608', '11391540', '11803844', '11804400']
nusp2list = lambda i: [float(n[i]) for n in nusp]

z1 = np.mean(nusp2list(2))
z2 = z1 + np.sum(nusp2list(3)) + 2
z3 = z2 + np.sum(nusp2list(4)) + 2
Hm = z3 + np.sum(nusp2list(5)) + 10

print('z1:', z1)
print('z2:', z2)
print('z3:', z3)
print('Hm:', Hm)




class DarcyEstimator:
  def __init__(self, method = None):
    self.method = method or self.haaland
    self.initial_Hj = None
    self.mean_Hj = []
    self.Hj = []
    self.fa = []
    self.fb = []
    self.fc = []
    self.Qa = []
    self.Qb = []
    self.Qc = []
  
  @staticmethod
  def colebrook(relative_rugosity: float, re2: float) -> float:
    return (-2*np.log10(relative_rugosity/3.7 + 2.51/re2))**(-2)

  @staticmethod
  def haaland(relative_rugosity: float, re: float) -> float:
    return (-1.8*np.log10((relative_rugosity/3.7)**1.11 + 6.9/re))**(-2)

  @staticmethod
  def barr(relative_rugosity: float, re: float) -> float:
    return (-2*np.log10(relative_rugosity/3.7 + 5.15/(re**0.892)))**(-2)

  @staticmethod
  def swamee_jain(relative_rugosity: float, re: float) -> float:
    return (-2*np.log10(relative_rugosity/3.7 + 5.74/(re**0.9)))**(-2)

  @staticmethod
  def churchill(relative_rugosity: float, re: float) -> float:
    return (-2*np.log10(relative_rugosity/3.7 + (7/re)**0.9))**(-2)

  @staticmethod
  def sousa_cunha_marques(relative_rugosity: float, re: float) -> float:
    return (-2*np.log10(relative_rugosity/3.7 - 
    (5.16/re)*np.log10(relative_rugosity/3.7 + 5.09/(re**0.87))))**(-2)

  @staticmethod
  def offor_alabi(relative_rugosity: float, re: float) -> float:
    k = np.log((relative_rugosity/3.93)**1.092 + (7.627/(re + 395.9)))
    return (-2*np.log10(relative_rugosity/3.71 - ((1.975 * k)/re)))**(-2)

  @staticmethod
  def brkic(relative_rugosity: float, re: float) -> float:
    k = (2.51*(1.14 - 2*np.log10(relative_rugosity))) / re + relative_rugosity/3.71
    return (-2*np.log10(k))**(-2)
  
  @staticmethod
  def ghanbari(relative_rugosity: float, re: float) -> float:
    k = (relative_rugosity/7.21)**1.042 + (2.731/re)**0.9152
    return (-1.52*np.log10(k))**(-2.169)

  @staticmethod
  def fang(relative_rugosity: float, re: float) -> float:
    k = 0.234*(relative_rugosity**1.1007) - 60.525/(re**1.1105) + 56.291/(re**1.0712)
    return 1.613*((np.log(k))**(-2))

  @classmethod
  def get_all_methods(cls):
    methods = [
      cls.colebrook, cls.haaland, cls.barr, 
      cls.swamee_jain, cls.churchill, cls.sousa_cunha,
      cls.offor_alabi, cls.brkic, cls.fang
    ]
    names = [
      'Colebrook', 'Haaland', 'Barr', 'Swamee-Jain', 
      'Churchill', 'Sousa-Cunha', 'Offor-Alabi',
      'Brkic', 'Fang'
    ]
    return list(zip(methods, names))

  def convergence_step(self, Hj: float):
    fcVc2 = ((Hj - z3)*2*g*D) / (Lc + Leq)
    fbVb2 = ((Hj - z2)*2*g*D) / Lb

    re2_c = (D/upsilon) * np.sqrt(fcVc2)
    re2_b = (D/upsilon) * np.sqrt(fbVb2)

    fc = self.colebrook(relative_rugosity, re2_c)
    fb = self.colebrook(relative_rugosity, re2_b)

    Vc = np.sqrt(fcVc2 / fc)
    Vb = np.sqrt(fbVb2 / fb)

    Va = Vc + Vb
    re_a = Va * D / upsilon
    if self.method == self.colebrook:
      faVa2 = ((Hm + z1 - Hj)*2*g*D) / La
      re2_a = (D/upsilon) * np.sqrt(faVa2)
      fa = self.method(relative_rugosity, re2_a)
    else:
      fa = self.method(relative_rugosity, re_a)
    
    new_Hj = z1 + Hm - fa * (La / D) * ((Va**2) / (2*g))

    Qa = Va * np.pi * D ** 2 / 4
    Qb = Vb * np.pi * D ** 2 / 4
    Qc = Vc * np.pi * D ** 2 / 4

    self.fa.append(fa)
    self.fb.append(fb)
    self.fc.append(fc)
    self.Qa.append(Qa)
    self.Qb.append(Qb)
    self.Qc.append(Qc)
    self.Hj.append(new_Hj)

  def solve(self, initial_Hj=40):
    self.initial_Hj = initial_Hj
    Hj = initial_Hj
    error = 1e10
    iteration = 0

    while(iteration < 1000 and error > 1e-7):
      self.convergence_step(Hj)
      mean_Hj = (Hj + self.Hj[-1]) / 2
      self.mean_Hj.append(mean_Hj)
      error = np.abs(Hj - mean_Hj)
      Hj = mean_Hj
      iteration += 1
    
  def print(self):
    print()
    print('Hj:', self.initial_Hj)

    for i in range(len(self.Hj)):
      print(f'Hj: {self.Hj[i]:.7f} fa: {self.fa[i]:.7f} fb: {self.fb[i]:.7f} '
      f'fc: {self.fc[i]:.7f} Qa: {self.Qa[i]:.7f} Qb: {self.Qb[i]:.7f} '
      f'Qc: {self.Qc[i]:.7f}')


def plot(curves, title, fname, show=False):
  plt.figure(figsize=(6.5, 5.55))

  for curve in curves:
    plt.plot(np.arange(1, len(curve[0]) + 1), curve[0], label=curve[1])

  plt.title('Convergência do parâmetro ' + title)
  plt.xlabel('iteração')
  plt.ylabel(title)
  plt.legend()
  plt.grid()
  plt.tick_params(
    axis='both', 
    direction='in', 
    top=True, 
    right=True, 
    grid_linestyle='--'
  )
  plt.savefig(fname, pad_inches=0.01, bbox_inches='tight')
  if show:
    plt.show()


def main():
  table = {
    'name': [],
    'hj': [],
    'fa': [],
    'fb': [],
    'fc': [],
    'Qa': [],
    'Qb': [],
    'Qc': []
  }

  hj_curves = []
  fa_curves = []
  fb_curves = []
  fc_curves = []
  Qa_curves = []
  Qb_curves = []
  Qc_curves = []
  
  for method, name in DarcyEstimator.get_all_methods():
    estimator = DarcyEstimator(method)
    estimator.solve()

    table['name'].append(name)
    table['hj'].append(f'{estimator.mean_Hj[-1]:.6f}')
    table['fa'].append(f'{estimator.fa[-1]:.6f}')
    table['fb'].append(f'{estimator.fb[-1]:.6f}')
    table['fc'].append(f'{estimator.fc[-1]:.6f}')
    table['Qa'].append(f'{estimator.Qa[-1]:.6f}')
    table['Qb'].append(f'{estimator.Qb[-1]:.6f}')
    table['Qc'].append(f'{estimator.Qc[-1]:.6f}')

    hj_curves.append((estimator.mean_Hj, name))
    fa_curves.append((estimator.fa, name))
    fb_curves.append((estimator.fb, name))
    fc_curves.append((estimator.fc, name))
    Qa_curves.append((estimator.Qa, name))
    Qb_curves.append((estimator.Qb, name))
    Qc_curves.append((estimator.Qc, name))
  
  df = pd.DataFrame(table)
  df.to_csv('parameters.csv', index=False)

  plot(hj_curves, '$H_j$', 'plot_Hj.pdf')
  plot(fa_curves, '$f_a$', 'plot_fa.pdf')
  plot(fb_curves, '$f_b$', 'plot_fb.pdf')
  plot(fc_curves, '$f_c$', 'plot_fc.pdf')
  plot(Qa_curves, '$Q_a$', 'plot_Qa.pdf')
  plot(Qb_curves, '$Q_b$', 'plot_Qb.pdf')
  plot(Qc_curves, '$Q_c$', 'plot_Qc.pdf')
  


def main2():
  estimator = DarcyEstimator(DarcyEstimator.haaland)
  estimator.solve()
  estimator.print()


if __name__ == '__main__':
  main()
