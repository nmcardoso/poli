#include "Departamento.h"

using namespace std;

Departamento::Departamento(string nome, string site, Pessoa* responsavel):Perfil(nome){
    this->site = site;
    this->responsavel = responsavel;
}

Departamento::Departamento(string nome, string site):Perfil(nome){
    this->site = site;
}

Departamento::~Departamento(){
    
}

string Departamento::getSite(){
    return site;
}

Pessoa* Departamento::getResponsavel(){
    return responsavel;
}

void Departamento::setResponsavel(Pessoa* responsavel){
    this->responsavel = responsavel;
}

void Departamento::recebe(Mensagem* m){
    msgRecebidas->push_back(m);
    responsavel->recebe(m);
}

void Departamento::adicionadoPor(Perfil* contato){
}