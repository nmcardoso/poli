% Funções suporte
d2r = @(x) (x*pi/180);
r2d = @(x) (x*180/pi);
cis = @(x) exp(j*x);
cisd = @(x) cis(d2r(x));
angled = @(x) r2d(angle(x));
to_rd = @(m, d) (m .* cisd(d));
to_pd = @(x) [abs(x) angled(x)];

alpha = to_rd(1, 120);

% Dados PARTE 1
z0_at1 = 0.12j;
z1_at1 = 0.06j;
z2_at1 = 0.06j;

v0_at1 = 0;
v1_at1 = 0.94;
v2_at1 = 0;

% DADOS PARTE 2
z0_at2 = 0.07j;
z1_at2 = 0.07j;
z2_at2 = 0.07j;

v0_at2 = 0;
v1_at2 = 1.05;
v2_at2 = 0;


T = [
  1, 1, 1;
  1, alpha**2, alpha;
  1, alpha, alpha**2
];



disp("Alternativa (b)")

ia0 = v1_at1 / (z0_at1 + z1_at1 + z2_at1);
modulo = abs(3 * ia0);
fase = angle(3 * ia0);

if(fase > 0)
  fase_str = "adiantada";
else
  fase_str = "atrasada";
endif
printf("Módulo da corrente da fase envolvida no defeito: %.6f (%s)\n", modulo, fase_str)

ia = 0;
i1 = v1_at1 / (z1_at1 + ((z0_at1 * z2_at1) / (z0_at1 + z2_at1)));

vx = v1_at1 - (i1) * z1_at1;
i2 = -vx/z2_at1;
i0 = -vx/z0_at1;

iabc = T * [i0; i1; i2];

iB = iabc(2, 1);
iC = iabc(3, 1);
iNeutro = iB + iC;

