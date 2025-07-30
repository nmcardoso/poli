import sys

import cv2
import matplotlib.pyplot as plt
import numpy as np
from numpy.lib.stride_tricks import sliding_window_view
from sklearn import tree
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.neighbors import KNeighborsClassifier


def show(windowName: str, img: np.ndarray, width: int = -1, height: int = -1, x: int = -1, y: int = -1):
  cv2.namedWindow(windowName, cv2.WINDOW_NORMAL)
  cv2.imshow(windowName, img)
  if (width > 0 and height > 0):
    cv2.resizeWindow(windowName, width, height)
  if (x >= 0 and y >= 0):
    cv2.moveWindow(windowName, x, y)


def preprocess_features(a: np.ndarray, window_size: int = 7):
  pad_size = int((window_size - 1) / 2)
  padded_a = np.pad(a, [[pad_size, pad_size], [pad_size, pad_size]], 'edge')
  b = sliding_window_view(padded_a, (window_size, window_size))
  return b.reshape((a.shape[0]*a.shape[1], window_size*window_size))


def main():
  ax = cv2.imread("aprendizagem/lax.bmp", 0)
  ay = cv2.imread("aprendizagem/lay.bmp", 0)
  
  if ax.shape[0] != ay.shape[0] or ax.shape[1] != ay.shape[1]:
    sys.exit("Erro: Imagens com dimensoes diferentes")
    
  features = preprocess_features(ax/255, 7)
  saidas = (ay/255).reshape((ay.shape[0]*ay.shape[1],))
  
  arvore = tree.DecisionTreeClassifier(criterion='entropy', random_state=42,)
  arvore = arvore.fit(features, saidas)
  
  qx = cv2.imread("aprendizagem/lqx.bmp", 0)
  query = preprocess_features(qx/255, 7)
  
  qp = arvore.predict(query)
  qp = qp.reshape((qx.shape[0], qx.shape[1]))
  
  w = 450
  h = 400
  show('Treino', ax, width=w, height=h, x=100, y=30)
  show('Referencia', ay, width=w, height=h, x=600, y=30)
  show('Query', qx, width=w, height=h, x=100, y=550)
  show('Resultado', qp, width=w, height=h, x=600, y=550)
  cv2.waitKey(0)
  
  
if __name__ == '__main__':
  main()
