b = fir1(1024, .5);
[d,p0] = lpc(b,7);

rng(0,'twister'); 
u = sqrt(p0)*randn(8192,1); %方差为p0的高斯白噪声
x = filter(1,d,u);

[d1,p1] = aryule(x,7);

[H1,w1] = freqz(sqrt(p1),d1);

periodogram(x)
hold on
hp = plot(w1/pi,20*log10(2*abs(H1)/(2*pi)),'r'); % Scale to make one-sided PSD
hp.LineWidth = 2;
xlabel('归一化频率(\times \pi rad/sample)')
ylabel('单侧PSD (dB/rad/sample)')
legend('x的PSD估计','模型输出的PSD')

[d2,p2] = lpc(x,7);
[d1.',d2.']

xh = filter(-d2(2:end),1,x);

cla
stem([x(2:end),xh(1:end-1)])
xlabel('样本时间')
ylabel('信号值')
legend('原始自回归信号','线性预测器的信号估计')
axis([0 200 -0.08 0.1])

p3 = norm(x(2:end)-xh(1:end-1),2)^2/(length(x)-1);