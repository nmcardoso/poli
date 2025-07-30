#media-py.py 2024
import cv2
import numpy as np

def mediamov(a):
  b=np.empty(a.shape)
  for l in range(a.shape[0]):
    for c in range(a.shape[1]):
      soma=0
      for l2 in range(-1,2):
        for c2 in range(-1,2):
          l3=l+l2; c3=c+c2;
          if l3<0: l3=-l3;
          if a.shape[0]<=l3: l3=a.shape[0]-(l3-a.shape[0]+2);
          if c3<0: c3=-c3;
          if a.shape[1]<=c3: c3=a.shape[1]-(c3-a.shape[1]+2);
          soma = soma+a[l3,c3]
      b[l,c]=round(soma/9)
  return b

a=cv2.imread("lion.png",0)
b=mediamov(a)
cv2.imwrite("media-py.png",b)


