import time

import cv2
import numpy as np
from keras.datasets import mnist


def center_crop_image(img: np.ndarray, crop_size: int):
  width, height = img.shape[1], img.shape[0]
  mid_x, mid_y = int(width/2), int(height/2)
  c = int(crop_size/2)
  crop_img = img[mid_y-c:mid_y+c, mid_x-c:mid_x+c]
  return cv2.resize(crop_img, (width, height), interpolation=cv2.INTER_LINEAR)


def random_crop_dataset(dataset: np.ndarray, rate: float, seed: int = 42):
  ds_examples = dataset.shape[0]
  new_ds = np.empty(dataset.shape)
  rng = np.random.default_rng(seed)
  for i in range(ds_examples):
    crop_size = rng.integers(int(rate*dataset.shape[1]), dataset.shape[1])
    new_ds[i, :, :] = center_crop_image(dataset[i], crop_size)
  return new_ds


def random_rotate_dataset(dataset: np.ndarray, min_angle: float, max_angle: float, seed: int = 42):
  ds_examples = dataset.shape[0]
  new_ds = np.empty(dataset.shape)
  rng = np.random.default_rng(seed)
  width, height = dataset.shape[2], dataset.shape[1]
  center_x, center_y = int(width/2), int(height/2)
  for i in range(ds_examples):
    angle = rng.uniform(min_angle, max_angle)
    M = cv2.getRotationMatrix2D((center_x, center_y), angle, 1.0)
    new_ds[i, :, :] = cv2.warpAffine(dataset[i], M, (width, height))
  return new_ds


def resize_dataset(dataset: np.ndarray, new_size: int):
  resized_tensor = np.empty((dataset.shape[0], new_size, new_size))
  for i in range(dataset.shape[0]):
    resized_tensor[i] = cv2.resize(dataset[i], (new_size, new_size), interpolation=cv2.INTER_LINEAR)
  return resized_tensor


def flatten_features(dataset: np.ndarray):
  return dataset.reshape(dataset.shape[0], dataset.shape[1] * dataset.shape[2])


def trim_dataset(dataset: np.ndarray):
  ds_examples = dataset.shape[0]
  new_ds = np.empty(dataset.shape)
  for i in range(ds_examples):
    coords = cv2.findNonZero(dataset[i])
    x, y, w, h = cv2.boundingRect(coords)
    new_ds[i, :, :] = cv2.resize(dataset[i, y:y+h, x:x+w], (dataset.shape[1], dataset.shape[1]), interpolation=cv2.INTER_LINEAR)
  return new_ds


def median_filter_dataset(dataset: np.ndarray, kernel: int = 3):
  ds_examples = dataset.shape[0]
  new_ds = np.empty(dataset.shape)
  for i in range(ds_examples):
    new_ds[i, :, :] = cv2.medianBlur(dataset[i].astype('float32'), kernel)
  return new_ds


def main():
  (AX, ay), (QX, qy) = mnist.load_data();
  ax = trim_dataset(AX)
  ax1 = trim_dataset(random_rotate_dataset(ax, 5, 15))
  ax3 = median_filter_dataset(trim_dataset(random_rotate_dataset(ax, -15, 5)), 3)
  ax = np.concatenate([ax, ax1, ax3], axis=0)
  ay = np.concatenate([ay]*3, axis=0)
  ax = resize_dataset(ax, 14)
  ax = flatten_features(ax).astype('float32') / 255
  
  qx = trim_dataset(QX)
  qx = resize_dataset(qx, 14)
  qx = flatten_features(qx).astype('float32') / 255

  t1 = time.time()
  model = cv2.flann_Index(ax, {'algorithm': 1, 'trees': 32})
  t2 = time.time()
  matches, _ = model.knnSearch(qx, 1)
  t3 = time.time()

  qp = ay[matches].flatten()
  erros = np.count_nonzero(qp!=qy)
  
  print("Erros: %5.2f%%" % (100.0*erros/qy.shape[0])) # Erros: 2.12%
  print("Tempo de treinamento: %f"%(t2-t1)) # Tempo de treinamento: 18.28s 
  print("Tempo de predicao: %f"%(t3-t2)) # Tempo de predicao: 0.8s
  
  
if __name__ == '__main__':
  main()
