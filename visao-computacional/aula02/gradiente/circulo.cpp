//circulo.cpp
#include <cekeikon.h>
int main() {
  int nl=200, nc=200, ming=40, maxg=70, minp=2, maxp=7;
  for (int i=0; i<10; i++) {
    Mat_<GRY> a(nl,nc,255);
    circulo(a, maxg+rand()%(nl-2*maxg), maxg+rand()%(nc-2*maxg), ming+rand()%(maxg-ming), 80, -1);
    for (int j=0; j<20; j++) {
      circulo(a, maxp+rand()%(nl-2*maxp), maxp+rand()%(nc-2*maxp), minp+rand()%(maxp-minp), 80, -1);
    }
    mostra(a);
    imp(a,format("circ%02d.png",i));
  }
}
