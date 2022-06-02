%
% 1) Profilaxia do ambiente
%
clc;
close all;
clear all;
%
% 2) Input de dados
%
% 2.1) Dados da fonte
%
fonte = input('A fonte está ligada em estrela ou triângulo? (0 - estrela; 1 - triângulo): ');
vfonte    = input('Digite a o valor da tensão de fase da fonte, em volts: ');
tetafonte = input('Digite a fase da tensão de linha de referência da fonte, em graus: ');
%
% 2.2) Dados da carga
%
carga = input('A carga está ligada em estrela ou triângulo? (0 - estrela; 1 - triângulo): ');
rcarga = input('Digite a resistência da carga, em ohms: ');
xcarga = input('Digite a reatância da carga, em ohms: ');
%
% 2.3) Dados da linha
%
rlinha = input('Digite a resistência da linha, em ohms: ');
xlinha = input('Digite a reatância da linha, em ohms: ');
%
% 3) Tratamento dos dados para obtenção do circuito equivalente em estrela
%
% 3.1) Fonte
%
if fonte==0
  vfaseequivalente = vfonte*exp(1i*(tetafonte-30)*pi/180);
else
  if fonte==1
    vfaseequivalente = (vfonte/sqrt(3))*exp(1i*(tetafonte-30)*pi/180);
  end
end    
%
% 3.2) Carga
%
if carga==0
  zcargaequivalente = rcarga + 1i*xcarga;
else
  if carga==1
    zcargaequivalente = (rcarga + 1i*xcarga)/3;
  end
end
%
% 4) Solução do circuito equivalente
%
ilinha                = vfaseequivalente/(rlinha +1i*xlinha + zcargaequivalente);
deltalinha            = ilinha*(rlinha +1i*xlinha);
vfasecargaequivalente = vfaseequivalente - deltalinha;
%
% 5) Respostas
%
if carga==0
  fprintf('A tensão de fase na carga é: %6.3f\n',abs(vfasecargaequivalente));
  fprintf('A tensão de linha na carga é: %6.3f\n',abs(vfasecargaequivalente)*sqrt(3));
  fprintf('A corrente de fase na carga é: %6.3f\n',abs(ilinha));
  fprintf('A corrente de linha na carga é: %6.3f\n',abs(ilinha));
else
  if carga==1
    fprintf('A tensão de fase na carga é: %6.3f\n',abs(vfasecargaequivalente)*sqrt(3));
    fprintf('A tensão de linha na carga é: %6.3f\n',abs(vfasecargaequivalente)*sqrt(3));
    fprintf('A corrente de fase na carga é: %6.3f\n',abs(ilinha)/sqrt(3));
    fprintf('A corrente de linha na carga é: %6.3f\n',abs(ilinha));
  end
end  
fprintf('A corrente de linha na carga é: %6.3f\n',abs(deltalinha));