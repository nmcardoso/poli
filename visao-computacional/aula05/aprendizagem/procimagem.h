//procimagem.h 2024
#include <opencv2/opencv.hpp>
#include <iostream>
#include <float.h>
using namespace std;
using namespace cv;

void erro(string s1="") {
  cerr << s1 << endl;
  exit(1);
}

Mat_<float> filtro2d(Mat_<float> ent, Mat_<float> ker, int borderType=BORDER_DEFAULT)
{ Mat_<float> sai;
  filter2D(ent,sai,-1,ker,Point(-1,-1),0.0,borderType);
  return sai;
}

Mat_<Vec3f> filtro2d(Mat_<Vec3f> ent, Mat_<float> ker, int borderType=BORDER_DEFAULT)
{ Mat_<Vec3f> sai;
  filter2D(ent,sai,-1,ker,Point(-1,-1),0.0,borderType);
  return sai;
}

Mat_<float> dcReject(Mat_<float> a) { // Elimina nivel DC (subtrai media)
  a=a-mean(a)[0];
  return a;
}

Mat_<float> dcReject(Mat_<float> a, float dontcare) {
  // Elimina nivel DC (subtrai media) com dontcare
  Mat_<uchar> naodontcare = (a!=dontcare); Scalar media=mean(a,naodontcare);
  subtract(a,media[0],a,naodontcare);
  Mat_<uchar> simdontcare = (a==dontcare); subtract(a,dontcare,a,simdontcare);
  return a;
}

Mat_<float> somaAbsDois(Mat_<float> a) { // Faz somatoria absoluta da imagem dar dois
  double soma = sum(abs(a))[0]; a /= (soma/2.0);
  return a;
}

Mat_<float> matchTemplateSame(Mat_<float> a, Mat_<float> q, int method,
  float backg=0.0) {
  Mat_<float> p{ a.size(), backg };
  Rect rect{ (q.cols-1)/2, (q.rows-1)/2, a.cols-q.cols+1, a.rows-q.rows+1};
  Mat_<float> roi{ p, rect };
  matchTemplate(a, q, roi, method);
  return p;
}

template<typename T> class ImgXyb: public Mat_<T> {
public:
  using Mat_<T>::Mat_; //inherit constructors

  T backg;
  int lc=0, cc=0;
  int minx=0, maxx=this->cols-1, miny=1-this->rows, maxy=0;

  void centro(int _lc, int _cc) { 
    lc=_lc; cc=_cc;
    minx=-cc; maxx=this->cols-cc-1;
    miny=-(this->rows-lc-1); maxy=lc;
  }

  T& operator()(int x, int y) { // modo XY centralizado
    unsigned li=lc-y; unsigned ci=cc+x;
    if (li<unsigned(this->rows) && ci<unsigned(this->cols))
      return (*this).Mat_<T>::operator()(li,ci);
    else return backg;
  }
};

