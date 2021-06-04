#include <vector>
#include <stdexcept>
#include <algorithm>
#include <string>
#include "Pessoa.h"
#include "Mensagem.h"
#include "Gerenciador.h"

using namespace std;

Pessoa::Pessoa(string nome, string dataDeNascimento, string pais):Perfil(nome){
    this->dataDeNascimento = dataDeNascimento;
    this->pais = pais;
}

Pessoa::~Pessoa(){
}

string Pessoa::getDataDeNascimento(){
    return dataDeNascimento;
}

string Pessoa::getPais(){
    return pais;
}

void Pessoa::adiciona(Perfil* contato){
    if(Gerenciador::getInstance()->getGrafo()->contem(this, contato))
        throw logic_error(contato->getNome() + " ja pertence aos contatos");
        
    if(dynamic_cast<Pessoa*>(contato) != NULL){
        Gerenciador::getInstance()->getGrafo()->addAresta(this, contato);
        contato->adicionadoPor(this);
    }else{
        Gerenciador::getInstance()->getGrafo()->addAresta(this, contato);
        Gerenciador::getInstance()->getGrafo()->addAresta(contato, this);
        adicionadoPor(contato);
    }
}

bool Pessoa::remove(Perfil *contato){
    // enviando mensagem
    string texto = this->getNome() + " removeu voce como contato";
    Mensagem* mensagem = new Mensagem(texto, this);
    contato->recebe(mensagem);
    
    // retirando do grafo
    Gerenciador::getInstance()->getGrafo()->delAresta(this, contato);
}

void Pessoa::envia(string texto, Perfil* contato){
    if(!Gerenciador::getInstance()->getGrafo()->contem(this, contato))
        throw logic_error(contato->getNome() + " nao pertence aos contatos");
    
    Mensagem* m = new Mensagem(texto, this);
    contato->recebe(m);
    msgEnviadas->push_back(m);
}

void Pessoa::adicionadoPor(Perfil* contato){
    string texto = contato->getNome() + " adicionou voce como contato";
    Mensagem* m = new Mensagem(texto, contato);
    recebe(m);
}