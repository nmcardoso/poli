% Funções suporte
d2r = @(x) (x*pi/180);
r2d = @(x) (x*180/pi);
cis = @(x) exp(j*x);
cisd = @(x) cis(d2r(x));
angled = @(x) r2d(angle(x));
to_rd = @(m, d) (m .* cisd(d));
to_pd = @(x) [abs(x) angled(x)];

% Gerador
tensao_gerador = 13.8e3;

% Transformador
potencia_trafo = 12e6;
Xcc = 7.5/100;
tensao_primario = 13.8e3;
reatancia_secundario = 5;
tensao_secundario = 69e3;

% Linha de transmissão
x1_por_km = 0.4890j;
x0_por_km = 1.7650j;
km_linha = 15;

% Sistema de proteção
TMS = 0.1;
Is = 204;
t = 0.9;


% Valores de base
Sb1 = potencia_trafo;
Vb1 = tensao_primario;
Zb1 = Vb1^2 / Sb1;
Ib1 = potencia_trafo / (tensao_primario * sqrt(3));

Sb2 = potencia_trafo;
Vb2 = tensao_secundario;
Zb2 = Vb2^2 / Sb2;
Ib2 = potencia_trafo / (tensao_secundario * sqrt(3));


% Questão 1
x1 = km_linha * x1_por_km
x1_pu = x1 / Zb2
xcc_pu = j*Xcc
i1 = 1 / (xcc_pu + x1_pu)
Icc1 = i1 * Ib1


% Questão 2
x0 = km_linha * x0_por_km
i0 = 1 / 
I0 = i0 * Ib2
Icc0 = 3 * I0


% Questão 3
Icc = Is*(13.5*TMS + t) / t
xot = (1 / abs(i0) - Icc / Ib1)/3
