#include <iostream>
#include "TelaPrincipal.h"
#include "PersistenciaDoPerfil.h"
#include "Gerenciador.h"

using namespace std;

int main(){
    string arquivo;
    Gerenciador* g = Gerenciador::getInstance();
    TelaPrincipal* telaPrincipal = new TelaPrincipal();
    
    cout << "Informe o nome do arquivo: ";
    cin >> arquivo;
    PersistenciaDoPerfil* persistencia = new PersistenciaDoPerfil(arquivo);
    persistencia->obter();
   
    telaPrincipal->show();
    
    persistencia->salvar(g->getGrafo()->getVertices());
    
    delete(telaPrincipal);
    delete(persistencia);
    g->reset();
    
    return 0;
}