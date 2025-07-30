#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;


Mat_<float> makePanel(Mat_<float> img, string title) {
  Mat_<float> legend = Mat::ones(25, img.cols, CV_32F);
  Mat_<float> out;
  putText(legend, title, Point(5, 15), FONT_HERSHEY_TRIPLEX, 0.5, 0, 1);
  vconcat(img, legend, out);
  copyMakeBorder(out, out, 1, 1, 1, 1, BORDER_CONSTANT, 0.7);
  return out;
}


Mat_<float> makeGrid(Mat_<float> ox, Mat_<float> oy, Mat_<float> l2, Mat ver, Mat verLeft, Mat verRight, Mat hor, Mat horUpper, Mat horLower) {
  Mat_<float> row1, row2, row3, out;
  Mat_<float> v1[] = {makePanel(ox/256.0, "Ox"), makePanel(oy/256.0, "Oy"), makePanel(l2, "Modulo")};
  hconcat(v1, 3, row1);
  Mat_<float> v2[] = {makePanel(ver, "Vertical"), makePanel(verLeft, "Esqueda"), makePanel(verRight, "Direita")};
  hconcat(v2, 3, row2);
  Mat_<float> v3[] = {makePanel(hor, "Horizontal"), makePanel(horUpper, "Superior"), makePanel(horLower, "Inferior")};
  hconcat(v3, 3, row3);
  Mat_<float> v4[] = {row1, row2, row3};
  vconcat(v4, 3, out);
  return out;
}


Mat_<float> computeL2(Mat_<float> sx, Mat_<float> sy) {
  Mat_<float> sx2, sy2, sxsy2, l2;
  pow(sx, 2, sx2); 
  pow(sy, 2, sy2);
  sxsy2 = sx2 + sy2;
  pow(sxsy2, 0.5, l2);
  return l2;
}


void makePlots(string path) {
  // Carrega imagem
  Mat_<float> a = imread(path, 0);
  Mat_<float> sx, sy, ox, oy, l2, vert, left, right, hor, upper, lower;
  
  // Calcula componentes dos gradiente
  Sobel(a, sx, -1, 1, 0, 3); 
  ox = sx/4.0 + 128;
  Sobel(a, sy, -1, 0, 1, 3); 
  oy = sy/4.0 + 128;
  
  // Calcula módulo (norma L2) do gradiente
  l2 = computeL2(sx/4.0, sy/4.0);

  // Componente vertical
  vert = abs(sx/4.0);
  left = max(sx/4.0, 0);
  right = max(-sx/4.0, 0);

  // Componente horizontal
  hor = abs(sy/4.0);
  upper = max(sy/4.0, 0);
  lower = max(-sy/4.0, 0);

  Mat_<float> out = makeGrid(ox, oy, l2, vert, left, right, hor, upper, lower);

  namedWindow("Entrada");
  imshow("Entrada", a/256.0);

  namedWindow("Saida");
  imshow("Saida", out);
  waitKey();
}


int main() {
  makePlots("gradiente/circulo.png");
  makePlots("gradiente/circulo2.png");
  makePlots("gradiente/circulo3.png");
}
