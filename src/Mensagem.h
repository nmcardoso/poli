#ifndef MENSAGEM_H
#define MENSAGEM_H

#include <string>

using namespace std;

class Perfil;

class Mensagem{
    private:
        string texto;
        Perfil* autor;
    public:
        Mensagem(string texto, Perfil* autor);
        virtual ~Mensagem();
        string getTexto();
        Perfil* getAutor();
};

#endif