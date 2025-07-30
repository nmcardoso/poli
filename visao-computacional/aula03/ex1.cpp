#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;


Mat_<Vec3f> marca(Mat_<float> a, Mat_<float> p[], float limiar, int count=1) {
  Mat_<Vec3f> d;
  cvtColor(a,d,COLOR_GRAY2BGR);
  for (int i=0; i < count; i++)
    for (int l=0; l<a.rows; l++)
      for (int c=0; c<a.cols; c++)
        if (p[i](l,c)>=limiar)
          rectangle(d,Point(c-25,l-25),Point(c+25,l+25),Scalar(0.0,0.0,1.0),3);
  return d;
}



void show(string windowName, Mat img, int width, int height, int x=-1, int y=-1) {
  namedWindow(windowName, WINDOW_NORMAL);
  imshow(windowName, img);
  resizeWindow(windowName, width, height);
  if (x > 0 && y > 0)
    moveWindow(windowName, x, y);
}



Mat_<float> dcReject(Mat_<float> a) { // Elimina nivel DC (subtrai media)
  Mat_<float> b = a-mean(a)[0];
  return b;
}

Mat_<float> somaAbsDois(Mat_<float> a) { // Faz somatoria absoluta da imagem dar dois
  double soma = sum(abs(a))[0]; 
  Mat_<float> b = a / (soma/2.0);
  return b;
}

Mat_<float> matchTemplateSame(Mat_<float> a, Mat_<float> q, int method, float backg=0.0) {
  Mat_<float> p{ a.size(), backg };
  Rect rect{ (q.cols-1)/2, (q.rows-1)/2, a.cols-q.cols+1, a.rows-q.rows+1};
  Mat_<float> roi{ p, rect };
  matchTemplate(a, q, roi, method);
  return p;
}





int main() {
  // carrega imagem de busca
  Mat_<float> img = imread("tmatch/a.png", 0);

  // carrega imagem de consulta
  Mat_<float> query = imread("tmatch/q.png", 0);

  // normaliza imagens
  img = img / 255.0;
  query = query / 255.0;

  Mat_<float> q = somaAbsDois(dcReject(query));
  Mat_<float> qNeg = somaAbsDois(dcReject(1-query));
  Mat_<float> c1 = matchTemplateSame(img, q, TM_CCOEFF_NORMED);
  Mat_<float> c2 = matchTemplateSame(img, qNeg, TM_CCOEFF_NORMED);
  Mat_<float> corr[2] = {c1, c2};
  Mat_<Vec3f> result = marca(img, corr, 0.9, 2);

  // exibe imagens de saída
  show("Entrada: Imagem de Busca", img, 500, 400, 100, 100);
  show("Entrada: Query", query, 280, 200, 610, 100);
  show("Query Proc.", q*255, 280, 200, 610, 310);
  show("Query Negativa Proc.", qNeg*255, 280, 200, 610, 600);
  show("Saida", result, 500, 400, 100, 600);
  show("Correlacao", c1, 500, 400, 900, 100);
  show("Correlacao Negativa", c2, 500, 400, 900, 600);
  waitKey();
}

