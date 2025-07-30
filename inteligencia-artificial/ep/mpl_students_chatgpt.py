# PCS3438 - Inteligência Artificial - 2023/2
# Template para aula de laboratório em Redes Neurais - 20/09/2023

import numpy as np
from sklearn.datasets import load_breast_cancer
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler, StandardScaler


def sigmoid(x: np.ndarray):
  return 1 / (1 + np.exp(-x))


def sigmoid_derivative(x: np.ndarray):
  return x * (1 - x)


def mse_loss(y: np.ndarray, y_hat: np.ndarray):
  return np.mean(np.power(y - y_hat, 2))


def mse_loss_derivative(y: np.ndarray, y_hat: np.ndarray):
  return y_hat - y


class Layer:
  def __init__(self, input_dim: int, output_dim: int, reg_strength: float = 0.0):
    self.weights = 2 * np.random.random((input_dim, output_dim)) - 1
    self.biases = np.zeros((1, output_dim))
    self.input: np.ndarray | None = None
    self.output: np.ndarray | None = None
    self.reg_strength = reg_strength  # Força da regularização L2

  def forward(self, input_data) -> np.ndarray:
    self.input = input_data
    raw_output = np.dot(input_data, self.weights) + self.biases
    self.output = sigmoid(raw_output)
    return self.output

  def backward(self, output_error: np.ndarray, learning_rate: float) -> np.ndarray:
    local_gradient = sigmoid_derivative(self.output)
    layer_error = output_error * local_gradient

    # Termo de regularização L2
    reg_term = 2 * self.reg_strength * self.weights

    # Atualiza os pesos e biases usando gradiente descendente com termo de regularização L2
    self.weights -= (np.dot(self.input.T, layer_error) + reg_term) * learning_rate
    self.biases -= np.sum(layer_error, axis=0, keepdims=True) * learning_rate

    # Retorna o erro para a camada anterior
    return np.dot(layer_error, self.weights.T)


def forward(input: np.ndarray, layers: list[Layer]):
  """
  Args:
    input (np.ndarray): Input data
    layers (list[Layer]): List of layers

  Returns:
    np.ndarray: Output of the MLP model
  """
  current_input = input
  for layer in layers:
    current_input = layer.forward(current_input)
  return current_input


def backward(
  y: np.ndarray, y_hat: np.ndarray, layers: list[Layer], learning_rate: float
) -> None:
  """
  Args:
    y (np.ndarray): Ground truth
    y_hat (np.ndarray): Predicted values
    layers (list[Layer]): List of layers
    learning_rate (float): Learning rate
  """
  output_error = mse_loss_derivative(y, y_hat)
  for layer in reversed(layers):
    output_error = layer.backward(output_error, learning_rate)

  
def main():
  # Carregar o conjunto de dados Breast Cancer Wisconsin
  data = load_breast_cancer()
  X = data.data
  y = data.target

  # Dividir o conjunto de dados em treino e teste (80% treino, 20% teste)
  X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
  print(X_train.shape)

  # Normalizar as features usando Z-Score (StandardScaler)
  scaler = StandardScaler()
  X_train_normalized = scaler.fit_transform(X_train)
  X_test_normalized = scaler.transform(X_test)

  # Definir hiperparâmetros
  layer_sizes = [X.shape[1], 10, 8, 1]
  epochs = 10000
  lr_0 = 0.1
  batch_size = 64
  lr = lr_0
  reg_strength = 0.001

  # Inicializar camadas com regularização
  layers = [Layer(layer_sizes[i], layer_sizes[i + 1], reg_strength) for i in range(len(layer_sizes) - 1)]

  # Treinar o modelo MLP
  for epoch in range(epochs):
      # Shuffle the data for SGD
      indices = np.arange(X_train_normalized.shape[0])
      np.random.shuffle(indices)
      X_train_shuffled = X_train_normalized[indices]
      y_train_shuffled = y_train[indices]

      for i in range(0, X_train_normalized.shape[0], batch_size):
          # Create batches
          X_batch = X_train_shuffled[i:i+batch_size]
          y_batch = y_train_shuffled[i:i+batch_size]

          # Forward pass
          y_hat = forward(X_batch, layers)

          # Loss with regularization term
          loss = mse_loss(y_batch.reshape(-1, 1), y_hat) + 0.5 * reg_strength * sum(np.sum(layer.weights**2) for layer in layers)

          # Backward
          backward(y_batch.reshape(-1, 1), y_hat, layers, lr)

      # Update learning rate
      lr = lr_0 / (1 + epoch)

      if epoch % 1000 == 0:
          print(f"Epoch {epoch} Loss: {np.mean(loss)}")

  # Testar o modelo no conjunto de teste
  y_test_hat = forward(X_test_normalized, layers)
  y_test_hat_binary = (y_test_hat > 0.5).astype(int).flatten()

  # Calcular e imprimir a acurácia
  accuracy = accuracy_score(y_test, y_test_hat_binary)
  print(f"Acurácia: {accuracy:.4f}")

  # Calcular e imprimir a matriz de confusão
  conf_matrix = confusion_matrix(y_test, y_test_hat_binary)
  print("Matriz de Confusão:")
  print(conf_matrix)
  

if __name__ == "__main__":
  main()
