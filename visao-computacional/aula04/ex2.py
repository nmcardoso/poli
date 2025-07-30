from typing import Literal

import pandas as pd
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import MinMaxScaler, RobustScaler, StandardScaler
from sklearn.tree import DecisionTreeClassifier


def get_data(scaler: Literal['std', 'minmax', 'robust', 'none'] = 'none'):
  X_train = pd.read_csv('noisynote/ax.txt', sep='\s+', header=None, skiprows=1).values
  y_train = pd.read_csv('noisynote/ay.txt', sep='\s+', header=None, skiprows=1).values.astype(int).ravel()
  X_test = pd.read_csv('noisynote/qx.txt', sep='\s+', header=None, skiprows=1).values
  y_test = pd.read_csv('noisynote/qy.txt', sep='\s+', header=None, skiprows=1).values.astype(int).ravel()
  
  scaler_map = {
    'std': StandardScaler(),
    'minmax': MinMaxScaler(),
    'robust': RobustScaler(),
  }
  
  if scaler != 'none':
    scaler = scaler_map[scaler]
    X_train = scaler.fit_transform(X_train, y_train)
    X_test = scaler.transform(X_test)
  
  return X_train, y_train, X_test, y_test



def main():
  model = KNeighborsClassifier(3, weights='distance', algorithm='kd_tree')
  
  print('KNN Model\n=========')
  for scaler in ['none', 'minmax', 'std', 'robust']:
    X_train, y_train, X_test, y_test = get_data(scaler)
    model.fit(X_train, y_train)
    score = model.score(X_test, y_test)
    print(f'    Scaler: {scaler}   \tScore: {score:.4f}')
  
  
  model = DecisionTreeClassifier(criterion='entropy', random_state=42)
  
  print('\nDecision Tree Model\n===================')
  for scaler in ['none', 'minmax', 'std', 'robust']:
    X_train, y_train, X_test, y_test = get_data(scaler)
    model.fit(X_train, y_train)
    score = model.score(X_test, y_test)
    print(f'    Scaler: {scaler}   \tScore: {score:.4f}')
  
  
  
if __name__ == '__main__':
  main()
