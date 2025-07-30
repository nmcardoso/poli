//blur.cpp - 2024
//gfedcb|abcdefgh|gfedcba
#include <opencv2/opencv.hpp>
using namespace std; using namespace cv;
int main() {
  Mat_<uchar> a,b;
  a=imread("lion.png",0);
  blur(a,b,Size(3,3));
  imwrite("blur.png",b);
}
