rng default
x = randn(36,1);
x0 = downsample(x,3,0);
x1 = downsample(x,3,1);
x2 = downsample(x,3,2);
y0 = upsample(x0,3,0);
y1 = upsample(x1,3,1);
y2 = upsample(x2,3,2);
%绘制结果
subplot(4,1,1)
stem(x,'Marker','none')
title('原始信号')
ylim([-4 4])
subplot(4,1,2)
stem(y0,'Marker','none')
ylabel('相位0')
ylim([-4 4])
subplot(4,1,3)
stem(y1,'Marker','none')
ylabel('相位1')
ylim([-4 4])
subplot(4,1,4)
stem(y2,'Marker','none')
ylabel('相位2')
ylim([-4 4])


n = 0:127;
x = 2+cos(pi/4*n);
x0 = downsample(x,2,0);
x1 = downsample(x,2,1);
%对两个多相分量进行上采样。
y0 = upsample(x0,2,0);
y1 = upsample(x1,2,1);
%绘制上采样后的多相分量和原始信号以进行比较。
subplot(3,1,1)
stem(x,'Marker','none')
ylim([0.5 3.5])
title('原始信号')
subplot(3,1,2)
stem(y0,'Marker','none')
ylim([0.5 3.5])
ylabel('相位0')
subplot(3,1,3)
stem(y1,'Marker','none')
ylim([0.5 3.5])
ylabel('相位1')
