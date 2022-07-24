syms y(t);

eqval = diff(y, t, 2) == 12*t*(1-t)-2;
eq1 = -3.6*diff(y, t, 2) == 5;
eq2 = -3.6*diff(y, t, 2) == 60*exp(-(t-20/2)^2 / 5.5^2) - 35;
eq3 = -3.6*diff(y, t, 2) == (60-40)*exp(-(t-20/2)^2 / 4^2);
eq31 = -3.6*diff(y, t, 2) == 60*exp(-(t-20/2)^2 / 3^2) - (-40)*exp(-(t-20/2)^2 / 4.5^2);
eq4 = -3.6*diff(y, t, 2) == 50*exp(-(t-20/2)^2 / 1.3^2) - 45*(exp(-(t)^2 / 2.2^2) + exp(-(t-20)^2 / 2.2^2));

cond1 = y(0) == 293.15;
cond2 = y(20) == 293.15;
conds = [cond1 cond2];

ySol(t) = dsolve(eqval, conds);
ySol = simplify(ySol)
exit;
