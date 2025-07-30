//gradiente.cpp - 2024
#include "procimagem.h"

void grad(Mat_<float> ent, Mat_<float>& saix, Mat_<float>& saiy)
{ Mat_<float> mx=(Mat_<float>(3,3)<<-3.0,  0.0, +3.0,
                                   -10.0, 0.0, +10.0,
                                    -3.0,  0.0, +3.0);
  mx=mx/16.0;
  Mat_<float> my=(Mat_<float>(3,3)<<-3.0, -10.0, -3.0,
                                     0.0,   0.0,  0.0,
                                    +3.0, +10.0, +3.0);
  my=my/16.0;
  saix=filtro2d(ent,mx);
  saiy=filtro2d(ent,my);
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
