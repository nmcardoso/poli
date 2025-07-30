//match2d.cpp 2024
#include "procimagem.h"
int main() {
  Mat_<float> a=imread("bbox.pgm",0); a=a/255.0;
  Mat_<float> q=imread("letramore.pgm",0); q=q/255.0;
  q=somaAbsDois(dcReject(q));
  Mat_<float> p=filtro2d(a,q);
  imwrite("correlacao.png",255*p);

  Mat_<Vec3f> d; cvtColor(a,d,COLOR_GRAY2BGR);
  for (int l=0; l<a.rows; l++)
    for (int c=0; c<a.cols; c++)
      if (p(l,c)>=0.999)
        rectangle(d,Point(c-109,l-38),Point(c+109,l+38),Scalar(0,0,1),3);
  imwrite("ocorrencia.png",255*d);
}
