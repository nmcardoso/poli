#gaussian.py 2024
import numpy as np
import cv2
#from matplotlib import pyplot as plt
ag=cv2.imread("casa.pgm",0)
a=np.float32(ag/255.0)
b=cv2.GaussianBlur(a,(0,0),5)
#plt.imshow(b,cmap="gray")
#plt.show()
cv2.imshow("janela",b)
cv2.waitKey()