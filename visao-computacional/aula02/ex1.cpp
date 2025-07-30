#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;



void apply_median_filter(Mat src, Mat* dst, int kernel) {
  medianBlur(src, *dst, kernel);
  putText(*dst, format("Kernel = %d", kernel), Point(5, dst->rows - 5), FONT_HERSHEY_TRIPLEX, 0.7, 0, 1);
  copyMakeBorder(*dst, *dst, 1, 1, 1, 1, BORDER_CONSTANT, 0);
}



void plot_images(string path) {
  // Lendo imagem
  Mat_<uchar> imgIn = imread(path, 0);

  // Imagens filtradas
  Mat_<uchar> imgKernel1, imgKernel3, imgKernel5, imgKernel7, imgOut;
  apply_median_filter(imgIn, &imgKernel1, 1);
  apply_median_filter(imgIn, &imgKernel3, 3);
  apply_median_filter(imgIn, &imgKernel5, 5);
  apply_median_filter(imgIn, &imgKernel7, 7);

  // Concatendando saídas
  Mat outputs[] = {imgKernel1, imgKernel3, imgKernel5, imgKernel7};
  hconcat(outputs, 4, imgOut);
  
  // Exibindo imagem de entrada
  namedWindow("Entrada");
  imshow("Entrada", imgIn);

  // Exibindo imagem de saída
  namedWindow("Saida");
  imshow("Saida", imgOut);

  waitKey();
}



int main() {
  plot_images("textura/fever-1.pgm");
  plot_images("textura/fever-2.pgm");
}
