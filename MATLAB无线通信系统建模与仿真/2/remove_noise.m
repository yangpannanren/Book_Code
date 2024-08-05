load openloop60hertz, 
openLoop = openLoopVoltage;
Fs = 1000;
t = (0:length(openLoop)-1)/Fs;
plot(t,openLoop)
ylabel('电压 (V)')
xlabel('时间 (s)')
title('带有60Hz噪声的开环电压')
grid

d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',Fs);
fvtool(d,'Fs',Fs)

buttLoop = filtfilt(d,openLoop);

plot(t,openLoop,'.',t,buttLoop)
ylabel('电压 (V)')
xlabel('时间 (s)')
title('开环电压')
legend('未滤波前','滤波后')
grid

[popen,fopen] = periodogram(openLoop,[],[],Fs);
[pbutt,fbutt] = periodogram(buttLoop,[],[],Fs);

plot(fopen,20*log10(abs(popen)),fbutt,20*log10(abs(pbutt)),'--')
ylabel('功率/频率 (dB/Hz)')
xlabel('频率(Hz)')
title('功率谱')
legend('未滤波前','滤波后')
grid