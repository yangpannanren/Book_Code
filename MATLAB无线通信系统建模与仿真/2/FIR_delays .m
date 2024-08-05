load ecgSignals
Fs = 500;
N = 500;
rng default
xn = ecgl(N)+0.25*randn([1 N]);
tn = (0:N-1)/Fs;
nfilt = 70;
Fst = 75;

d = designfilt('lowpassfir','FilterOrder',nfilt, ...
               'CutoffFrequency',Fst,'SampleRate',Fs);
xf = filter(d,xn);
plot(tn,xn)
hold on, plot(tn,xf,'--r','linewidth',1.5), hold off
title '心电图'
xlabel '时间(s)', legend('原始信号','滤波后信号')

grpdelay(d,N,Fs)
delay = mean(grpdelay(d))

tt = tn(1:end-delay);
sn = xn(1:end-delay);

sf = xf;
sf(1:delay) = [];
%对信号绘图，并验证它们是否对齐。
plot(tt,sn)
hold on, plot(tt,sf,'--r','linewidth',1.5), hold off
title '心电图'
xlabel('时间(s)'), legend('原始信号','滤波后的信号')