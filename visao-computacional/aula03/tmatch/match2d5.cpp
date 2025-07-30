//match2d5.cpp 2024
#include "procimagem.h"
int main() {
  Mat_<float> a=imread("bbox.pgm",0);
  Mat_<float> q=imread("letramore.pgm",0);
  Mat_<uchar> m=imread("mascara.png",0);
  q = somaAbsDois( dcReject(q, 128.0 ) );
  Mat_<float> p=filtro2d(a,q);
  imwrite("correlacao4.png",p);

  Mat_<Vec3f> d;
  cvtColor(a,d,COLOR_GRAY2BGR);
  for (int l=0; l<a.rows; l++)
    for (int c=0; c<a.cols; c++)
      if (p(l,c)>=254.0)
        rectangle(d,Point(c-109,l-38),Point(c+109,l+38),Scalar(0,0,255),6);
  imwrite("ocorrencia4.png",d);
}
