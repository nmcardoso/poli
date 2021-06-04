#include "MensagemComCurtir.h"

using namespace std;

MensagemComCurtir::MensagemComCurtir(string texto, Perfil* autor):Mensagem(texto, autor){
    curtidas = 0;
}

MensagemComCurtir::~MensagemComCurtir(){
}


int MensagemComCurtir::getCurtidas(){
    return curtidas;
}

void MensagemComCurtir::curtir(){
    curtidas++;
}