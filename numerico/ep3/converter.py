exp = '- t^4 + 2*t^3 - t^2 + 7220*t + 5863/20'
print(exp.replace('erf', 'sp.erf').replace('exp', 'sp.exp').replace('pi', 'sp.pi').replace('^', '**'))
