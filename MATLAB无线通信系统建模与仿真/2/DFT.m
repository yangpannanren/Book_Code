clear all;
t = 0:1/100:10-1/100;                     % 时间序列
x = sin(2*pi*15*t) + sin(2*pi*40*t);      % 信号

y = fft(x);                               % 计算x的DFT
m = abs(y);                               % 幅值
y(m<1e-6) = 0;
p = unwrap(angle(y));                     % 相位

f = (0:length(y)-1)*100/length(y);        %频率向量
subplot(2,1,1)
plot(f,m)
title('幅度')
ax = gca;
ax.XTick = [15 40 60 85];
subplot(2,1,2)
plot(f,p*180/pi)
title('相位')
ax = gca;
ax.XTick = [15 40 60 85];

n = 512;
y = fft(x,n);
m = abs(y);
p = unwrap(angle(y));
f = (0:length(y)-1)*100/length(y);
subplot(2,1,1)
plot(f,m)
title('幅度')
ax = gca;
ax.XTick = [15 40 60 85];
subplot(2,1,2)
plot(f,p*180/pi)
title('相位')
ax = gca;
ax.XTick = [15 40 60 85];

t = 0:1/255:1;
x = sin(2*pi*120*t);
y = real(ifft(fft(x)));
figure
plot(t,x-y)