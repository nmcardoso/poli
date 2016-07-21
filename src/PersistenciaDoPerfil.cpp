#include <fstream>
#include <iostream>
#include <algorithm>
#include <sstream>
#include <string>
#include "PersistenciaDoPerfil.h"
#include "Pessoa.h"
#include "Departamento.h"

using namespace std;

PersistenciaDoPerfil::PersistenciaDoPerfil(string arquivo){
    this->arquivo = arquivo;
}

PersistenciaDoPerfil::~PersistenciaDoPerfil(){
    
}

vector<int> PersistenciaDoPerfil::tokeniza(string val){
    // Recebe uma string e retorna um vector de inteiros usando o caractere
    // espaco como delimitador
    vector<int> tokenizado;
    string temp = "";
    
    for(int i = 0; i < val.size(); i++){
        if((val[i] == ' ' && temp != "") || (i == val.size() - 1 && temp != "")){
            tokenizado.push_back(atoi(temp.c_str()));
            temp = "";
        }else if(val[i] != ' '){
            temp += val[i];
        }
    }
    return tokenizado;
}

string PersistenciaDoPerfil::trim(string str){
    // Recebe uma string e corta os espaços excedentes nas bordas
    string nova = "";
    int inicio = 0;
    int fim = str.length() - 1;
    
    while(str[inicio] == ' ') inicio++;
    while(str[fim] == ' ') fim--;
    
    for(int i = inicio; i <= fim; i++) nova += str[i];
    
    return nova;
}

vector<Perfil*>* PersistenciaDoPerfil::obter(){
    vector<Perfil*>* perfis = new vector<Perfil*>;
    string token;
    
    ifstream inFile;
    inFile.open(arquivo.c_str());
    
    if(inFile.fail())
        cerr << "Arquivo de persistencia nao encontrado" << endl;
    
    while(inFile){
        inFile >> token;
        inFile.ignore(100, '\n');
        
        if(token == "P"){
            // ler proximas 3 linhas
            string nome;
            string dataNasc;
            string pais;
            
            getline(inFile, nome);
            getline(inFile, dataNasc);
            getline(inFile, pais);
            
            perfis->push_back(new Pessoa(trim(nome), trim(dataNasc), trim(pais)));
        }else if(token == "D"){
            // ler proximas 2 linhas
            string nome;
            string site;
            
            getline(inFile, nome);
            getline(inFile, site);
            
            perfis->push_back(new Departamento(trim(nome), trim(site)));
        }else if(token == "#"){
            string linha; // <num_contatos>[0] <contatos>[1..n-1] <resp, se depto>[n]
            vector<int> linha_t; // linha tokenizada
            int num_linha = 0; // acompanha indice do vetor perfis
            int num_contatos;
            
            while(getline(inFile, linha) && num_linha < perfis->size()){
                linha_t = tokeniza(linha);
                Pessoa* p = dynamic_cast<Pessoa*>(perfis->at(num_linha));
                num_contatos = linha_t[0];
                vector<Perfil*>* contatos = new vector<Perfil*>;
                
                if(p != NULL){ // eh pessoa
                    for(int i = 1; i <= num_contatos; i++){
                        contatos->push_back(perfis->at(linha_t[i] - 1));
                    }
                    p->setContatos(contatos);
                }else{ // eh depto
                    Departamento* d = dynamic_cast<Departamento*>(perfis->at(num_linha));
                    
                    for(int i = 1; i <= num_contatos; i++)
                        contatos->push_back(perfis->at(linha_t[i] - 1));
                    d->setContatos(contatos);
                   
                    Pessoa* responsavel = dynamic_cast<Pessoa*>(perfis->at(linha_t.back()));
                    if(responsavel != NULL) 
                        d->setResponsavel(responsavel);
                }
                
                num_linha++;
            }
        }
    }
    
    inFile.close();
    
    cout << "Perfis carregados" << endl;
}

void PersistenciaDoPerfil::salvar(vector<Perfil*>* perfis){
    Pessoa* pessoa;
    Departamento* departamento;
    vector<Perfil*>* contatos;
    
    ofstream onFile(arquivo.c_str());
    
    // persistencia dos perfis
    for(int i = 0; i < perfis->size(); i++){
        pessoa = dynamic_cast<Pessoa*>(perfis->at(i));
        if (pessoa != NULL){
            onFile << "P" << endl;
            onFile << pessoa->getNome() << endl;
            onFile << pessoa->getDataDeNascimento() << endl;
            onFile << pessoa->getPais() << endl;
        }else{
            departamento = dynamic_cast<Departamento*>(perfis->at(i));
            onFile << "D" << endl;
            onFile << departamento->getNome() << endl;
            onFile << departamento->getSite() << endl;
        }
    }
    
    onFile << "#" << endl;
    
    // persistencia dos contatos
    for(int i = 0; i < perfis->size(); i++){
        pessoa = dynamic_cast<Pessoa*>(perfis->at(i));
        int k;
        
        if(pessoa != NULL){ // Pessoa
            contatos = pessoa->getContatos();
            onFile << contatos->size() << " ";
            
            for(int j = 0; j < contatos->size(); j++){
                k = 0;
                while(contatos->at(j) != perfis->at(k)) k++;
                onFile << k + 1 << " "; 
                
                departamento = dynamic_cast<Departamento*>(contatos->at(j));
                if(departamento != NULL){
                    k = 0;
                    while(departamento->getResponsavel() != contatos->at(k) && k < contatos->size() - 1) k++;
                    if(k == contatos->size()) onFile << k + 1 << " ";
                }
            }
        }else{ // Departamento
            departamento = dynamic_cast<Departamento*>(perfis->at(i));
            contatos = departamento->getContatos();
            onFile << contatos->size() << " ";
            
            for(int j = 0; j < contatos->size(); j++){
                k = 0;
                while(contatos->at(j) != perfis->at(k)) k++;
                onFile << k + 1 << " ";
            }
            
            k = 0;
            while(departamento->getResponsavel() != perfis->at(k)) k++;
            onFile << k << " ";
        }
        
        onFile << endl;
    }
    
    onFile.close();
    
    cout << "Perfis salvos" << endl;
}