rng default
Fs = 1000;
t = 0:1/Fs:1-1/Fs;
x = cos(2*pi*100*t) + sin(2*pi*200*t) + 0.5*randn(size(t));
y = 0.5*cos(2*pi*100*t - pi/4) + 0.35*sin(2*pi*200*t - pi/2) + 0.5*randn(size(t));

[Cxy,F] = mscohere(x,y,hamming(100),80,100,Fs);
plot(F,Cxy)
title('平方的一致性')
xlabel('频率(Hz)')
grid

[Pxy,F] = cpsd(x,y,hamming(100),80,100,Fs);
Pxy(Cxy < 0.2) = 0;
plot(F,angle(Pxy)/pi)
title('交叉谱相位')
xlabel('频率(Hz)')
ylabel('滞后 (\times\pi rad)')
grid