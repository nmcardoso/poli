#include "Perfil.h"
#include "Gerenciador.h"
#include "MensagemComCurtir.h"
#include "TelaMsgEnv.h"

using namespace std;

Perfil::Perfil(string nome){
    this->nome = nome;
    msgEnviadas = new list<Mensagem*>;
    msgRecebidas = new list<Mensagem*>;
}

Perfil::~Perfil(){
    delete(msgEnviadas);
    delete(msgRecebidas);
}

list<Mensagem*>* Perfil::getMensagensEnviadas(){
    return msgEnviadas;
}

list<Mensagem*>* Perfil::getMensagensRecebidas(){
    return msgRecebidas;
}

string Perfil::getNome(){
    return nome;
}

void Perfil::recebe(Mensagem *m){
    msgRecebidas->push_back(m);
}

vector<Perfil*>* Perfil::getContatos(){
    return Gerenciador::getInstance()->getGrafo()->adjacencia(this);
}

void Perfil::setContatos(vector<Perfil*>* perfis){
    Gerenciador::getInstance()->getGrafo()->addArestas(this, perfis);
}

void Perfil::envia(string texto, bool curtir){
    vector<Perfil*>* contatos = getContatos();
    
    if(curtir){
        MensagemComCurtir* mcc = new MensagemComCurtir(texto, this);
        
        for(int i = 0; i < contatos->size(); i++)
            contatos->at(i)->recebe(mcc);
            
        msgEnviadas->push_back(mcc);
    }else{
        Mensagem* m = new Mensagem(texto, this);
        
        for(int i = 0; i < contatos->size(); i++)
            contatos->at(i)->recebe(m);
            
        msgEnviadas->push_back(m);
    }
}

vector<Perfil*>* Perfil::getContatosAlcancaveis(){
    return Gerenciador::getInstance()->getGrafo()->BFS(this);
}