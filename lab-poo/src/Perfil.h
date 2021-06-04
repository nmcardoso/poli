#ifndef PERFIL_H
#define PERFIL_H

#include <string>
#include <vector>
#include <list>
#include "Perfil.h"

using namespace std;

class Mensagem;

class Perfil{
    protected:
        string nome;
        list<Mensagem*>* msgRecebidas;
        list<Mensagem*>* msgEnviadas;
    public:
        Perfil(string nome);
        virtual ~Perfil();
        string getNome();
        virtual void adicionadoPor(Perfil* contato) = 0;
        virtual void envia(string texto, bool curtir);
        virtual void recebe(Mensagem* m);
        list<Mensagem*>* getMensagensRecebidas();
        list<Mensagem*>* getMensagensEnviadas();
        vector<Perfil*>* getContatos();
        vector<Perfil*>* getContatosAlcancaveis();
        void setContatos(vector<Perfil*>* perfis); // persistencia
};

#endif