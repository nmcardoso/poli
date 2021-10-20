%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Parâmetros de entrada do simulink
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K = 54.93; % K (exp. 2)
Kt = 0.0169; % Kt (exp. 2)
T = 0.28; % T (exp. 2)
Kp = 1.59; % Kp (exp. 2)
KNL = 59.85; % K não-linear (exp. 4)
phi = 1.25; % phi (exp. 4)
n = 1 / 3;
phi = 1.9; % atrito de Coulomb
tr = [0.3 0.5 1]; % tempos de subida (exp. 7)
Kcs = [0.5 1 1.5]; % Kcs (exp. 7)
Kc = Kcs(2);
KKt = K*Kt;
KtL = KKt / K; % Kt linear
KtNL = KKt / KNL; % Kt não-linear
Kpi = 0.661 ./ tr;
U = Kp * pi / 2; % amplitude do degrau, equivalente a 90deg em volts



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Item (e)
%%% Plot do lugar geométrico das raízes para os três casos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ti = T - 0.08;
Gma = tf([Kpi(1)*KKt*Ti Kpi(1)*KKt], [T*Ti Ti 0]);
figure;
rlocus(Gma)
title('LGR (T > Ti)');
xlim([-12 1]);

Ti = T + 0.08;
Gma = tf([Kpi(1)*KKt*Ti Kpi(1)*KKt], [T*Ti Ti 0]);
figure;
rlocus(Gma)
title('LGR (T < Ti)');
xlim([-12 1]);

Ti = T;
Gma = tf([Kpi(1)*KKt], [T 0]);
figure;
rlocus(Gma)
title('LGR (T = Ti)');
xlim([-12 1]);


% Resposta ao degrau
% opt = stepDataOptions('StepAmplitude', U);
% Wn = sqrt((Kc * K * Kp * n^2) / T);
% xi = 1 / (2 * Wn * T);
% Mp = exp((-pi * xi) / sqrt(1 - xi^2));
% tp = pi / (Wn * sqrt(1 - xi^2));

% % Gma = tf(Kc * K * Kp * n^2, [T 1 0]);
% Gmf = tf(Wn^2, [1 2*xi*Wn Wn^2]);
% step(Gmf, opt);

% data = ['CtrlPos_P_Kc05.mat' 'CtrlPos_P_Kc10.mat' 'CtrlPos_P_Kc15.mat'];
% Controle de posição: resposta ao degrau de 90deg

