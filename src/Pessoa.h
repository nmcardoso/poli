#ifndef PESSOA_H
#define PESSOA_H

#include <iostream>
#include "Perfil.h"

using namespace std;

class Pessoa : public Perfil{
private:
    string pais;
    string dataDeNascimento;
public:
    Pessoa(string nome, string dataDeNascimento, string pais);
    virtual ~Pessoa();
    string getPais();
    string getDataDeNascimento();
    void adiciona(Perfil *contato);
    void envia(string texto, Perfil *contato);
    bool remove(Perfil *contato);
    virtual void adicionadoPor(Perfil *contato);
};

#endif