//ruido.cpp - pos2016
#include <cekeikon.h>

Mat_<uchar> ruido(Mat_<uchar> a) {
  Mat_<uchar> b=a.clone();
  srand(7);
  for (unsigned l=0; l<a.rows; l++) {
    for (unsigned c=0; c<a.cols; c++) {
      if (rand()%20==0) {
        b(l,c)=rand()%256;
      }
    }
  }
  return b;
}

int main() {
  Mat_<uchar> a=imread("lion.png",0);
  Mat_<uchar> b=ruido(a);
  imwrite("ruido.png",b);
}
