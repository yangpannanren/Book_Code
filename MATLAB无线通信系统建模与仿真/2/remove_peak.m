load openloop60hertz
fs = 1000;
t = (0:numel(openLoopVoltage) - 1)/fs;

rng default  %重置随机
spikeSignal = zeros(size(openLoopVoltage));
spks = 10:100:1990;
spikeSignal(spks+round(2*randn(size(spks)))) = sign(randn(size(spks)));
noisyLoopVoltage = openLoopVoltage + spikeSignal;
plot(t,noisyLoopVoltage)

xlabel('时间(s)')
ylabel('电压(V)')
title('带尖峰的开环电压')
yax = ylim;

medfiltLoopVoltage = medfilt1(noisyLoopVoltage,3);
plot(t,medfiltLoopVoltage)
xlabel('时间(s)')
ylabel('电压(V)')
title('中值滤波后的开环电压')
ylim(yax)
grid