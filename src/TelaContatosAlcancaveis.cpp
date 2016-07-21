#include <iostream>
#include <vector>
#include "Gerenciador.h"
#include "Perfil.h"
#include "TelaContatosAlcancaveis.h"

using namespace std;

void TelaContatosAlcancaveis::show(){
    cout << "--------------------------------------------------------" << endl;
    cout << "Contatos alcancaveis" << endl;
    cout << "--------------------" << endl;
    
    vector<Perfil*>* contatos = Gerenciador::getInstance()->perfilLogado()->getContatosAlcancaveis();
    if(contatos->empty())
        cout << "Nenhum contato alcancavel" << endl;
    for(int i = 0; i < contatos->size(); i++)
        cout << i + 1 << ") " << contatos->at(i)->getNome() << endl;
        
    delete(contatos);
}