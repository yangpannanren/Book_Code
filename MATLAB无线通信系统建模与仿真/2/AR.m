A = [1 1.5 0.75];
rng default  %设置重复性
x = filter(1,A,randn(1000,1));
%查看AR(2)过程的频率响应
freqz(1,A)

figure
for k = 1:4
    subplot(2,2,k)
    plot(x(1:end-k),x(k+1:end),'*')
    xlabel('X_1')
    ylabel(['X_' int2str(k+1)])
    grid
end

[xc,lags] = xcorr(x,50,'coeff');
figure
stem(lags(51:end),xc(51:end),'filled')
xlabel('Lag')
ylabel('[xc,lags] = xcorr(x,50,'coeff');
figure
stem(lags(51:end),xc(51:end),'filled')
xlabel('滞后')
ylabel('序列')
title('样本自相关序列')
grid')
title('样本自相关序列')
grid

[arcoefs,E,K] = aryule(x,15);
pacf = -K;

stem(pacf,'filled')
xlabel('滞后')
ylabel('偏自相关函数')
title('偏自相关序列')
xlim([1 15])
conf = sqrt(2)*erfinv(0.95)/sqrt(1000);
hold on
plot(xlim,[1 1]'*[-conf conf],'r')
hold off
grid