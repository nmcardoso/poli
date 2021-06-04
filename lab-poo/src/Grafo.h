#ifndef GRAFO_H
#define GRAFO_H

#include <vector>
#include <map>
#include "Perfil.h"

using namespace std;

class Grafo{
// Classe de um grafo dirigido
private:
    map<Perfil*, vector<Perfil*>*>* A; // lista de adjacencia
    vector<Perfil*>* vertices; // apenas por causa da persistencia
    
public:
    ~Grafo();
    Grafo();
    vector<Perfil*>* getVertices();
    vector<Perfil*>* adjacencia(Perfil* v);
    void addAresta(Perfil* origem, Perfil* destino);
    void addArestas(Perfil* origem, vector<Perfil*>* destinos); // persistencia
    void delAresta(Perfil* origem, Perfil* destino);
    void addVertice(Perfil* p);
    vector<Perfil*>* BFS(Perfil* v);
    bool contem(Perfil* p);
    bool contem(Perfil* origem, Perfil* destino);
    int qtdVertices();
};

#endif