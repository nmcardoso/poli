//procimagem.h 2024
#include <opencv2/opencv.hpp>
#include <iostream>
#include <float.h>
#include <chrono>
using namespace std;
using namespace cv;

void erro(string s1="") {
  cerr << s1 << endl;
  exit(1);
}

Mat_<float> filtro2d(Mat_<float> ent, Mat_<float> ker, int borderType=BORDER_DEFAULT)
{ Mat_<float> sai;
  filter2D(ent,sai,-1,ker,Point(-1,-1),0.0,borderType);
  return sai;
}

Mat_<Vec3f> filtro2d(Mat_<Vec3f> ent, Mat_<float> ker, int borderType=BORDER_DEFAULT)
{ Mat_<Vec3f> sai;
  filter2D(ent,sai,-1,ker,Point(-1,-1),0.0,borderType);
  return sai;
}

Mat_<float> dcReject(Mat_<float> a) { // Elimina nivel DC (subtrai media)
  a=a-mean(a)[0];
  return a;
}

Mat_<float> dcReject(Mat_<float> a, float dontcare) {
  // Elimina nivel DC (subtrai media) com dontcare
  Mat_<uchar> naodontcare = (a!=dontcare); Scalar media=mean(a,naodontcare);
  subtract(a,media[0],a,naodontcare);
  Mat_<uchar> simdontcare = (a==dontcare); subtract(a,dontcare,a,simdontcare);
  return a;
}

Mat_<float> somaAbsDois(Mat_<float> a) { // Faz somatoria absoluta da imagem dar dois
  double soma = sum(abs(a))[0]; a /= (soma/2.0);
  return a;
}

Mat_<float> matchTemplateSame(Mat_<float> a, Mat_<float> q, int method,
  float backg=0.0) {
  Mat_<float> p{ a.size(), backg };
  Rect rect{ (q.cols-1)/2, (q.rows-1)/2, a.cols-q.cols+1, a.rows-q.rows+1};
  Mat_<float> roi{ p, rect };
  matchTemplate(a, q, roi, method);
  return p;
}

template<typename T> class ImgXyb: public Mat_<T> {
public:
  using Mat_<T>::Mat_; //inherit constructors

  T backg;
  int lc=0, cc=0;
  int minx=0, maxx=this->cols-1, miny=1-this->rows, maxy=0;

  void centro(int _lc, int _cc) {
    lc=_lc; cc=_cc;
    minx=-cc; maxx=this->cols-cc-1;
    miny=-(this->rows-lc-1); maxy=lc;
  }

  T& operator()(int x, int y) { // modo XY centralizado
    unsigned li=lc-y; unsigned ci=cc+x;
    if (li<unsigned(this->rows) && ci<unsigned(this->cols))
      return (*this).Mat_<T>::operator()(li,ci);
    else return backg;
  }
};

//<<<<<<<<<<<<<<<<<< Funcoes da aula classificacao <<<<<<<<<<<<<<<<<<<<<<
// Acha o argumento (indice) do maior valor
template<class T>
int argMax(Mat_<T> a) {
  T maximo=a(0); int indmax=0;
  for (int i=1; i<a.total(); i++)
    if (a(i)>maximo) {
      maximo=a(i); indmax=i;
    }
  return indmax;
}

double tempo() {
  return chrono::duration_cast<chrono::duration<double>>
     (chrono::system_clock::now().time_since_epoch()).count();
}

#define xdebug { string st = "File="+string(__FILE__)+" line="+to_string(__LINE__)+"\n"; cout << st << endl; }

