#include "procimagem.h"

Mat_<uchar> rotacao(Mat_<uchar> ent, double graus, Point2f centro, Size tamanho) {
  Mat_<double> m=getRotationMatrix2D(centro, graus, 1.0);
  Mat_<uchar> sai;
  warpAffine(ent, sai, m, tamanho, INTER_LINEAR, BORDER_CONSTANT, Scalar(255));
  return sai;
}

int main() {
  Mat_<uchar> ent=imread("a.png",0);
  Mat_<uchar> sai=rotacao(ent,30,Point2f(ent.size())/2,ent.size());
  imwrite("rotacao.png",sai);
}
