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
phi = 1.2; % atrito de Coulomb
tr = [0.3 0.5 1]; % tempos de subida (exp. 7)
Kcs = [0.5 1 1.5]; % Kcs (exp. 7)
Kc = Kcs(2);
KKt = K*Kt;
KtL = KKt / K; % Kt linear
KtNL = KKt / KNL; % Kt não-linear
Kpi = 0.661 / tr(3);
% Kpi = 0.24;
U = Kp * pi / 2; % amplitude do degrau, equivalente a 90deg em volts
Ti = T;

item_e = false;
item_f = true;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Item (e)
%%% Plot do lugar geométrico das raízes para os três casos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if item_e
  Ti = T - 0.08;
  Gma = tf([Kpi*KKt*Ti Kpi*KKt], [T*Ti Ti 0]);
  figure;
  rlocus(Gma)
  title('LGR (T > Ti)');
  xlim([-12 1]);

  Ti = T + 0.08;
  Gma = tf([Kpi*KKt*Ti Kpi*KKt], [T*Ti Ti 0]);
  figure;
  rlocus(Gma)
  title('LGR (T < Ti)');
  xlim([-12 1]);

  Ti = T;
  Gma = tf([Kpi*KKt], [T 0]);
  figure;
  rlocus(Gma)
  title('LGR (T = Ti)');
  xlim([-12 1]);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Item (f)
%%% Resposta ao degrau e Vm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if item_f
  sim('modelo', 10);
  figure;
  hold on;
  plot(tsim, U_sim)
  plot(tsim, VmNL)
  plot(tsim, VmL)
  legend('Entrada', 'V_m não linear', 'V_m linear');
  grid on;
  hold off;


  figure;
  hold on;
  colors = {
    [0.8500 0.3250 0.0980], 
    [0.4660 0.6740 0.1880], 
    [0.4940 0.1840 0.5560]
  };
  plot(tsim, U_sim)
  for i = 1:3
    Kpi = 0.661 / tr(i);
    sim('modelo', 10);
    plot(tsim, Vt_simNL, '--', 'Color', colors{i}, 'LineWidth', 1.1);
    plot(tsim, Vt_simL, '-', 'Color', colors{i}, 'LineWidth', 1.1);
  end;
  ylim([0, U + 0.05]);
  legend('Entrada', 'V_t não linear (t_r = 0.3)', 'V_t linear (t_r = 0.3)', 'V_t não linear (t_r = 0.5)', 'V_t linear (t_r = 0.5)', 'V_t não linear (t_r = 1.0)', 'V_t linear (t_r = 1.0)');
  grid on;
  hold off;
  % opt = stepDataOptions('StepAmplitude', U);
  % Wn = sqrt((Kc * K * Kp * n^2) / T);
  % xi = 1 / (2 * Wn * T);
  % Mp = exp((-pi * xi) / sqrt(1 - xi^2));
  % tp = pi / (Wn * sqrt(1 - xi^2));

  % Gma = tf(Kc * K * Kp * n^2, [T 1 0]);
  % Gmf = tf(Wn^2, [1 2*xi*Wn Wn^2]);
  % step(Gma, opt);
end

% data = ['CtrlPos_P_Kc05.mat' 'CtrlPos_P_Kc10.mat' 'CtrlPos_P_Kc15.mat'];
% Controle de posição: resposta ao degrau de 90deg

