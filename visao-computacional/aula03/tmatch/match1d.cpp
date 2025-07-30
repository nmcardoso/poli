//match1d.cpp 2024
#include "procimagem.h"

int main()
{ Mat_<float> a = ( Mat_<float>(1,13) <<
                     0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0); cout << a << endl;
  Mat_<float> q = ( Mat_<float>(1,3) << 0, 1, 1 ); cout << q << endl;
  Mat_<float> p=filtro2d(a,q,BORDER_REPLICATE); cout << p << endl;

  Mat_<float> q2=dcReject(q); cout << q2 << endl;
  Mat_<float> p2=filtro2d(a,q2,BORDER_REPLICATE); cout << p2 << endl;

  Mat_<float> a3=a+10; cout << a3 << endl;
  Mat_<float> p3=filtro2d(a3,q2,BORDER_REPLICATE); cout << p3 << endl;

  Mat_<float> q4=somaAbsDois(dcReject(q)); cout << q4 << endl;
  Mat_<float> p4=filtro2d(a,q4,BORDER_REPLICATE); cout << p4 << endl;
}
