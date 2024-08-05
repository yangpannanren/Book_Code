F = [0 0.2500 0.5000 0.7500 1.0000];
A = [1.00 0.6667 0.3333 0 0];
Order = 511;
B1 = fir2(Order,F,A);
[Hx,W] = freqz(B1,1,8192,'whole');
Hx = [Hx(4098:end) ; Hx(1:4097)];
omega = -pi+(2*pi/8192):(2*pi)/8192:pi;

plot(omega,abs(Hx))
xlim([-pi pi])
grid
title('光频谱')
xlabel('弧度/样本')
ylabel('光度')

y = downsample(B1,2,0);
[Hy,W] = freqz(y,1,8192,'whole');
Hy = [Hy(4098:end) ; Hy(1:4097)];

hold on
plot(omega,abs(Hy),'r-.','linewidth',2)
legend('原始信号','下采样信号')
text(-2.5,0.35,'\downarrow 混叠','HorizontalAlignment','center')
text(2.5,0.35,'混叠\downarrow','HorizontalAlignment','center')
hold off


F = [0 0.2500 0.5000 0.7500 7/8 1.0000];
A = [1.00 0.7143 0.4286 0.1429 0 0];
Order = 511;
B2 = fir2(Order,F,A);

[Hx,W] = freqz(B2,1,8192,'whole');
Hx = [Hx(4098:end) ; Hx(1:4097)];
omega = -pi+(2*pi/8192):(2*pi)/8192:pi;

plot(omega,abs(Hx))
xlim([-pi pi])

y = downsample(B2,2,0);
[Hy,W] = freqz(y,1,8192,'whole');
Hy = [Hy(4098:end) ; Hy(1:4097)];

hold on
plot(omega,abs(Hy),'r-.','linewidth',2)
grid
legend('原始信号','下采样信号')
xlabel('弧度/样本')
ylabel('光度')
hold off


F = [0 0.250 0.500 0.7500 1];
A = [1.0000 0.5000 0 0 0];
Order = 511;
B3 = fir2(Order,F,A);
[Hx,W] = freqz(B3,1,8192,'whole');
Hx = [Hx(4098:end) ; Hx(1:4097)];
omega = -pi+(2*pi/8192):(2*pi)/8192:pi;
plot(omega,abs(Hx))
xlim([-pi pi])
y = downsample(B3,2,0);
[Hy,W] = freqz(y,1,8192,'whole');
Hy = [Hy(4098:end) ; Hy(1:4097)];
plot(omega,abs(Hx))
hold on
plot(omega,abs(Hy),'r-.','linewidth',2)
grid
legend('原始信号','下采样信号')
xlabel('弧度/样本')
ylabel('光度')
hold off