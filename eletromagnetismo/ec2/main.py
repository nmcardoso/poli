import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl

# Dados de entrada
m = 1
n = 2
p = 2
eps = 8.854e-12
h1 = 10
h2 = 0.005*n + 10.05
h3 = 0.2*p + 11
a1 = (0.2*m + 1)*1e-2
l2 = 20e-2
a3 = 2e-2
b = 5e-5
l = 1e3

# Calcula o número de cilindros de carga para representar os corpos
K1 = int(np.round((2*np.pi*a1)/(2*b)))
K2 = int(np.round(l2/(2*b)))
K3 = int(np.round((2*np.pi*a3)/(2*b)))

# Distribui os cilindros de carga uniformemente sobre os corpos,
# determinando as coordenadas (x,y) dos seus eixos
i = np.arange(0, K1, 1)
theta = i*(2*np.pi/K1)
x1 = a1*np.cos(theta)
y1 = a1*np.sin(theta) + h1

x2 = np.arange(-l2/2, l2/2, 2*b)
y2 = np.ones((K2,))*h2

i = np.arange(0, K3, 1)
theta = i*(2*np.pi/K3)
x3 = a3*np.cos(theta)
y3 = a3*np.sin(theta) + h3


def parte_ab():
  x = np.concatenate([x1, x2, x3])
  y = np.concatenate([y1, y2, y3])

  K = K1 + K2 + K3
  i = np.arange(0, K, 1)
  j = np.arange(0, K, 1)
  [i, j] = np.meshgrid(i, j)

  r1 = np.sqrt((x[i]-x[j])**2 + (y[i]-y[j])**2)
  r1[i==j] = b
  r2 = np.sqrt((x[i]-x[j])**2 + (y[i]+y[j])**2)

  s = np.log(r2/r1)/2/np.pi/eps/l

  V = [
    [1, 0, 0],
    [0, 1, 0],
    [0, 0, 1]
  ]
  C = []
  for Vi in V:
    phi = np.concatenate([
      np.ones(K1)*Vi[0], 
      np.ones(K2)*Vi[1], 
      np.ones(K3)*Vi[2]
    ])
    rhoL = np.linalg.solve(s, phi)
    Qi1 = np.sum(rhoL[:K1])
    Qi2 = np.sum(rhoL[K1:(K1+K2)])
    Qi3 = np.sum(rhoL[(K1+K2):])
    Ci1 = Qi1 / 1
    Ci2 = Qi2 / 1
    Ci3 = Qi3 / 1
    C += [[Ci1, Ci2, Ci3]]
  C = np.array(C)
  
  print(C)
  print('C10', np.sum(C[0]))
  print('C20', np.sum(C[1]))
  print('C30', np.sum(C[2]))
  print('C12', -C[0,1])
  print('C13', -C[0,2])
  print('C21', -C[1,0])
  print('C23', -C[1,2])
  print('C31', -C[2,0])
  print('C32', -C[2,1])


