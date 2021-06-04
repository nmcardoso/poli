#include <iostream>
#include <vector>
#include "TelaPerfil.h"
#include "TelaAddContato.h"
#include "TelaEscreverMsg.h"
#include "TelaMsgEnv.h"
#include "TelaMsgReceb.h"
#include "TelaRemoverContato.h"
#include "TelaContatosAlcancaveis.h"
#include "Pessoa.h"
#include "Departamento.h"

using namespace std;

void TelaPerfil::show(){
    // Método decide qual tela exibir de acordo com o tipo de objeto do perfil logado
    if(dynamic_cast<Pessoa*>(Gerenciador::getInstance()->perfilLogado()) != NULL)
        perfilPessoa();
    else
        perfilDepartamento();
}

void TelaPerfil::perfilPessoa(){
    int op;
    TelaAddContato* telaAddContato = new TelaAddContato();
    TelaMsgEnv* telaMsgEnv = new TelaMsgEnv();
    TelaMsgReceb* telaMsgReceb = new TelaMsgReceb();
    TelaEscreverMsg* telaEscreverMsg = new TelaEscreverMsg();
    TelaRemoverContato* telaRemoverContato = new TelaRemoverContato();
    TelaContatosAlcancaveis* telaContatosAlcancaveis = new TelaContatosAlcancaveis();
    Pessoa* p = dynamic_cast<Pessoa*>(Gerenciador::getInstance()->perfilLogado());

    do{
        cout << "--------------------------------------------------------" << endl;
        cout << "Perfil" << endl;
        cout << "------" << endl;
        
        cout << "Pessoa: " << p->getNome() << endl << p->getDataDeNascimento() 
             << " | " << p->getPais() << endl << endl;

        cout << "Contatos:" << endl;
        vector<Perfil*> *contatos = Gerenciador::getInstance()->perfilLogado()->getContatos();
        for(int i = 0; i < contatos->size(); i++)
            cout << i + 1 << ") " << contatos->at(i)->getNome() << endl;
        
        cout << endl;
        
        cout << "Escolha uma opção:" << endl;
        cout << "1) Ver mensagens enviadas" << endl;
        cout << "2) Ver mensagens recebidas" << endl;
        cout << "3) Escrever mensagem" << endl;
        cout << "4) Ver contatos alcancaveis" << endl;
        cout << "5) Adicionar contato" << endl;
        cout << "6) Remover contato" << endl;
        cout << "0) Voltar" << endl;

        do{ // nao deixa o programa "morrer"
            cout << ">> ";
            cin >> op;
        }while(op < 0 || op > 6); 

        switch(op){
            case 1:
                telaMsgEnv->show();
                break;
            case 2:
                telaMsgReceb->show();
                break;
            case 3:
                telaEscreverMsg->show();
                break;
            case 4:
                telaContatosAlcancaveis->show();
                break;
            case 5:
                telaAddContato->show();
                break;
            case 6:
                telaRemoverContato->show();
                break;
            default:
                cout << ">> Digite uma opcao valida" << endl;
                break;
        }
    }while(op != 0); //Sai do loop principal quando for digitado 0
    
    delete(telaMsgEnv);
    delete(telaMsgReceb);
    delete(telaAddContato);
    delete(telaEscreverMsg);
    delete(telaRemoverContato);
    delete(telaContatosAlcancaveis);
}

void TelaPerfil::perfilDepartamento(){
    int op;
    TelaMsgEnv* telaMsgEnv = new TelaMsgEnv();
    TelaMsgReceb* telaMsgReceb = new TelaMsgReceb();
    TelaEscreverMsg* telaEscreverMsg = new TelaEscreverMsg();
    TelaContatosAlcancaveis* telaContatosAlcancaveis = new TelaContatosAlcancaveis();
    Departamento* d = dynamic_cast<Departamento*>(Gerenciador::getInstance()->perfilLogado());

    do{
        cout << "--------------------------------------------------------" << endl;
        cout << "Departamento" << endl;
        cout << "------------" << endl;
        
        cout << "Departamento: " << d->getNome() << endl;
        cout << "Responsavel: " << d->getResponsavel()->getNome() << endl << endl;

        cout << "Contatos:" << endl;
        vector<Perfil*> *contatos = Gerenciador::getInstance()->perfilLogado()->getContatos();
        if(!contatos->empty()){
            for(int i = 0; i < contatos->size(); i++)
                cout << i + 1 << ") " << contatos->at(i)->getNome() << endl;
        }
        cout << endl;
        
        cout << "Escolha uma opção:" << endl;
        cout << "1) Ver mensagens enviadas" << endl;
        cout << "2) Ver mensagens recebidas" << endl;
        cout << "3) Escrever mensagem" << endl;
        cout << "4) Ver contatos alcancaveis" << endl;
        cout << "0) Voltar" << endl;

        do{ // nao deixa o programa "morrer"
            cout << ">> ";
            cin >> op;
        }while(op < 0 || op > 4); 

        switch(op){
            case 1:
                telaMsgEnv->show();
                break;
            case 2:
                telaMsgReceb->show();
                break;
            case 3:
                telaEscreverMsg->show();
                break;
            case 4:
                telaContatosAlcancaveis->show();
                break;
            default:
                cout << ">> Digite uma opcao valida" << endl;
                break;
        }
    }while(op != 0); //Sai do loop principal quando for digitado 0
    
    delete(telaContatosAlcancaveis);
    delete(telaMsgEnv);
    delete(telaMsgReceb);
    delete(telaEscreverMsg);
}