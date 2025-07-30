#include "procimagem.h"
#include <opencv2/opencv.hpp>
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;
using namespace cv;



int computeMode(Mat rowMatrix) {
  vector<float> values;

  // Copia os elementos da matriz para um vetor
  for (int i = 0; i < rowMatrix.cols; ++i) {
    values.push_back(rowMatrix.at<float>(0, i));
  }

  // Ordena o vetor
  sort(values.begin(), values.end());

  // Encontra a moda
  int mode = values[0]; // Assume que o primeiro elemento é a moda
  int maxCount = 1;     // Contador para o elemento atual
  int currentCount = 1; // Contador para o elemento em análise

  for (size_t i = 1; i < values.size(); ++i) {
    if (values[i] == values[i - 1]) {
      ++currentCount;
    } else {
      if (currentCount > maxCount) {
        maxCount = currentCount;
        mode = values[i - 1];
      }
      currentCount = 1;
    }
  }

  // Verifica o último elemento
  if (currentCount > maxCount) {
    mode = values[values.size() - 1];
  }

  return mode;
}



int main() {
  MNIST mnist(14, true, true);
  mnist.le("../mnist");
  double t1=tempo();
  Ptr<ml::KNearest> knn(ml::KNearest::create());
  knn->train(mnist.ax, ml::ROW_SAMPLE, mnist.ay);
  double t2=tempo();
  Mat_<float> saidas, dists;
  int k=3;
  for (int l=0; l<10000; l++) {
    knn->findNearest(mnist.qx.row(l), k, noArray(), saidas, dists);
    mnist.qp(l) = computeMode(saidas);
  }
  double t3=tempo();
  printf("Erros=%10.2f%%\n",100.0*mnist.contaErros()/mnist.nq); // Erros: 2.48%
  printf("Tempo de treino: %f\n",t2-t1); // Tempo de treinamento: 0.033s 
  printf("Tempo de predicao: %f\n",t3-t2); // Tempo de predição: 2m11.6s
}
