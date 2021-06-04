#ifndef DEPARTAMENTO_H
#define DEPARTAMENTO_H

#include <string>
#include "Mensagem.h"
#include "Perfil.h"
#include "Pessoa.h"

using namespace std;

class Departamento : public Perfil{
    private:
        string nome, site;
        Pessoa* responsavel;
    public:
        Departamento(string nome, string site, Pessoa* responsavel);
        Departamento(string nome, string site); // persistencia
        virtual ~Departamento();
        string getSite();
        void setResponsavel(Pessoa* responsavel); // persistencia
        Pessoa* getResponsavel();
        virtual void recebe(Mensagem* m);
        virtual void adicionadoPor(Perfil* contato);
};

#endif