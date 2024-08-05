t = 0:1/2000:1-1/2000;
dt = 1/2000;
x1 = sin(50*pi*t).*exp(-50*pi*(t-0.2).^2);
x2 = sin(50*pi*t).*exp(-100*pi*(t-0.5).^2);
x3 = 2*cos(140*pi*t).*exp(-50*pi*(t-0.2).^2);
x4 = 2*sin(140*pi*t).*exp(-80*pi*(t-0.8).^2);
x = x1+x2+x3+x4;
plot(t,x)
grid on;
title('叠加信号')

cwt(x,2000);
title('使用默认Morse小波的解析CWT');

[cfs,f] = cwt(x,2000);
T1 = .07;  T2 = .33;
F1 = 19;   F2 = 34;
cfs(f > F1 & f < F2, t> T1 & t < T2) = 0;
xrec = icwt(cfs);

subplot(2,1,1);
plot(t,x);
grid on;
title('原始信号');
subplot(2,1,2);
plot(t,xrec)
grid on;
title('第一个25Hz分量被移除的信号');

y = x2+x3+x4;
figure;
plot(t,xrec)
hold on
plot(t,y,'r--')
grid on;
legend('逆CWT近似','删除25Hz分量后的原始信号');
hold off