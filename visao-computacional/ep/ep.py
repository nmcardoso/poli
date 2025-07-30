"""
Exercício Programa da Disciplina PSI5790
Natanael Magalhães Cardoso, 8914122
"""

from typing import List, Tuple
import numpy as np
from glob import glob, iglob
import matplotlib.pyplot as plt
import cv2
from dataclasses import dataclass
from pathlib import Path
import os
import argparse
from datetime import datetime
import pandas as pd
from sklearn.metrics import RocCurveDisplay
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
import tensorflow as tf

try:
  import wandb
  from wandb.integration.keras import WandbCallback
  WANDB_INSTALLED = True
except:
  WANDB_INSTALLED = False

OUTPUT_PATH = Path(__file__).parent / 'outputs'
OUTPUT_PATH.mkdir(parents=True, exist_ok=True)


def leImagens(
  wildcards: List[str],
  classes: List[int],
  nl: int,
  nc: int
) -> Tuple[np.ndarray, np.ndarray]:
  total = sum([len(glob(p)) for p in wildcards])
  images = np.empty(shape=(total, nc, nl), dtype='uint8')
  labels = np.empty(shape=(total,), dtype='uint8')
  i = 0
  for wc, cl in zip(wildcards, classes):
    for path in iglob(wc):
      images[i, ...] = cv2.resize(cv2.imread(path, cv2.IMREAD_GRAYSCALE), (nc, nl), interpolation=cv2.INTER_LINEAR)
      labels[i] = cl
      i += 1
  return images, labels



def download_dataset():
  curr_folder = str(Path(__file__).parent.absolute())
  if not (Path(curr_folder) / 'dataset/COVID-QU-Ex.zip').exists():
    tf.keras.utils.get_file(
      fname='COVID-QU-Ex.zip',
      origin='https://github.com/nmcardoso/poli/releases/download/v0.0.1/COVID-QU-Ex.zip',
      cache_subdir='dataset',
      extract=True,
      archive_format='zip',
      cache_dir=curr_folder,
      force_download=False
    )
  


def load_dataset(
  width: int = 224,
  height: int = 224,
  oversample: bool = False,
  undersample: bool = False,
  resample_ratio: float = 1.0,
  clahe: bool = False,
  clahe_clip: float = 4.0,
  clahe_grid: Tuple[int, int] = (8, 8),
  one_hot: bool = True,
) -> Tuple[np.ndarray]:
  download_dataset()
  
  print('\n>> Carregando Conjunto de Dados')
  path_pattern = 'dataset/Lung Segmentation Data/Lung Segmentation Data/{subset}/{cls}/images/*.png'
  classes = ['COVID-19', 'Non-COVID', 'Normal']
  classes_id = [1, 0, 0]

  wcs = [path_pattern.format(subset='Train', cls=c) for c in classes]
  ax, ay = leImagens(wcs, classes_id, height, width)
  wcs = [path_pattern.format(subset='Test', cls=c) for c in classes]
  qx, qy = leImagens(wcs, classes_id, height, width)
  wcs = [path_pattern.format(subset='Val', cls=c) for c in classes]
  vx, vy = leImagens(wcs, classes_id, height, width)

  if clahe:
    clahe_mat = cv2.createCLAHE(clipLimit=clahe_clip, tileGridSize=clahe_grid)
    # apply_clahe = np.vectorize(lambda x: clahe_mat.apply(x))
    for i in range(ax.shape[0]):
      ax[i, ...] = clahe_mat.apply(ax[i])
    for i in range(qx.shape[0]):
      qx[i, ...] = clahe_mat.apply(qx[i])
    for i in range(vx.shape[0]):
      vx[i, ...] = clahe_mat.apply(vx[i])

  if undersample or oversample:
    minority_idx = np.nonzero(ay == 1)[0]
    majority_idx = np.nonzero(ay == 0)[0]
    minority_count = len(minority_idx)
    majority_count = len(majority_idx)
    delta_count = int(resample_ratio * abs(majority_count - minority_count))
    rng = np.random.default_rng(seed=42)
    if oversample:
      repeat_idx = rng.choice(minority_idx, delta_count, delta_count > minority_count)
      ax = np.concatenate((ax, ax[repeat_idx]))
      ay = np.concatenate((ay, ay[repeat_idx]))
    if undersample:
      delete_idx = rng.choice(majority_idx, delta_count, False)
      ax = np.delete(ax, delete_idx, axis=0)
      ay = np.delete(ay, delete_idx, axis=0)
    print('Número de elementos por classe após a reamostragem:')
    print('Conjunto de Treinamento:')
    print('\tClasse 0:', np.count_nonzero(ay == 0), '\tClasse 1:', np.count_nonzero(ay == 1))
    print('Conjunto de Validação:')
    print('\tClasse 0:', np.count_nonzero(vy == 0), '\tClasse 1:', np.count_nonzero(vy == 1))
    print('Conjunto de Teste:')
    print('\tClasse 0:', np.count_nonzero(qy == 0), '\tClasse 1:', np.count_nonzero(qy == 1))
  
  if one_hot:
    ay = tf.keras.utils.to_categorical(ay, 2)
    qy = tf.keras.utils.to_categorical(qy, 2)
    vy = tf.keras.utils.to_categorical(vy, 2)
  
  print('\nConjunto de Treinamento:')
  print('\tX =', ax.shape, '\ty =', ay.shape)
  print('Conjunto de Validação:')
  print('\tX =', vx.shape, '\ty =', vy.shape)
  print('Conjunto de Teste:')
  print('\tX =', qx.shape, '\ty =', qy.shape)
  print()
  
  return (ax, ay), (vx, vy), (qx, qy)



