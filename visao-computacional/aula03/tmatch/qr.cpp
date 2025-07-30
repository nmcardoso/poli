//qr.cpp - 2024
#include "procimagem.h"

Mat_<Vec3f> marca(Mat_<float> a, Mat_<float> p, float limiar) {
  Mat_<Vec3f> d;
  cvtColor(a,d,COLOR_GRAY2BGR);
  for (int l=0; l<a.rows; l++)
    for (int c=0; c<a.cols; c++)
      if (p(l,c)>=limiar)
        rectangle(d,Point(c-25,l-25),Point(c+25,l+25),Scalar(0.0,0.0,1.0),3);
  return d;
}

int main() {
  Mat_<float> a=imread("op00.jpg",0); a = a / 255.0;
  Mat_<float> q=imread("padrao_reduz.png",0); q = q / 255.0;

  Mat_<float> q1=somaAbsDois(dcReject(q));
  Mat_<float> p1=filtro2d(a,q1);
  imwrite("qr-p1.png",255.0*p1);
  Mat_<Vec3f> m1=marca(a,p1,0.6);
  imwrite("qr-m1.png",255.0*m1);

  Mat_<float> p2=matchTemplateSame(a,q1,TM_CCORR);
  imwrite("qr-p2.png",255.0*p2);
  Mat_<Vec3f> m2=marca(a,p2,0.6);
  imwrite("qr-m2.png",255.0*m2);

  Mat_<float> p3=matchTemplateSame(a,q,TM_CCOEFF_NORMED);
  imwrite("qr-p3.png",255.0*p3);
  Mat_<Vec3f> m3=marca(a,p3,0.6);
  imwrite("qr-m3.png",255.0*m3);
}
