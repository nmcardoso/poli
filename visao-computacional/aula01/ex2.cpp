#include <opencv2/opencv.hpp>
#include <queue>
#include <string>
using namespace std;
using namespace cv;

class Pixel {
  public:
  int row, col, rows, cols;
  Pixel(int r, int c, int rs, int cs) {
    row = r;
    col = c;
    rows = rs;
    cols = cs;
  }
  bool isValid() {
    return row >= 0 && col >= 0 && col < cols && row < rows;
  }
};

void processBlob(int row, int col, Mat_<uchar> img) {
  queue<Pixel> q;
  q.push(Pixel(row, col, img.cols, img.rows));

  while(!q.empty()) {
    Pixel p = q.front();
    q.pop();
    
    if (img(p.row, p.col) == 0) {
      img(p.row, p.col) = 128;

      Pixel pl = Pixel(p.row-1, p.col, img.rows, img.cols);
      if (pl.isValid() && img(pl.row, pl.col) == 0) {
        q.push(pl);
      }

      Pixel pr = Pixel(p.row+1, p.col, img.rows, img.cols);
      if (pr.isValid() && img(pr.row, pr.col) == 0) {
        q.push(pr);
      }

      Pixel pu = Pixel(p.row, p.col-1, img.rows, img.cols);
      if (pu.isValid() && img(pu.row, pu.col) == 0) {
        q.push(pu);
      }

      Pixel pb = Pixel(p.row, p.col+1, img.rows, img.cols);
      if (pb.isValid() && img(pb.row, pb.col) == 0) {
        q.push(pb);
      }
    }
  }
}

int countBlobs(string imageName, bool plotSteps = false) {
  Mat_<uchar> img = imread("data/" + imageName, 0);
  int numBlobs = 0;
  for (int row = 0; row < img.rows; row++) {
    for (int col = 0; col < img.cols; col++) {
      if (img(row, col) == 0) {
        numBlobs++;
        processBlob(row, col, img);
        if (plotSteps) {
          string fname = "outputs/" + imageName + "_" + to_string(numBlobs) + ".jpg";
          imwrite(fname, img);
        }
      }
    }
  }
  return numBlobs;
}


int main() {
  bool plotSteps = true;
  cout << "Imagem: Letras - " << countBlobs("letras.bmp", plotSteps) << " blobs" << endl;
  cout << "Imagem: c2 - " << countBlobs("c2.bmp", plotSteps) << " blobs" << endl;
  cout << "Imagem: c3 - " << countBlobs("c3.bmp", plotSteps) << " blobs" << endl;
}
