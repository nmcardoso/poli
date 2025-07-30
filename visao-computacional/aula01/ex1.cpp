#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;

int main()
{
  Mat_<uchar> img = imread("data/mickey.bmp", 0);
  for (int l = 1; l < img.rows-1; l++) {
    for (int c = 1; c < img.cols-1; c++) {
      if (
        img(l, c) == 255 && 
        img(l-1, c) == 0 && img(l+1, c) == 0 &&
        img(l, c-1) == 0 && img(l, c+1) == 0
      ) {
        img(l, c) = 0;
      }
    }
  }
  namedWindow("result");
  imshow("result", img);
  waitKey();
}
