#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;
int main()
{
  Mat_<uchar> img = imread("data/mickey.bmp", 0);
  namedWindow("janela");
  imshow("janela", img);
  waitKey();
}
