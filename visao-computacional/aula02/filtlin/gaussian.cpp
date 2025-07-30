//gaussian.cpp 2024
#include "procimagem.h"
int main() {
  Mat_<float> a=imread("casa.pgm",0);
  Mat_<float> b; 
  GaussianBlur(a,b,Size(0,0),5);
  b=b/255.0;
  imshow("janela",b);
  waitKey(0);
}