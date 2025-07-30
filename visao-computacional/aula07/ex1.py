#abc1.py - 2024
import os; os.environ['TF_CPP_MIN_LOG_LEVEL']='3'
import sys

import numpy as np
import tensorflow as tf
import tensorflow.keras as keras
from tensorflow.keras import optimizers
from tensorflow.keras.layers import Activation, Dense
from tensorflow.keras.models import Sequential
from tensorflow.keras.utils import plot_model

model = Sequential();
model.add(Dense(3, activation='sigmoid', input_dim=2))
model.add(Dense(3, activation='sigmoid'))
sgd=optimizers.SGD(learning_rate=10.);
model.compile(optimizer=sgd, loss='mse', metrics=['accuracy'])
# ax = np.matrix('4; 15; 65; 5; 18; 70 ',dtype="float32")
ax = np.matrix('4 6; 15 8; 65 70; 5 90; 18 70; 70 10', dtype='float32')
ax=2*(ax/100-0.5) #-1 a +1
ay = np.matrix('0 1 0; 0 0 1; 1 0 0; 0 1 0; 0 0 1; 1 0 0',dtype="float32")
model.fit(ax, ay, epochs=120, batch_size=2, verbose=2)
qx = np.matrix('20 6; 3 50; 75 55',dtype="float32")
qx=2*(qx/100-0.5) #-1 a +1
qy = np.matrix('0 0 1; 0 1 0; 1 0 0',dtype="float32")
teste = model.evaluate(qx,qy)
print("\nCusto e acuracidade de teste:",teste)
qp2=model.predict(qx)
print("\nClassificacao de teste:\n",qp2)
qp = qp2.argmax(axis=1)
print("\nRotulo de saida:\n",qp,'\n')
plot_model(model, to_file='abc1.png', show_shapes=True)
model.summary()

