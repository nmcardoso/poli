import numpy as np
import pandas as pd

dataset = [
  [1,	2],
  [2,	1],
  [1,	1],
  [2,	2],
  [8,	9],
  [9,	8],
  [9,	9],
  [8,	8],
  [1,	15],
  [2,	15],
  [1,	14],
  [2,	14],
]

center1 = np.array([1, 8])
center2 = np.array([6.5, 6.5])

df = pd.DataFrame(data=dataset, columns=['x1', 'x2'])

for i in range(1, 5):
  distance_center1 = np.abs(df['x1'].values - center1[0]) + np.abs(df['x2'].values - center1[1])
  distance_center2 = np.abs(df['x1'].values - center2[0]) + np.abs(df['x2'].values - center2[1])
  center1 = df[distance_center1 < distance_center2].mean().values
  center2 = df[distance_center2 < distance_center1].mean().values
  print(f'Iteration {i}')
  df2 = pd.DataFrame({'dist1': distance_center1, 'dist2': distance_center2})
  print(df2)
  print(f'Center 1: {center1}')
  print(f'Center 2: {center2}')
  print()
  print()
