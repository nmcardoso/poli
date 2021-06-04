#include <iostream>
#include <stdexcept>
#include <vector>
#include "TelaAddContato.h"
#include "Grafo.h"
#include "Pessoa.h"

using namespace std;

void TelaAddContato::show (){
    int i = 0, numero;
    Pessoa* logado;

    cout << "--------------------------------------------------------" << endl;
    cout << "Adicionar contato" << endl;
    cout << "-----------------" << endl;
    
    vector<Perfil*>* perfis = Gerenciador::getInstance()->getGrafo()->getVertices();
    for(int i = 0; i < perfis->size(); i++)
        cout << i + 1 << ") " << perfis->at(i)->getNome() << endl;
    
    cout << "Escolha um contato para adicionar ou 0 para voltar" << endl;
    
    do{ // não deixa o programa "morrer" caso um num fora do intervalo seja digitado
        cout << ">> ";
        cin >> numero;
    }while(numero < 0 || numero > perfis->size() 
        || perfis->at(numero-1) == Gerenciador::getInstance()->perfilLogado());
    
    if(numero == 0) return;
    
    try{
        logado = dynamic_cast<Pessoa*>(Gerenciador::getInstance()->perfilLogado());
        logado->adiciona(perfis->at(numero - 1));
        cout << Gerenciador::getInstance()->perfilLogado()->getNome() 
            << " conectado a " << perfis->at(numero - 1)->getNome() << endl;
    }catch(exception& e){
        cout << "Aviso: " << e.what() << endl;
    }
}