template<class T>
void copia(Mat_<T> ent, Mat_<T>& sai, int li, int ci) {
// Copia ent para dentro de sai a partir de sai(li,ci).
// sai deve vir alocado
// ent deve ser normalmente menor que sai
// Ha protecao para o caso de ent nao caber dentro de sai
  int lisai=max(0,li);
  int cisai=max(0,ci);
  int lfsai=min(sai.rows-1,li+ent.rows-1);
  int cfsai=min(sai.cols-1,ci+ent.cols-1);
  Rect rectsai=Rect(cisai,lisai,cfsai-cisai+1,lfsai-lisai+1);

  int lient=max(0,-li);
  int cient=max(0,-ci);
  int lfent=min(ent.rows-1, sai.rows-1-li);
  int cfent=min(ent.cols-1, sai.cols-1-ci);
  Rect rectent=Rect(cient,lient,cfent-cient+1,lfent-lient+1);

  if (rectsai.width>0 && rectsai.height>0 && rectent.width>0 && rectent.height>0) {
    Mat_<T> sairoi=sai(rectsai);
    Mat_<T> entroi=ent(rectent);
    entroi.copyTo(sairoi);
  }
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<< MNIST <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
class MNIST {
 public:
  bool localizou;
  int nlado; bool inverte; bool ajustaBbox; string metodo;
  int na; vector< Mat_<uchar> > AX; vector<int> AY; Mat_<float> ax; Mat_<float> ay;
  int nq; vector< Mat_<uchar> > QX; vector<int> QY; Mat_<float> qx; Mat_<float> qy;
  Mat_<float> qp;

  MNIST(int _nlado=28, bool _inverte=true, bool _ajustaBbox=true, string _metodo="flann") {
    nlado=_nlado; inverte=_inverte;
    ajustaBbox=_ajustaBbox; metodo=_metodo;
  }
  Mat_<uchar> bbox(Mat_<uchar> a); // Ajusta para bbox. Se nao consegue, faz localizou=false
  Mat_<float> bbox(Mat_<float> a); // Ajusta para bbox. Se nao consegue, faz localizou=false
  void leX(string nomeArq, int n, vector< Mat_<uchar> >& X, Mat_<float>& x); // funcao interna
  void leY(string nomeArq, int n, vector<int>& Y, Mat_<float>& y); // f. interna
  void le(string caminho="", int _na=60000, int _nq=10000);
  // Le banco de dados MNIST que fica no path caminho
  // ex: mnist.le("."); mnist.le("c:/diretorio");
  // Se _na ou _nq for zero, nao le o respectivo
  // ex: mnist.le(".",60000,0);
  int contaErros();
  Mat_<uchar> geraSaida(Mat_<uchar> q, int qy, int qp); // f. interna
  Mat_<uchar> geraSaidaErros(int maxErr=0);
  // Conta erros e gera imagem com maxErr primeiros erros
  Mat_<uchar> geraSaidaErros(int nl, int nc);
  // Gera uma imagem com os primeiros nl*nc digitos classificados erradamente
};

Mat_<uchar> MNIST::bbox(Mat_<uchar> a) {
  // Ajusta para bbox. Se nao consegue, faz localizou=false
  int esq=a.cols, dir=0, cima=a.rows, baixo=0; // primeiro pixel diferente de 255.
  for (int l=0; l<a.rows; l++)
    for (int c=0; c<a.cols; c++) {
      if (a(l,c)!=255) {
        if (c<esq) esq=c;   if (dir<c) dir=c;
        if (l<cima) cima=l; if (baixo<l) baixo=l;
      }
    }
  Mat_<uchar> d;
  if (!(esq<dir && cima<baixo)) { // erro na localizacao
    localizou=false; d.create(nlado,nlado); d.setTo(128);
  } else {
    localizou=true; Mat_<uchar> roi(a, Rect(esq,cima,dir-esq+1,baixo-cima+1));
    resize(roi,d,Size(nlado,nlado),0, 0, INTER_AREA);
  }
  return d;
}

Mat_<float> MNIST::bbox(Mat_<float> a) {
  // Ajusta para bbox. Se nao consegue, faz localizou=false
  int esq=a.cols, dir=0, cima=a.rows, baixo=0; // primeiro pixel menor que 0.5.
  for (int l=0; l<a.rows; l++)
    for (int c=0; c<a.cols; c++) {
      if (a(l,c)<=0.5) {
        if (c<esq) esq=c;   if (dir<c) dir=c;
        if (l<cima) cima=l; if (baixo<l) baixo=l;
      }
    }
  Mat_<float> d;
  if (!(esq<dir && cima<baixo)) { // erro na localizacao
    localizou=false; d.create(nlado,nlado); d.setTo(0.5);
  } else {
    localizou=true; Mat_<float> roi(a, Rect(esq,cima,dir-esq+1,baixo-cima+1));
    resize(roi,d,Size(nlado,nlado),0, 0, INTER_AREA);
  }
  return d;
}

void MNIST::leX(string nomeArq, int n, vector< Mat_<uchar> >& X, Mat_<float>& x) {
  X.resize(n);
  for (unsigned i=0; i<X.size(); i++) X[i].create(nlado,nlado);

  FILE* arq=fopen(nomeArq.c_str(),"rb");
  if (arq==NULL) erro("Erro: Arquivo inexistente "+nomeArq);
  uchar b;
  Mat_<uchar> t(28,28), d;
  fseek(arq,16,SEEK_SET);
  for (unsigned i=0; i<X.size(); i++) {
    if (fread(t.data,28*28,1,arq)!=1) erro("Erro leitura "+nomeArq);
    if (inverte) t=255-t;
    if (ajustaBbox) {  d=bbox(t); }
    else {
      if (nlado!=28) resize(t,d,Size(nlado,nlado),0, 0, INTER_AREA);
      else t.copyTo(d);
    }
    X[i]=d.clone();
  }
  fclose(arq);

  x.create(X.size(),X[0].total());
  for (int i=0; i<x.rows; i++)
    for (int j=0; j<x.cols; j++)
      x(i,j)=X[i](j)/255.0;
}

void MNIST::leY(string nomeArq, int n, vector<int>& Y, Mat_<float>& y) {
  Y.resize(n); y.create(n,1);
  FILE* arq=fopen(nomeArq.c_str(),"rb");
  if (arq==NULL) erro("Erro: Arquivo inexistente "+nomeArq);
  uchar b; fseek(arq,8,SEEK_SET);
  for (unsigned i=0; i<y.total(); i++) {
    if (fread(&b,1,1,arq)!=1) erro("Erro leitura "+nomeArq);
    Y[i]=b; y(i)=b;
  }
  fclose(arq);
}

void MNIST::le(string caminho, int _na, int _nq) {
  na=_na; nq=_nq;
  if (na>60000) erro("Erro: na>60000");
  if (nq>10000) erro("Erro: nq>10000");

  if (na>0) {
    leX(caminho+"/train-images.idx3-ubyte",na,AX,ax);
    leY(caminho+"/train-labels.idx1-ubyte",na,AY,ay);
  }
  if (nq>0) {
    leX(caminho+"/t10k-images.idx3-ubyte",nq,QX,qx);
    leY(caminho+"/t10k-labels.idx1-ubyte",nq,QY,qy);
    qp.create(nq,1);
  }
}

int MNIST::contaErros() {
  // conta numero de erros
  int erros=0;
  for (int l=0; l<qp.rows; l++) if (qp(l)!=qy(l)) erros++;
  return erros;
}

Mat_<uchar> MNIST::geraSaida(Mat_<uchar> q, int qy, int qp) {
  Mat_<uchar> d(28,38,192);
  putText(d,to_string(qy),Point(28,9) ,FONT_HERSHEY_SIMPLEX,0.3,Scalar(0,0,0));
  putText(d,to_string(qp),Point(28,21),FONT_HERSHEY_SIMPLEX,0.3,Scalar(0,0,0));
  int delta=(28-q.rows)/2;
  copia(q,d,delta,delta);
  return d;
}

Mat_<uchar> MNIST::geraSaidaErros(int maxErr) {
  // Gera imagem 23x38, colocando qy e qp a direita.
  int erros=contaErros();
  Mat_<uchar> e(28,40*min(erros,maxErr),192);
  for (int j=0, i=0; j<qp.rows; j++) {
    if (qp(j)!=qy(j)) {
      Mat_<uchar> t=geraSaida(QX[j],qy(j),qp(j));
      copia(t,e,0,40*i); i++;
      if (i>=min(erros,maxErr)) break;
    }
  }
  return e;
}

Mat_<uchar> MNIST::geraSaidaErros(int nl, int nc) {
  // Gera uma imagem com os primeiros nl*nc digitos classificados erradamente
  Mat_<uchar> e(28*nl,40*nc,192);
  int j=0;
  for (int l=0; l<nl; l++)
    for (int c=0; c<nc; c++) {
      //acha o proximo erro
      while (qp(j)==qy(j) && j<qp.rows) j++;
      if (j==qp.rows) goto saida;
      Mat_<uchar> t=geraSaida(QX[j],qy(j),qp(j));
      copia(t,e,28*l,40*c); j++;
    }
  saida: return e;
}

