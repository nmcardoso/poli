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


