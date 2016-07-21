#include <list>
#include "TelaMsgEnv.h"
#include "Mensagem.h"
#include "MensagemComCurtir.h"

using namespace std;

void TelaMsgEnv::show(){
    int i = 1, curtidas = 0;
    
    cout << "--------------------------------------------------------" << endl;
    cout << "Mensagens Enviadas" << endl;
    cout << "------------------" << endl;
    
    list<Mensagem*>* mensagens = Gerenciador::getInstance()->perfilLogado()->getMensagensEnviadas();
    MensagemComCurtir* mcc;
    list<Mensagem*>::iterator it = mensagens->begin();
    
    if(mensagens->empty()){
        cout << "Nenhuma mensagem enviada" << endl;
    }else{
        while(it != mensagens->end()){
            mcc = dynamic_cast<MensagemComCurtir*>(*it);
            
            if(mcc == NULL){
                cout << i << ") " << (*it)->getTexto() << endl;
            }else{
                curtidas = mcc->getCurtidas();
                
                cout << i << ") " << mcc->getTexto() << " (" << curtidas
                    << " " << ((curtidas > 1) ? "curtidas" : "curtida") << ")" << endl;
            }
            i++; it++;
        }
    }

}