# Para corrigir o problema do keras 3 em carregar modelos salvos com layers
# lambda, as layers foram criadas usando herança
class GrayScaleToRGBLayer(tf.keras.layers.Layer):
  def __init__(self, *args, **kwargs):
    super().__init__(*args, **kwargs)
    
  def call(self, inputs):
    return tf.image.grayscale_to_rgb(tf.expand_dims(inputs, -1))



def build_model(
  name: str,
  architecture: str = 'efb0',
  weights: str = None, 
  input_shape: Tuple = (224, 224), 
  data_aug: bool = True,
  output_units: int = 2,
  output_activation: str = 'sigmoid',
  hidden_units_1: int = 512,
  activation_1: str = 'relu',
  dropout_1: float = 0.4,
  hidden_units_2: int = None,
  activation_2: str = None,
  dropout_2: float = None,
) -> tf.keras.Model:
  cnn_map = {
    'dn121': {
      'arch': tf.keras.applications.DenseNet121,
      'preprocessing': tf.keras.applications.densenet.preprocess_input
    },
    'dn169': {
      'arch': tf.keras.applications.DenseNet169,
      'preprocessing': tf.keras.applications.densenet.preprocess_input
    },
    'dn201': {
      'arch': tf.keras.applications.DenseNet201,
      'preprocessing': tf.keras.applications.densenet.preprocess_input
    },
    'inception': {
      'arch': tf.keras.applications.InceptionResNetV2,
      'preprocessing': tf.keras.applications.inception_resnet_v2.preprocess_input
    },
    'efb0': {
      'arch': tf.keras.applications.EfficientNetV2B0,
      'preprocessing': tf.keras.applications.efficientnet_v2.preprocess_input
    },
    'rn50': {
      'arch': tf.keras.applications.ResNet50,
      'preprocessing': tf.keras.applications.resnet.preprocess_input
    }
  }
  
  # pré-precessamento
  inputs = tf.keras.Input(shape=input_shape, name='inputs')
  x = GrayScaleToRGBLayer()(inputs)
  x = cnn_map[architecture]['preprocessing'](x)
  
  # aumento de dados
  if data_aug:
    x = tf.keras.layers.RandomFlip('horizontal')(x)
    x = tf.keras.layers.RandomZoom(0.15)(x)
    x = tf.keras.layers.RandomContrast(0.1)(x)
    x = tf.keras.layers.RandomBrightness(0.1)(x)
  
  # extrator de características (CNN)
  x = cnn_map[architecture]['arch'](
    weights=weights,
    include_top=False,
    pooling='avg',
  )(x)
  
  # classificador (MLP)
  if hidden_units_1 is not None:
    x = tf.keras.layers.Dense(hidden_units_1, activation=activation_1, name='dense_1')(x)
    if dropout_1 is not None:
      x = tf.keras.layers.Dropout(dropout_1, name='dropout_1')(x)
  
  if hidden_units_2 is not None:
    x = tf.keras.layers.Dense(hidden_units_2, activation=activation_2, name='dense_2')(x)
    if dropout_2 is not None:
      x = tf.keras.layers.Dropout(dropout_2, name='dropout_2')(x)
  outputs = tf.keras.layers.Dense(output_units, activation=output_activation, name='outputs')(x)
  
  return tf.keras.Model(inputs=inputs, outputs=outputs, name=name)



