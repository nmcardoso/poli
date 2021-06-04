#include <vector>
#include "TelaLogin.h"
#include "TelaPerfil.h"
#include "Pessoa.h"
#include "Perfil.h"

using namespace std;

void TelaLogin::show(){
    int op;
    TelaPerfil* telaPerfil = new TelaPerfil();

    do{
        cout << "--------------------------------------------------------" << endl;
        cout << "Logar" << endl;
        cout << "-----" << endl;
        
        cout << "Escolha uma das pessoas" << endl;

        vector<Perfil*>* perfis = Gerenciador::getInstance()->getGrafo()->getVertices();
        for(int i = 0; i < perfis->size(); i++)
            cout << i + 1 << ") " << perfis->at(i)->getNome() << endl;

        cout << "Digite um número ou 0 para voltar" << endl;

        do{ // nao deixa o programa morrer
            cout << ">> ";
            cin >> op;
        }while(op < 0 || op > perfis->size()); 
        
        if(op != 0){
            Gerenciador::getInstance()->logar(perfis->at(op - 1));
            telaPerfil->show();
        }

    }while(op != 0);
    
    delete(telaPerfil);
}
