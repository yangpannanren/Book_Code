rng default
L = 1000;
x = randn(L,1);
[xc,lags] = xcorr(x,20,'coeff');

vcrit = sqrt(2)*erfinv(0.95)

lconf = -vcrit/sqrt(L);
upconf = vcrit/sqrt(L);
%绘制样本自相关和 95% 置信区间。
stem(lags,xc,'filled')
hold on
plot(lags,[lconf;upconf]*ones(size(lags)),'r-.')
hold off
ylim([lconf-0.03 1.05])
title('用95%的置信区间样本自相关')