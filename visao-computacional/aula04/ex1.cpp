#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;

void show(string windowName, Mat img, int width=-1, int height=-1, int x=-1, int y=-1) {
  namedWindow(windowName, WINDOW_NORMAL);
  imshow(windowName, img);
  if (width > 0 && height > 0)
    resizeWindow(windowName, width, height);
  if (x >= 0 && y >= 0)
    moveWindow(windowName, x, y);
}



int main() {
  Mat_<float> src = (Mat_<float>(4,2) <<
    135,35,
    328,23,
    366,322,
    100,322);
  Mat_<float> dst = (Mat_<float>(4,2) <<
    100,19,
    366,19,
    366,322,
    100,322);
  Mat_<double> m = getPerspectiveTransform(src, dst);
  
  //Verifica se a transformacao esta fazendo o que queremos
  for (int i = 0; i < 4; i++) {
    Mat_<double> v = (Mat_<double>(3,1) << src(i,0), src(i, 1), 1);
    Mat_<double> w = m * v;
    cout << "Origem: (" << src(i, 0) << ", " << src(i, 1) 
        << ")\tDestino: (" << dst(i, 0) << ", " << dst(i, 1) 
        << ")\tCalculado: (" << w(0)/w(2) << ", " << w(1)/w(2) << ")" << endl;
  }
  
  //Corrige a perspectiva
  Mat_<float> a = imread("transformacao/calib_result.jpg", 0);
  Mat_<float> b;
  warpPerspective(a, b, m, a.size());
  show("Entrada", a/255, 500, 400, 100, 100);
  show("Saida", b/255, 500, 400, 700, 100);
  
  //Refaz a perspectiva
  m = m.inv();
  warpPerspective(b, a, m, a.size());
  show("Transformacao Inversa", a/255, 500, 400, 400, 600);
  waitKey();
}
