//media.cpp - 2024
#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;

Mat_<uchar> mediamov(Mat_<uchar> a) {
  Mat_<uchar> b(a.rows,a.cols);
  for (int l=0; l<b.rows; l++)
    for (int c=0; c<b.cols; c++) {
      int soma=0;
      for (int l2=-1; l2<=1; l2++)
        for (int c2=-1; c2<=1; c2++) {
          int l3=l+l2; int c3=c+c2;
          if (l3<0) l3=-l3;
          if (a.rows<=l3) l3=a.rows-(l3-a.rows+2);
          if (c3<0) c3=-c3;
          if (a.cols<=c3) c3=a.cols-(c3-a.cols+2);
          soma = soma+a(l3,c3);
        }
      b(l,c) = round(soma/9.0);
    }
  return b;
}

int main() {
  Mat_<uchar> a=imread("ruido.png",0);
  Mat_<uchar> b=mediamov(a);
  imwrite("media_ruido.png",b);
}
