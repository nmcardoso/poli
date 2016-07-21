#include "Mensagem.h"

using namespace std;

Mensagem::Mensagem(string texto, Perfil* autor){
    this->texto = texto;
    this->autor = autor;
}

Mensagem::~Mensagem(){
}

string Mensagem::getTexto(){
    return texto;
}

Perfil* Mensagem::getAutor(){
    return autor;
}