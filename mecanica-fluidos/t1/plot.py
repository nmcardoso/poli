import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from darcy import DarcyEstimator


def plot(curves, title, fname, show=False, wide=False, loc='best'):
  if wide:
    plt.figure(figsize=(8.6, 5.55))
  else:
    plt.figure(figsize=(6.5, 5.55))

  for curve in curves:
    plt.plot(np.arange(1, len(curve[0]) + 1), curve[0], label=curve[1])

  plt.title('Convergência do parâmetro ' + title, fontsize=16)
  plt.xlabel('iteração', fontsize=13)
  # plt.ylabel(title)
  plt.legend(ncol=3, loc=loc)
  plt.grid()
  plt.tick_params(
    axis='both', 
    direction='in', 
    top=True, 
    right=True, 
    grid_linestyle='--'
  )
  plt.savefig(f'plots/{fname}', pad_inches=0.01, bbox_inches='tight')
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
    'Qc': [],
    'hj_err': [],
    'fa_err': [],
    'fb_err': [],
    'fc_err': [],
    'Qa_err': [],
    'Qb_err': [],
    'Qc_err': [],
  }

  hj_curves = []
  fa_curves = []
  fb_curves = []
  fc_curves = []
  Qa_curves = []
  Qb_curves = []
  Qc_curves = []
  hj_colebrook = None
  fa_colebrook = None
  fb_colebrook = None
  fc_colebrook = None
  Qa_colebrook = None
  Qb_colebrook = None
  Qc_colebrook = None
  
  for method, name in DarcyEstimator.get_all_methods():
    estimator = DarcyEstimator(method)
    estimator.solve()

    if method == DarcyEstimator.colebrook:
      hj_colebrook = estimator.mean_Hj[-1]
      fa_colebrook = estimator.fa[-1]
      fb_colebrook = estimator.fb[-1]
      fc_colebrook = estimator.fc[-1]
      Qa_colebrook = estimator.Qa[-1]
      Qb_colebrook = estimator.Qb[-1]
      Qc_colebrook = estimator.Qc[-1]

    table['name'].append(name)
    table['hj'].append(f'{estimator.mean_Hj[-1]:.5f}')
    table['fa'].append(f'{estimator.fa[-1]:.6f}')
    table['fb'].append(f'{estimator.fb[-1]:.6f}')
    table['fc'].append(f'{estimator.fc[-1]:.6f}')
    table['Qa'].append(f'{estimator.Qa[-1]:.6f}')
    table['Qb'].append(f'{estimator.Qb[-1]:.6f}')
    table['Qc'].append(f'{estimator.Qc[-1]:.6f}')
    table['hj_err'].append(f'{np.abs((estimator.mean_Hj[-1] - hj_colebrook)*100/hj_colebrook):.4f}')
    table['fa_err'].append(f'{np.abs((estimator.fa[-1] - fa_colebrook)*100/fa_colebrook):.4f}')
    table['fb_err'].append(f'{np.abs((estimator.fb[-1] - fb_colebrook)*100/fb_colebrook):.4f}')
    table['fc_err'].append(f'{np.abs((estimator.fc[-1] - fc_colebrook)*100/fc_colebrook):.4f}')
    table['Qa_err'].append(f'{np.abs((estimator.Qa[-1] - Qa_colebrook)*100/Qa_colebrook):.4f}')
    table['Qb_err'].append(f'{np.abs((estimator.Qb[-1] - Qb_colebrook)*100/Qb_colebrook):.4f}')
    table['Qc_err'].append(f'{np.abs((estimator.Qc[-1] - Qc_colebrook)*100/Qc_colebrook):.4f}')

    hj_curves.append((estimator.mean_Hj, name))
    fa_curves.append((estimator.fa, name))
    fb_curves.append((estimator.fb, name))
    fc_curves.append((estimator.fc, name))
    Qa_curves.append((estimator.Qa, name))
    Qb_curves.append((estimator.Qb, name))
    Qc_curves.append((estimator.Qc, name))
  
  df = pd.DataFrame(table)
  get_argmin = lambda col: np.argmin(df[col][1:]) + 1
  latex_bold = lambda col: f"\\bf{{{df[col][get_argmin(col)]}}}"
  df['hj_err'][get_argmin('hj_err')] = latex_bold('hj_err')
  df['fa_err'][get_argmin('fa_err')] = latex_bold('fa_err')
  df['fb_err'][get_argmin('fb_err')] = latex_bold('fb_err')
  df['fc_err'][get_argmin('fc_err')] = latex_bold('fc_err')
  df['Qa_err'][get_argmin('Qa_err')] = latex_bold('Qa_err')
  df['Qb_err'][get_argmin('Qb_err')] = latex_bold('Qb_err')
  df['Qc_err'][get_argmin('Qc_err')] = latex_bold('Qc_err')
  df.to_csv('plots/parameters.csv', index=False)

  plot(hj_curves, '$H_j$', 'plot_Hj.pdf', loc='lower right', wide=True)
  plot(fa_curves, '$f_a$', 'plot_fa.pdf')
  plot(fb_curves, '$f_b$', 'plot_fb.pdf', loc='lower right')
  plot(fc_curves, '$f_c$', 'plot_fc.pdf', loc='lower right')
  plot(Qa_curves, '$Q_a$', 'plot_Qa.pdf')
  plot(Qb_curves, '$Q_b$', 'plot_Qb.pdf')
  plot(Qc_curves, '$Q_c$', 'plot_Qc.pdf')



if __name__ == '__main__':
  main()