def train_model(
  name: str,
  train: Tuple[np.ndarray, np.ndarray],
  val: Tuple[np.ndarray, np.ndarray],
  epochs: int,
  gpu_id: int,
  architecture: str = 'efb0',
  weights: str = None,
  optimizer: str = 'adam',
  lr: float = 1e-5,
  loss: str = 'cce',
  label_smoothing: float = 0.0,
  hidden_units_1: int = 512,
  activation_1: str = 'relu',
  dropout_1: float = 0.4,
  hidden_units_2: int = None,
  activation_2: str = None,
  dropout_2: float = None,
  output_activation: str = 'sigmoid',
  class_weights: bool = False,
  data_aug: bool = True,
) -> tf.keras.Model:
  print('\n>> Treinamento do Modelo')
  physical_devices = tf.config.list_physical_devices('GPU')
  tf.config.set_visible_devices(physical_devices[gpu_id], 'GPU')

  X_train, y_train = train
  units = 1 if len(X_train.shape) == 1 else 2
  model = build_model(
    name=name,
    architecture=architecture,
    weights=weights, 
    input_shape=X_train.shape[1:], 
    output_units=units,
    hidden_units_1=hidden_units_1,
    activation_1=activation_1,
    dropout_1=dropout_1,
    hidden_units_2=hidden_units_2,
    activation_2=activation_2,
    dropout_2=dropout_2,
    output_activation=output_activation,
    data_aug=data_aug,
  )
  
  acc = tf.keras.metrics.CategoricalAccuracy(name='ACC')
  roc_auc = tf.keras.metrics.AUC(name='ROCAUC', curve='ROC')
  pr_auc = tf.keras.metrics.AUC(name='PRAUC', curve='PR')
  f1 = tf.keras.metrics.F1Score(name='F1', average='weighted')
  optimizer_map = {
    'rmsprop': tf.keras.optimizers.RMSprop,
    'adam': tf.keras.optimizers.Adam,
    'adamw': tf.keras.optimizers.AdamW,
    'nadam': tf.keras.optimizers.Nadam,
  }
  loss_map = {
    'cce': tf.keras.losses.CategoricalCrossentropy,
    'focal': tf.keras.losses.CategoricalFocalCrossentropy,
  }
  model.compile(
    optimizer=optimizer_map[optimizer](learning_rate=lr), 
    loss=loss_map[loss](label_smoothing=label_smoothing), 
    metrics=[acc, roc_auc, pr_auc, f1]
  )
  
  model.summary()
  
  model_folder = OUTPUT_PATH / name
  model_folder.mkdir(parents=True, exist_ok=True)
  
  callbacks = [
    tf.keras.callbacks.ModelCheckpoint(
      model_folder / f'{name}.keras',
      monitor='val_loss',
      verbose=0,
      save_best_only=True,
      save_weights_only=False,
      mode='min',
      save_freq='epoch',
      initial_value_threshold=None
    ),
  ]
  
  cw = None
  if class_weights:
    cw = compute_class_weight(y_train)
    print(f'\nTreinando com ponderamento de classes: {cw}')
  
  history = model.fit(
    X_train, 
    y_train, 
    validation_data=val, 
    epochs=epochs, 
    batch_size=64, 
    shuffle=True,
    callbacks=callbacks + Telemetry.get_callbacks(),
    class_weight=cw,
  )
  
  pd.DataFrame(history.history).to_csv(OUTPUT_PATH / name / 'history.csv', index=False)
  return model
  

def evaluate_model(
  model: tf.keras.Model, 
  val: Tuple[np.ndarray, np.ndarray],
  test: Tuple[np.ndarray, np.ndarray],
):
  val_preds = model.predict(val[0])
  pd.DataFrame(
    data=val_preds, 
    columns=['prob_non_covid', 'prob_covid']
  ).to_csv(OUTPUT_PATH / model.name / 'validation.csv', index=False)
  
  test_preds = model.predict(test[0])
  pd.DataFrame(
    data=test_preds, 
    columns=['prob_non_covid', 'prob_covid']
  ).to_csv(OUTPUT_PATH / model.name / 'test.csv', index=False)



