//gradiente2.cpp - 2024
#include "procimagem.h"

void grad(Mat_<float> ent, Mat_<float>& saix, Mat_<float>& saiy) {
  Scharr(ent,saix,-1,1,0); saix=saix/16.0;
  Scharr(ent,saiy,-1,0,1); saiy=saiy/16.0;
}

int main() {
  Mat_<float> ent=imread("fantom.pgm",0);
  Mat_<float> saix;
  Mat_<float> saiy;
  grad(ent,saix,saiy);

  Mat_<float> t;
  t=128+saix; imwrite("gradx.png",t);
  t=128+saiy; imwrite("grady.png",t);

  Mat_<float> tx; pow(saix,2,tx); 
  Mat_<float> ty; pow(saiy,2,ty); 
  Mat_<float> modgrad; pow(tx+ty,0.5,modgrad);
  imwrite("modgrad.png",modgrad);
}
