k = 0:2;
rk = (24/5)*2.^(-k)-(27/10)*3.^(-k);

A = ac2poly(rk);

zplane(A,1)
grid

zplane(1,A)
grid
title('极点与零点')

rng default

x = randn(1000,1);
y = filter(1,A,x);

[xc,lags] = xcorr(y,2,'biased');
[xc(3:end) rk']