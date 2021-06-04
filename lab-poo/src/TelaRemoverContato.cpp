#include "TelaRemoverContato.h"
#include <iostream>
#include <vector>
#include "Perfil.h"
#include "Pessoa.h"
#include "Gerenciador.h"

using namespace std;

void TelaRemoverContato::show(){
    Gerenciador* g = Gerenciador::getInstance();
    Perfil* perfil_removido;
    int indice;
    
    cout << "Escolha o contato a remover" << endl;
    vector<Perfil*>* contatos = g->perfilLogado()->getContatos();
    for(int i = 0; i < contatos->size(); i++)
        cout << i + 1 << ") " << contatos->at(i)->getNome() << endl;
        
    cout << "Digite um numero ou 0 para voltar" << endl;
    do{
        cout << ">> ";
        cin >> indice;
    }while(indice <= 0 || indice > contatos->size());
    
    perfil_removido = contatos->at(indice - 1);
    dynamic_cast<Pessoa*>(g->perfilLogado())->remove(perfil_removido);
    cout << "Contato com " << perfil_removido->getNome() << " removido" << endl;
}