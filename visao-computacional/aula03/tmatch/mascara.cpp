//mascara.cpp 2024
#include "procimagem.h"
int main() {
  Mat_<uchar> a=imread("letramore3.pgm",0);
  for (int l=0; l<a.rows; l++)
    for (int c=0; c<a.cols; c++)
      if (a(l,c)==128) a(l,c)=0;
      else a(l,c)=255;
  imwrite("mascara.png",a);
}