def compute_class_weight(y=None):
  classes, cardinalities = np.unique(y.argmax(-1), return_counts=True)
  total = np.sum(cardinalities)
  n = len(cardinalities)
  weight_map = {}

  for class_, cardinality in zip(classes, cardinalities):
    weight_map[class_] = total / (n * cardinality)

  return weight_map



def plot_roc_curve_from_preds(
  y_pred: np.ndarray, 
  y_true: np.ndarray, 
  save_path: Path
):
  RocCurveDisplay.from_predictions(
    y_true=y_true, 
    y_pred=y_pred, 
    pos_label='COVID', 
    name=''
  )



def main():
  prog = argparse.ArgumentParser(
    'python ep.py', 
    description='Exercício Programa - PSI5790', 
    epilog='Natanael Magalhães Cardoso'
  )
  prog.add_argument(
    '-g', '--gpu', action='store', default=0, type=int, 
    help='ID da GPU'
  )
  prog.add_argument(
    '-e', '--epochs', action='store', default=1, type=int, 
    help='Quantidade de épocas'
  )
  prog.add_argument(
    '-a', '--arch', action='store', default='efb0',
    help='Arquitetura de rede neural convolucional'
  )
  prog.add_argument(
    '--h1', action='store', default=None, type=int, 
    help=(
      'Unidades da camada oculta 1. Se não especificado, o modelo é '
      'compilado sem a primeira camada oculta'
    )
  )
  prog.add_argument(
    '--a1', action='store', default='relu', 
    help='Função de ativação da camada oculta 1.'
  )
  prog.add_argument(
    '--d1', action='store', default=None, type=float, 
    help=(
      'Taxa de dropout 1. Se não especificado, o modelo é compilado sem '
      'a primeira camada dropout'
    )
  )
  prog.add_argument(
    '--h2', action='store', default=None, type=int, 
    help=(
      'Unidades da camada oculta 2. Se não especificado, o modelo é compilado '
      'sem a segunda camada oculta'
    )
  )
  prog.add_argument(
    '--a2', action='store', default='relu', 
    help='Função de ativação da camada oculta 2.'
  )
  prog.add_argument(
    '--d2', action='store', default=None, type=float, 
    help=(
      'Taxa de dropout 2. Se não especificado, o modelo é compilado sem a '
      'segunda camada dropout'
    )
  )
  prog.add_argument(
    '--aout', action='store', default='sigmoid',
    help='Função de ativação da camada de saída'
  )
  prog.add_argument(
    '--opt', action='store', default='adam',
    help='Algoritmo otimizador'
  )
  prog.add_argument(
    '--lr', action='store', default=1e-5,  type=float,
    help='Taxa de aprendizagem'
  )
  prog.add_argument(
    '--loss', action='store', default='cce',
    help='Função de custo'
  )
  prog.add_argument(
    '--smoothing', action='store', default=0.0, type=float,
    help='Aplica "label smoothing"'
  )
  prog.add_argument(
    '-i', '--imagenet', action='store_true', 
    help='Inicializa o modelo com os pesos da imagenet'
  )
  prog.add_argument(
    '--width', action='store', default=224, type=int, 
    help='Largura da imagem'
  )
  prog.add_argument(
    '--height', action='store', default=224, type=int, 
    help='Altura da imagem'
  )
  prog.add_argument(
    '-s', '--size', action='store', default=None, type=int, 
    help='Tamanho da imagem (largura e altura)'
  )
  prog.add_argument(
    '-c', '--clahe', action='store_true', 
    help='Usa pré-processamento CLAHE'
  )
  prog.add_argument(
    '--claheclip', action='store', default=4, type=int, 
    help='Parâmetro CLIP do CLAHE'
  )
  prog.add_argument(
    '--clahegrid', action='store', default=8, type=int, 
    help='Parâmetro GRID do CLAHE'
  )
  prog.add_argument(
    '-u', '--undersample', action='store_true', 
    help='Faz subamostragem da classe majoritária'
  )
  prog.add_argument(
    '-o', '--oversample', action='store_true', 
    help='Faz sobreamostragem da classe minoritária'
  )
  prog.add_argument(
    '--ratio', action='store', default=1.0, type=float, 
    help=(
      'Proporção final entre as classes após a reamostragem. 1 significa '
      'mesmo número de exemplos para ambas as classes'
    )
  )
  prog.add_argument(
    '--classweights', action='store_true',
    help='Adiciona ponderamento das classes'
  )
  prog.add_argument(
    '--dataaug', action='store_true',
    help='Adiciona camadas de aumento de dados no modelo'
  )
  prog.add_argument(
    '--notes', action='store', default='', 
    help='Adiciona nota ao W&B'
  )
  prog.add_argument(
    '--notelemetry', action='store_true',
    help='Desabilita a telemetria'
  )
  args = prog.parse_args()
  
  if args.size:
    width = args.size
    height = args.size
    
  train, val, test = load_dataset(
    width=width,
    height=height,
    oversample=args.oversample, 
    undersample=args.undersample,
    clahe=args.clahe,
    clahe_clip=args.claheclip,
    clahe_grid=(args.clahegrid, args.clahegrid),
  )
  
  t = datetime.now()
  name = f'{args.arch}_{t.day}-{str(t.month).zfill(2)}_{t.hour}h{t.minute}m{t.second}s'
  hps = vars(args)
  hps['name'] = name
  
  tag = 'pretrained' if args.imagenet else 'random_init'
      
  with Telemetry(
    name=name, 
    job_type='train', 
    config=hps, 
    tags=[tag], 
    notes=args.notes, 
    enabled=not args.notelemetry
  ):
    train_model(
      name=name,
      train=train, 
      val=val, 
      epochs=args.epochs, 
      gpu_id=args.gpu,
      architecture=args.arch,
      weights='imagenet' if args.imagenet else None,
      optimizer=args.opt,
      lr=args.lr,
      loss=args.loss,
      label_smoothing=args.smoothing,
      hidden_units_1=args.h1,
      activation_1=args.a1,
      dropout_1=args.d1,
      hidden_units_2=args.h2,
      activation_2=args.a2,
      dropout_2=args.d2,
      class_weights=args.classweights,
      output_activation=args.aout,
      data_aug=args.dataaug,
    )
  
  with Telemetry(
    name=name, 
    job_type='eval', 
    config=hps, 
    tags=[tag], 
    notes=args.notes, 
    enabled=not args.notelemetry
  ):
    model = tf.keras.models.load_model(
      OUTPUT_PATH / name / f'{name}.keras', 
      safe_mode=False,
      custom_objects={'GrayScaleToRGBLayer': GrayScaleToRGBLayer},
    )
    evaluate_model(model, val=val, test=test)



