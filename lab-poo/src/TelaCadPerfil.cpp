#include <iostream>
#include <vector>
#include "TelaCadPerfil.h"
#include "Pessoa.h"
#include "Departamento.h"

using namespace std;

void TelaCadPerfil::show(int opcao){
    // Recebe 0 para abrir tela de cadastro de pessoa
    // Recebe 1 para abrir tela de cadastro de departamento
    if(opcao == 0){
        cadPessoa();
    }else if(opcao == 1){
        if(Gerenciador::getInstance()->qtdPerfis() == 0)
            cout << "Erro: nao ha nenhuma pessoa cadastrada para ser responsavel pelo departamento" << endl;
        else
            cadDepartamento();
    }
}

void TelaCadPerfil::cadDepartamento(){
    cout << "--------------------------------------------------------" << endl;
    cout << "Cadastrar Departamento" << endl;
    cout << "----------------------" << endl;
    
    
    Departamento *d;
    string nome, site;
    int idPerfil;
    Pessoa* responsavel;
    
    cout << "Informe os dados do departamento:" << endl;
    
    cout << "Nome: ";
    cin.ignore(100, '\n');
    getline(cin, nome);
    
    cout << "Site: ";
    getline(cin, site);
    
    cout << "Escolha um responsavel: " << endl;
    vector<Perfil*>* perfis = Gerenciador::getInstance()->getGrafo()->getVertices();
    for(int i = 0; i < perfis->size(); i++)
        cout << i + 1 << ") " << perfis->at(i)->getNome() << endl;

    cout << "Digite um número ou 0 para cancelar" << endl;
    
    do{
        cout << ">> ";
        cin >> idPerfil;
        responsavel = dynamic_cast<Pessoa*>(perfis->at(idPerfil - 1));
    }while(idPerfil < 0 || idPerfil > perfis->size() || responsavel == NULL);
    
    d = new Departamento(nome, site, responsavel);
    Gerenciador::getInstance()->addPerfil(d);
    cout << "Departamento cadastrado com sucesso" << endl;
    
}

void TelaCadPerfil::cadPessoa (){
    cout << "--------------------------------------------------------" << endl;
    cout << "Cadastrar Pessoa" << endl;
    cout << "----------------" << endl;
    
    
    Pessoa *p;
    string nome, dataNascimento, pais;
    
    cout << "Informe os dados da pessoa:" << endl;
    cout << "Nome: ";
    cin.ignore(100, '\n');
    getline(cin, nome);

    cout << "Data de nascimento: ";
    getline(cin, dataNascimento);

    cout << "Pais: ";
    getline(cin, pais);
    
    p = new Pessoa(nome, dataNascimento, pais);
    Gerenciador::getInstance()->addPerfil(p); // adiciona a pessoa no controle global de usuarios
    
    cout << "Pessoa cadastrada com sucesso" << endl;
    
}
