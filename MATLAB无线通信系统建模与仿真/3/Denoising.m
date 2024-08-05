rng default;
[X,XN] = wnoise('bumps',10,sqrt(6));
subplot(211)
plot(X); title('原始信号');
AX = gca;
AX.YLim = [0 12];
subplot(212)
plot(XN); title('噪声信号');
AX = gca;
AX.YLim = [0 12];

xd = wdenoise(XN,4);
figure;
plot(X,'k-.')
hold on;
plot(xd)
legend('原始信号','降噪信号','Location','NorthEastOutside')
axis tight;
hold off;


xdMODWT = wden(XN,'modwtsqtwolog','s','mln',4,'sym4');
figure;
plot(X,'b-.')
hold on;
plot(xdMODWT)
legend('原始信号','降噪信号')
axis tight;hold off;


load('jump.mat')
wdenoise2(jump)
subplot(121);title('原始图像');
subplot(122);title('降噪图像')