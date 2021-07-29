% Dados de entrada
m = 1;
n = 2;
p = 2;
eps = 8.854e-12;
h1 = 10;
h2 = 0.005*n + 10.05;
h3 = 0.2*p + 11;
a1 = (0.2*m + 1)*1e-2;
l2 = 20e-2;
a3 = 2e-2;
b = 1e-4;

% Calcula o número de cilindros de carga para representar os corpos
K1 = round((2*pi*a1)/(2*b));
K2 = round(l2/(2*b));
K3 = round((2*pi*a3)/(2*b));
K = K1 + K2 + K3;

% Distribui os cilindros de carga uniformemente sobre os corpos,
% determinando as coordenadas (x,y) dos seus eixos
i = 1:K1;
theta = (i-1)*(2*pi/K1);
x1 = a1*cos(theta);
y1 = a1*sin(theta) + h1;

x2 = -l2/2:2*b:l2/2;
y2 = ones(1,K2)*h2;

i = 1:K3;
theta = i*(2*pi/K3);
x3 = a3*cos(theta);
y3 = a3*sin(theta) + h3;

% Concatena as coordenadas x e y
x = [x1 x2 x3];
y = [y1 y2 y3];

% Cria a matriz de indices i,j (de dimensao KxK) para os cilindros de carga
i = 1:K; 
j = 1:K; 
[i,j] = meshgrid(i,j);

% Calcula os valores de r+ (r1) e r- (r2) para cada par de cilindros de
% carga i,j
r1 = sqrt((x(i)-x(j)).^2+(y(i)-y(j)).^2);
ind = find(i==j); 
r1(ind) = b*ones(size(ind));
r2 = sqrt((x(i)-x(j)).^2+(y(i)+y(j)).^2);

% Calcula a matriz s (por metro de comprimento do sistema – no eixo z)
s = log(r2./r1)/2/pi/eps;

% Define o potencial eletrico no eixo de cada cilindro de carga, que deve
% ser igual ao do corpo sobre o qual ele se situa (monta a matriz phi)
V = 1;

phi = [ones(K1,1)*V; zeros(K2,1); zeros(K3,1)]; 
rhoL = s\phi;
Q11 = sum(rhoL(1:K1));
Q12 = sum(rhoL(K1:(K1+K2)));
Q13 = sum(rhoL((K1+K2):(K1+K2+K3)));
C11 = Q11/V
C12 = Q12/V
C13 = Q13/V

phi = [zeros(K1,1); ones(K2,1)*V; zeros(K3,1)]; 
rhoL = s\phi;
Q21 = sum(rhoL(1:K1));
Q22 = sum(rhoL(K1:(K1+K2)));
Q23 = sum(rhoL((K1+K2):(K1+K2+K3)));
C21 = Q11/V
C22 = Q12/V
C23 = Q13/V

phi = [zeros(K1,1); zeros(K2,1); ones(K3,1)*V]; 
rhoL = s\phi;
Q31 = sum(rhoL(1:K1));
Q32 = sum(rhoL(K1:(K1+K2)));
Q33 = sum(rhoL((K1+K2):(K1+K2+K3)));
C31 = Q11/V
C32 = Q12/V
C33 = Q13/V

Cpc10 = C11 + C12 + C13
Cpc20 = C21 + C22 + C23
Cpc30 = C31 + C32 + C33
Cpc12 = -C12
Cpc21 = -C21
Cpc13 = -C13
Cpc31 = -C31
Cpc23 = -C23
Cpc32 = -C32
