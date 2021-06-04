#include <queue>
#include <map>
#include <algorithm>
#include "Grafo.h"
#include "Gerenciador.h"

using namespace std;

Grafo::~Grafo(){
    
}

Grafo::Grafo(){
    A = new map<Perfil*, vector<Perfil*>*>;
    vertices = new vector<Perfil*>;
}

int Grafo::qtdVertices(){
    // Retorna a quantidade de vertices do grafo
    return A->size();
}

void Grafo::addAresta(Perfil* origem, Perfil* destino){
    // Recebe dois perfis e adiciona uma aresta que os conecta no grafo
    // Considera que os vertices pertencem ao grafo
    if(!contem(origem, destino)) A->at(origem)->push_back(destino);
}

void Grafo::addArestas(Perfil* origem, vector<Perfil*>* destinos){
    // Recebe uma origem e um vetor destinos;
    // Cria o vertice origem, caso não exita (importante para persistencia);
    // Substitui informações existentes, caso haja.
    (*A)[origem] = destinos;
}

void Grafo::addVertice(Perfil* p){
    // Recebe um valor, cria um vertice com o valor especificado e o adiciona
    if(!contem(p)) (*A)[p] = new vector<Perfil*>;
}

void Grafo::delAresta(Perfil* origem, Perfil* destino){
    // Recebe dois vertices e remove a aresta entre eles
    vector<Perfil*>::iterator i;
    vector<Perfil*>* v = A->at(origem);
    
    i = find(v->begin(), v->end(), destino);
    if(i != v->end()) v->erase(i);
}

vector<Perfil*>* Grafo::adjacencia(Perfil* v){
    // Retorna uma lista com os adjacentes a um vertice v
    return A->at(v);
}

vector<Perfil*>* Grafo::BFS(Perfil* s){
    // Recebe um vértice fonte e faz uma busca em largura no grafo exibindo
    // o nome dos perfis visitados
    vector<Perfil*>* busca = new vector<Perfil*>;
    vector<Perfil*>* adj;
    queue<Perfil*> pilha;
    pilha.push(s);
    
    while(!pilha.empty()){
        adj = adjacencia(pilha.front());
        pilha.pop();
        
        if(!adj->empty()){
            for(int i = 0; i < adj->size(); i++){
                if(find(busca->begin(), busca->end(), adj->at(i)) == busca->end()){
                    busca->push_back(adj->at(i));
                    pilha.push(adj->at(i));
                }
            }
        }
    }
    
    return busca;
}

bool Grafo::contem(Perfil* v){
    // Verifica se existe o vertice especificado
    return A->find(v) != A->end();
}

bool Grafo::contem(Perfil* origem, Perfil* destino){
    // Verifica se existe uma aresta com a origem e destino especificados
    vector<Perfil*>* v = A->at(origem);
    vector<Perfil*>::iterator i = find(v->begin(), v->end(), destino);
    
    return i != v->end();
}

vector<Perfil*>* Grafo::getVertices(){
    // Retorna um vetor com todos os vertices do grafo
    map<Perfil*, vector<Perfil*>*>::iterator i;
    
    // apaga o vetor de vertices e o atualiza
    vertices->clear();
    for(i = A->begin(); i != A->end(); i++){
        vertices->push_back(i->first);
    }
    
    return vertices;
}