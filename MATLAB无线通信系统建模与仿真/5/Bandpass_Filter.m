Ro = 50;
f1C = 2400e6;
f2C = 2500e6;

Ls = (Ro / (pi*(f2C - f1C)))/2;
Cs = 2*(f2C - f1C)/(4*pi*Ro*f2C*f1C);

Lp = 2*Ro*(f2C - f1C)/(4*pi*f2C*f1C);
Cp = (1/(pi*Ro*(f2C - f1C)))/2;

ckt = circuit('butterworthBPF');

add(ckt,[3 2],inductor(Ls))
add(ckt,[4 3],capacitor(Cs))
add(ckt,[5 4],capacitor(Cs))
add(ckt,[6 5],inductor(Ls))

add(ckt,[4 1],capacitor(Cp))
add(ckt,[4 1],inductor(Lp))
add(ckt,[4 1],inductor(Lp))
add(ckt,[4 1],capacitor(Cp))

freq = linspace(2e9,3e9,101);
setports(ckt,[2 1],[6 1])
S = sparameters(ckt,freq);

tfS = s2tf(S);
fit = rationalfit(freq,tfS);

widerFreqs = linspace(2e8,5e9,1001);
resp = freqresp(fit,widerFreqs);
figure
semilogy(freq,abs(tfS),widerFreqs,abs(resp),'--','LineWidth',2)
xlabel('频率(Hz)')
ylabel('幅度')
legend('数据','拟合')
title('合理拟合在拟合频率范围外表现效果')


fCenter = 2.45e9;
fBlocker = 2.35e9;
period = 1/fCenter;
sampleTime = period/16;
signalLen = 8192;
t = (0:signalLen-1)'*sampleTime; % 256周期

input = sin(2*pi*fCenter*t);     %清除输入信号
rng('default')
noise = randn(size(t)) + sin(2*pi*fBlocker*t);
noisyInput = input + noise;      % 输入噪声信号

output = timeresp(fit,noisyInput,sampleTime);


xmax = t(end)/8;
figure
subplot(3,1,1)
plot(t,input)
axis([0 xmax -1.5 1.5])
title('输入信号')

subplot(3,1,2)
plot(t,noisyInput)
axis([0 xmax floor(min(noisyInput)) ceil(max(noisyInput))])
title('噪声输入信号')
ylabel('振幅 (volts)')

subplot(3,1,3)
plot(t,output)
axis([0 xmax -1.5 1.5])
title('带通滤波器输出')
xlabel('时间(sec)')


NFFT = 2^nextpow2(signalLen); % Next power of 2 from length of y
Y = fft(noisyInput,NFFT)/signalLen;
samplingFreq = 1/sampleTime;
f = samplingFreq/2*linspace(0,1,NFFT/2+1)';
O = fft(output,NFFT)/signalLen;

figure
subplot(2,1,1)
plot(freq,abs(tfS),'b','LineWidth',2)
axis([freq(1) freq(end) 0 1.1])
legend('滤波器的传递函数')
ylabel('幅度')

subplot(2,1,2)
plot(f,2*abs(Y(1:NFFT/2+1)),'g',f,2*abs(O(1:NFFT/2+1)),'r','LineWidth',2)
axis([freq(1) freq(end) 0 1.1])
legend('输入+噪声','输出')
title('滤波器特性和噪声输入频谱.')
xlabel('频率(Hz)')
ylabel(' 电压(Volts)')