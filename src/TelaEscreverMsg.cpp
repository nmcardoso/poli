#include <iostream>
#include <vector>
#include <stdexcept>
#include "TelaEscreverMsg.h"
#include "Departamento.h"
#include "Perfil.h"

using namespace std;

void TelaEscreverMsg::show(){
    int op;
    
    if(dynamic_cast<Departamento*>(Gerenciador::getInstance()->perfilLogado()) != NULL){
        mensagemPublica();
    }else{
        cout << "A mensagem eh privada (0 - nao, 1 - sim): ";
        cin >> op;
        
        if (op == 1)
            mensagemPrivada();
        else
            mensagemPublica();
    }
}

void TelaEscreverMsg::mensagemPrivada(){
    int id;
    string msg;
    
    cout << "Escolha o destino:" << endl;
    
    vector<Perfil*>* perfis = Gerenciador::getInstance()->getGrafo()->getVertices();
    for(int i = 0; i < perfis->size(); i++)
        cout << i + 1 << ") " << perfis->at(i)->getNome() << endl;
    
    cout << "Digite um número ou 0 para cancelar" << endl;
    cout << ">> ";
    cin >> id;
    
    if(id == 0) return;
    
    try{
        cout << "Digite a mensagem:" << endl;
        cout << ">> ";
        cin.ignore(100, '\n');
        getline(cin, msg);
        
        Pessoa* p = dynamic_cast<Pessoa*>(Gerenciador::getInstance()->perfilLogado());
        if(p != NULL){
            p->envia(msg, perfis->at(id - 1));
            cout << "Mensagem enviada a " << perfis->at(id - 1)->getNome();
        }
    }catch(exception& e){
        cout << "Aviso: " << e.what() << endl;
    }
}

void TelaEscreverMsg::mensagemPublica(){
    string msg;
    int op;
    
    cout << "A mensagem pode ser curtida? (0 - não, 1 - sim): ";
    cin >> op;
    
    cout << "Digite a mensagem" << endl;
    cout << ">> ";
    cin.ignore(100, '\n');
    getline(cin, msg);
    
    Gerenciador::getInstance()->perfilLogado()->envia(msg, op);
    
    cout << "Mensagem enviada para todos os contatos" << endl;
}
