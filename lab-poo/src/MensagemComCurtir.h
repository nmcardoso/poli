#ifndef MENSAGEMCOMCURTIR_H
#define MENSAGEMCOMCURTIR_H

#include <string>
#include "Mensagem.h"

using namespace std;

class MensagemComCurtir : public Mensagem{
    private:
        int curtidas;
    public:
        MensagemComCurtir(string texto, Perfil* autor);
        ~MensagemComCurtir();
        void curtir();
        int getCurtidas();
};

#endif