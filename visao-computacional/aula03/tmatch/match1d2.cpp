//match1d2.cpp 2024
#include "procimagem.h"
int main() {
  Mat_<float> a = ( Mat_<float>(1,13) <<
                  0, 1, 5, 3, 1, -1, 3, 1, 1, -2, 6, 2, 0); cout << a << endl;
  Mat_<float> q = ( Mat_<float>(1,3) << 0, 1, 0.5 ); cout << q << endl;

  Mat_<float> q2=somaAbsDois(dcReject(q)); cout << q2 << endl;
  Mat_<float> p2=filtro2d(a,q2,BORDER_REPLICATE); cout << p2 << endl;
}