class Telemetry:
  _enabled = True
  
  def __init__(
    self,
    name: str,
    job_type: str,
    config: dict,
    tags: list = [],
    notes: str = '',
    enabled: bool = True
  ):
    self.name = name
    self.job_type = job_type
    self.config = config
    self.tags = tags
    self.notes = notes
    self.enabled = enabled
    Telemetry._enabled = enabled
    
  def __enter__(self):
    if WANDB_INSTALLED and self.enabled:
      wandb.init(
        id=None,
        project='PSI5790',
        job_type=self.job_type,
        config=self.config,
        name=self.name,
        entity='mergernet',
        reinit=False,
        tags=self.tags,
        notes=self.notes,
        magic=False,
        mode='online',
        resume=None,
        force=False,
        save_code=True,
      )
  
  def __exit__(self, *args, **kwargs):
    if WANDB_INSTALLED and self.enabled:
      wandb.finish()
      
  @classmethod
  def get_callbacks(
    cls,
    log_weights: bool = True,
    log_evaluation: bool = True
  ):
    if WANDB_INSTALLED and cls._enabled:
      return [
        WandbCallback(
          monitor='val_loss', 
          verbose=0, 
          mode='min', 
          save_weights_only=False,
          log_weights=log_weights, 
          log_gradients=False, 
          save_model=False,
          labels=['Non-Covid', 'Covid'], 
          predictions=36,
          input_type='image', 
          output_type='label', 
          log_evaluation=log_evaluation,
          log_batch_frequency=None,
          save_graph=False,
          log_evaluation_frequency=0,
          compute_flops=True,
        )
      ]
    return []



if __name__ == '__main__':
  main()



# Exemplos de chamada:
# python ep.py --gpu 0 --size 224 --opt adam --loss cce --epochs 50 --arch efb0 --imagenet --dataaug --lr 4e-5 (treinar o melhor modelo com Imagenet)
# python ep.py --gpu 0 --size 224 --opt adam --loss cce --epochs 50 --arch efb0 --dataaug --lr 4e-5 (treinar o melhor modelo sem Imagenet)