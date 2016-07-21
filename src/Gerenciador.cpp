#include "Gerenciador.h"

using namespace std;

Gerenciador::Gerenciador(){
    grafo = new Grafo();
}

Gerenciador::~Gerenciador(){
}

void Gerenciador::reset(){
    delete(grafo);
}

Gerenciador* Gerenciador::getInstance(){
    // Cria instancia singleton
    static Gerenciador instance;
    return &instance;
}

int Gerenciador::qtdPerfis(){
    // Retorna a quantidade de perfis cadastrados no sistema
    return grafo->qtdVertices();
}

void Gerenciador::addPerfil(Perfil* p){
    // Recebe um perfil e o adiciona ao grafo
    grafo->addVertice(p);
}

Grafo* Gerenciador::getGrafo(){
    // Retorna o grafo com os perfis do sistema
    return grafo;
}

void Gerenciador::logar(Perfil* p){
    // Recebe um pondeiro de perfil e o identifica como logado
    logado = p;
}

Perfil* Gerenciador::perfilLogado(){
    // Retorna o perfil logado no sistema
    return logado;
}