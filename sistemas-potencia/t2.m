d2r = @(x) (x*pi/180);
r2d = @(x) (x*180/pi);
cis = @(x) exp(j*x);
cisd = @(x) cis(d2r(x));
angled = @(x) r2d(angle(x));
to_rd = @(m, d) (m .* cisd(d));
to_pd = @(x) [abs(x) angled(x)];

Vl = 460;
Zl = 0.8 + j*1.2;
Za = 32 + j*16;
Zb = 36 + j*15;
Zc = 31 + j*12;
Zn = 0;
%Zn = 5;

Vf = Vl / sqrt(3);

alpha_pos = [to_rd(1, 0); to_rd(1, -120); to_rd(1, 120)];
alpha_neg = [to_rd(1, 0); to_rd(1, 120); to_rd(1, -120)];

V_pos = Vf * alpha_pos
V_neg = Vf * alpha_neg

Z = [[Zn + Zl + Za, Zn, Zn];
     [Zn, Zn + Zl + Zb, Zn];
     [Zn, Zn, Zn + Zl + Zc]]
       
I_pos = linsolve(Z, V_pos);
I_neg  = linsolve(Z, V_neg);

Ia_ef = abs(I_pos(1))
Ib_ef = abs(I_pos(2))
Ic_ef = abs(I_pos(3))

In_pos_ef = abs(I_pos(1) + I_pos(2) + I_pos(3))
In_neg_ef = abs(I_neg(1) + I_neg(2) + I_neg(3))




