#include "tmatch/procimagem.h"
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



Mat_<float> rotate(Mat_<float> src, float angle, Scalar placeholder) {
  // calcula centro da imagem
  Point2f center;
  center = Point2f(src.cols-1, src.rows-1) / 2;

  // calcula bounding box da imagem rotacionada
  Rect2f bbox = RotatedRect(center, src.size(), angle).boundingRect2f();
  
  // calcula matriz de rotação e ajusta bounding box
  Mat_<double> rot = getRotationMatrix2D(center, angle, 1.0);
  rot.at<double>(0,2) += bbox.width/2.0 - src.cols/2.0;
  rot.at<double>(1,2) += bbox.height/2.0 - src.rows/2.0;

  // aplica transformação afim na matriz de rotação ajustada
  Mat_<float> dst;
  warpAffine(src, dst, rot, bbox.size(), INTER_LINEAR, BORDER_CONSTANT, placeholder);
  return dst;
}



void drawBox(Mat_<Vec3f> img, Point2f center, Size2f size, float angle, string label) {
  Scalar RED_COLOR = Scalar(0.1569, 0.1529, 0.8392);
  Scalar BLUE_COLOR = Scalar(0.7059, 0.4667, 0.1216);
  Scalar GREEN_COLOR = Scalar(0.0725, 0.8275, 0.0725);

  // calcula rotação do retângulo
  RotatedRect rRect = RotatedRect(center, size, -angle);
  
  // desenha vertices do quadrado
  Point2f vertices[4];
  rRect.points(vertices);
  for (int i = 0; i < 4; i++)
    line(img, vertices[i], vertices[(i+1)%4], BLUE_COLOR, 2);

  // desenha angulo
  Point2f m = (vertices[1] + vertices[2]) / 2;
  line(img, center, m, BLUE_COLOR, 2);

  // desenha ponto central
  circle(img, center, 2, GREEN_COLOR, 2);

  // desenha texto
  Point2f offset;
  if (angle > 130 && angle < 230) offset = Point2f(-6, -8);
  else offset = Point2f(-6, 18);
  putText(img, label, center + offset, FONT_HERSHEY_SIMPLEX, 0.6, RED_COLOR, 2);
}





Mat_<float> matchTemplateMask(Mat_<float> a, Mat_<float> q, int method, Mat_<uchar> mask) {
  Mat_<float> p{ a.size(), 0.0 };
  Rect rect{ (q.cols-1)/2, (q.rows-1)/2, a.cols-q.cols+1, a.rows-q.rows+1};
  Mat_<float> roi{ p, rect };
  matchTemplate(a, q, roi, method, mask);
  return p;
}




void rotateAndQuery(
  Mat_<float> img, 
  Mat_<float> query, 
  Mat_<Vec3f> result,
  string label, 
  float deltaAngle = 2,
  float threshold = 0.9
) {
  float bestAngle, bestValue = threshold;
  Point bestLoc;

  double minPixel, maxPixel;
  Point minLoc, maxLoc;
  
  float inf = numeric_limits<float>::infinity();

  for (float angle = 0; angle < 360; angle += deltaAngle) {
    // rotaciona a imagem de busca
    Mat_<float> rotatedQuery = rotate(query, angle, Scalar(180));

    // calcula a máscara para os píxels incluídos com a rotação
    Mat_<uchar> mask = Mat(query.cols, query.rows, CV_8UC1, Scalar(255));
    mask = rotate(mask, angle, Scalar(0));

    // calcula convolução com o filtro e corrige divisão por zero
    Mat_<float> match = matchTemplateMask(img, rotatedQuery, TM_CCOEFF_NORMED, mask);
    match.setTo(0, match == inf);

    // procura pelo pixel com a maior correlação
    minMaxLoc(match, &minPixel, &maxPixel, &minLoc, &maxLoc);
    if (maxPixel > bestValue) {
      bestValue = maxPixel;
      bestLoc = maxLoc;
      bestAngle = angle;
    }
  }

  // armazena melhor correlação encontrada e desenha caixa
  if (bestValue > threshold) {
    drawBox(result, bestLoc, query.size(), bestAngle, label);
    cout << "Query: " << label << "\t Best Score: " << bestValue << " at " 
          << bestLoc << "\t Best Angle: " << bestAngle << endl;
  } else {
    cout << "Query: " << label << "\t No match" << endl;
  }
}





Mat_<Vec3f> queryAll(
  string img, 
  vector<string> query,
  float deltaAngle = 2,
  float threshold = 0.9
) {
  // carrega imagem de busca e imagem de saída
  Mat_<float> anchor = imread(img, 0);
  anchor = anchor / 255.0;
  Mat_<Vec3f> result;
  cvtColor(anchor, result, COLOR_GRAY2BGR);

  // itera sobre todas as imagens de consulta
  cout << "Image: " << img << endl;
  for (int i = 0; i < query.size(); i++) {
    Mat_<float> queryImg = imread(query.at(i), 0);
    rotateAndQuery(anchor, queryImg, result, to_string(i+1), deltaAngle, threshold);
  }
  cout << endl;

  return result;
}




int main() {
  vector<string> queries = {
    "tmatch_extra/q01.jpg", "tmatch_extra/q02.jpg", "tmatch_extra/q03.jpg", 
    "tmatch_extra/q04.jpg", "tmatch_extra/q05.jpg", "tmatch_extra/q06.jpg",
    "tmatch_extra/q07.jpg", "tmatch_extra/q08.jpg", "tmatch_extra/q09.jpg", 
    "tmatch_extra/q10.jpg", "tmatch_extra/q11.jpg", "tmatch_extra/q12.jpg"
  };

  float deltaAngle = 10, threshold = 0.45;
  Mat_<Vec3f> a1 = queryAll("tmatch_extra/a1.jpg", queries, deltaAngle, threshold);
  Mat_<Vec3f> a2 = queryAll("tmatch_extra/a2.jpg", queries, deltaAngle, threshold);
  Mat_<Vec3f> a3 = queryAll("tmatch_extra/a3.jpg", queries, deltaAngle, threshold);
  Mat_<Vec3f> a4 = queryAll("tmatch_extra/a4.jpg", queries, deltaAngle, threshold);
  Mat_<Vec3f> a5 = queryAll("tmatch_extra/a5.jpg", queries, deltaAngle, threshold);
  Mat_<Vec3f> a6 = queryAll("tmatch_extra/a6.jpg", queries, deltaAngle, threshold);
  Mat_<Vec3f> a7 = queryAll("tmatch_extra/a7.jpg", queries, deltaAngle, threshold);
  Mat_<Vec3f> a8 = queryAll("tmatch_extra/a8.jpg", queries, deltaAngle, threshold);

  int width = 400, height = 490;
  show("A1", a1, width, height, 50, 30);
  show("A2", a2, width, height, 500, 30);
  show("A3", a3, width, height, 950, 30);
  show("A4", a4, width, height, 1400, 30);
  show("A5", a5, width, height, 50, 580);
  show("A6", a6, width, height, 500, 580);
  show("A7", a7, width, height, 950, 580);
  show("A8", a8, width, height, 1400, 580);
  waitKey();

  // imwrite("outputs/a1.png", a1*255);
  // imwrite("outputs/a2.png", a2*255);
  // imwrite("outputs/a3.png", a3*255);
  // imwrite("outputs/a4.png", a4*255);
  // imwrite("outputs/a5.png", a5*255);
  // imwrite("outputs/a6.png", a6*255);
  // imwrite("outputs/a7.png", a7*255);
  // imwrite("outputs/a8.png", a8*255);
}
