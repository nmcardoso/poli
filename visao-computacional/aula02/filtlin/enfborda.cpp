//enfborda.cpp - 2024
#include "procimagem.h"
int main(int argc, char** argv) {
  if (argc!=3) erro("enfborda ent.pgm sai.pgm");
  Mat_<float> ent=imread(argv[1],0);
  Mat_<float> ker= (Mat_<float>(3,3) <<
                -1, -1, -1,
                -1, 18, -1,
                -1, -1, -1);
  ker = (1.0/10.0) * ker;
  Mat_<float> sai = filtro2d(ent,ker);
  imwrite(argv[2],sai);
}
