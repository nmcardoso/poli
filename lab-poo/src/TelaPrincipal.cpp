#include <iostream>
#include "TelaPrincipal.h"
#include "TelaCadPerfil.h"
#include "TelaLogin.h"

using namespace std;

void TelaPrincipal::show (){
    int numero;
    TelaCadPerfil* telaCadPerfil = new TelaCadPerfil();
    TelaLogin* telaLogin = new TelaLogin();
     
    do{
        cout << "--------------------------------------------------------" << endl;
        cout << "PoliSocial" << endl;
        cout << "-----------" << endl;
        cout << "1) Cadastrar pessoa" << endl;
        cout << "2) Cadastrar departamento" << endl;
        cout << "3) Logar como perfil" << endl;
        cout << "0) Terminar" << endl;
        
        do{ // nao deixa o programa "morrer"
            cout << ">> ";
            cin >> numero;
        }while(numero < 0 || numero > 3);
        
        if (numero == 1)
            telaCadPerfil->show(0);
        else if (numero == 2)
            telaCadPerfil->show(1);
        else if(numero == 3)
            telaLogin->show();
    }while(numero != 0);
     
     
    delete(telaCadPerfil);
    delete(telaLogin);
}