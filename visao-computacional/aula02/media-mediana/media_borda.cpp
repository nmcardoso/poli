//media_borda.cpp - 2024
#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;

Mat_<uchar> mediamov(Mat_<uchar> a) {
  Mat_<uchar> b(a.rows,a.cols,uchar(128));
  for (int l=1; l<b.rows-1; l++)
    for (int c=1; c<b.cols-1; c++) {
      int soma=0;
      for (int l2=-1; l2<=1; l2++)
        for (int c2=-1; c2<=1; c2++) {
          int l3=l+l2; int c3=c+c2;
          soma = soma+a(l3,c3);
        }
      b(l,c) = round(soma/9.0);
    }
  return b;
}

int main() {
  Mat_<uchar> a=imread("lion.png",0);
  Mat_<uchar> b=mediamov(a);
  imwrite("media_borda.png",b);
}
