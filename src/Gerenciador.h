#ifndef GERENCIADOR_H
#define GERENCIADOR_H

#include "Perfil.h"
#include "Grafo.h"
#include "Mensagem.h"

//#define Gerenciador Gerenciador::getInstance() // Simplificação da notação

class Gerenciador{
// Esta classe gerencia todos os perfis do sistema.
private:
    Grafo* grafo;
    Perfil* logado;
    
    // Singleton
    Gerenciador();
public:
    ~Gerenciador();
    int qtdPerfis();
    void addPerfil(Perfil *p);
    void logar(Perfil* p);
    Perfil* perfilLogado();
    Grafo* getGrafo();
    
    // Singleton
    static Gerenciador* getInstance();
    void reset();
};

#endif // GERENCIADOR_H
