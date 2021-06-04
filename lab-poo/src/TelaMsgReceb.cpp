#include <list>
#include "TelaMsgReceb.h"
#include "Mensagem.h"
#include "MensagemComCurtir.h"

using namespace std;

void TelaMsgReceb::show(){
    int i = 1, op, j = 1, curtidas = 0;
    
    cout << "--------------------------------------------------------" << endl;
    cout << "Mensagens Recebidas" << endl;
    cout << "-------------------" << endl;
    
    list<Mensagem*>* mensagens = Gerenciador::getInstance()->perfilLogado()->getMensagensRecebidas();
    list<Mensagem*>::iterator it = mensagens->begin();
    MensagemComCurtir* mcc;
    
    if(mensagens->empty()){
        cout << "Nenhuma mensagem recebida" << endl;
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

            it++; i++;
        }
        
        cout << "Digite o numero da mensagem para curtir ou 0 para voltar" << endl;
    
        do{
            cout << ">> ";
            cin >> op;
        }while(op < 0 || op > mensagens->size());
        
        if(op != 0){
            it = mensagens->begin();
            while(j < op){
                it++; j++;
            }
            
            mcc = dynamic_cast<MensagemComCurtir*>(*it);
            if(mcc != NULL){
                mcc->curtir();
                cout << "Mensagem curtida" << endl;
            }else{
                cout << "Aviso: Mensagem nao pode ser curtida" << endl;
            }
            
        }
    }
    
}
