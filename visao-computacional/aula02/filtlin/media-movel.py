#media-movel.py - 2024
import cv2
import sys
import numpy as np

if len(sys.argv)!=3:
  sys.exit("media-movel ent.pgm sai.pgm")

ent=cv2.imread(sys.argv[1],0)

ker=[[1,1,1], [1,1,1], [1,1,1]]
ker=np.float32(ker)
ker=(1.0/9.0)*ker

sai=cv2.filter2D(ent,-1,ker)
cv2.imwrite(sys.argv[2],sai)
