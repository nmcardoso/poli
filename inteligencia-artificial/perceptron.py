import numpy as np

X = np.array([
  [-1, -1],
  [-1, 1],
  [1, 1.5],
  [0, -0.5],
])

y = np.array([
  -1,
  -1,
  1,
  1,
])

def perceptron(X, y, epochs):
  wrong = np.zeros(shape=y.shape[0], dtype=int)
  theta = np.zeros(shape=X.shape[-1])
  bias = 0
  for epoch in range(epochs):
    print('-'*20)
    print(f'Época: {epoch + 1}')
    print('-'*20)
    
    n_updates = 0
    for example in range(y.shape[0]):
      agg = y[example] * (np.dot(theta, X[example]) + bias)
      print(f'Exemplo: {example}')
      print(f'X[{example}]:', X[example])
      print('Theta:', theta)
      print('Bias:', bias)
      print('Aggreement:', agg)
      if agg <= 0:
        n_updates += 1
        wrong[example] += 1
        theta += y[example] * X[example]
        bias += y[example]
        print(f'>>> Pesos atualizados.')
        print(f'>>> Novo Theta: {theta}')
        print(f'>>> Novo Bias: {bias}')
      print()
        
    if n_updates == 0:
      print()
      print(f'*** Nenhum peso atualizado na época {epoch + 1}')
      print(f'*** Finalizando treinamento')
      print(f'*** Valor final de Theta: {theta}')
      print(f'*** Valor final de Bias: {bias}')
      for i, w in enumerate(wrong):
        print(f'*** Classificações incorretas do Exemplo {i}: {w}')
      break

perceptron(X, y, 10)
