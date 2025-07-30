//gausskernel.cpp 2024
#include "procimagem.h"
int main() {
  int sigma=1;
  Mat_<double> k=getGaussianKernel(2*3*sigma+1,sigma);
  cout << k << endl;
}
