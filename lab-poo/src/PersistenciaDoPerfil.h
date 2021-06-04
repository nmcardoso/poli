#ifndef PERSISTENCIADOPERFIL_H
#define PERSISTENCIADOPERFIL_H

#include <string>
#include <vector>
#include "Perfil.h"

using namespace std;

class PersistenciaDoPerfil{
    private:
        string arquivo;
        vector<int> tokeniza(string val);
        string trim(string str);
    public:
        PersistenciaDoPerfil(string arquivo); 
        virtual ~PersistenciaDoPerfil(); 
        vector<Perfil*>* obter(); 
        void salvar(vector<Perfil*>* perfis);
};

#endif