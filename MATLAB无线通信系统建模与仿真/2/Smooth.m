load bostemp
days = (1:31*24)/24;
plot(days, tempC)
axis tight
ylabel('温度(\circC)')
xlabel('时间从2018年1月1日开始 ')
title('洛根机场温度')

hoursPerDay = 24;
coeff24hMA = ones(1, hoursPerDay)/hoursPerDay;

avg24hTempC = filter(coeff24hMA, 1, tempC);
plot(days,[tempC avg24hTempC])
legend('每小时的温度','24小时平均(延迟)温度','location','best')
ylabel('温度(\circC)')
xlabel('时间从2018年1月1日开始 ')
title('洛根机场温度')

fDelay = (length(coeff24hMA)-1)/2;
plot(days,tempC, ...
     days-fDelay/24,avg24hTempC)
axis tight
legend('每小时的温度','24小时平均(延迟)温度','location','best')
ylabel('温度(\circC)')
xlabel('时间从2018年1月1日开始 ')
title('洛根机场温度')

figure
deltaTempC = tempC - avg24hTempC;
deltaTempC = reshape(deltaTempC, 24, 31).';

plot(1:24, mean(deltaTempC))
axis tight
title('24小时平均温度差')
xlabel('时间(从午夜开始)')
ylabel('温差(\circC)')

[envHigh, envLow] = envelope(tempC,16,'peak');
envMean = (envHigh+envLow)/2;

plot(days,tempC,':', ...
     days,envHigh,'r-.', ...
     days,envMean,'--', ...
     days,envLow)
   
axis tight
legend('每小时的温度','最高温度','平均温度','最低温度','location','best')
ylabel('温度(\circC)')
xlabel('时间从2018年1月1日开始 ')
title('洛根机场温度')


h = [1/2 1/2];
binomialCoeff = conv(h,h);
for n = 1:4
    binomialCoeff = conv(binomialCoeff,h);
end

figure
fDelay = (length(binomialCoeff)-1)/2;
binomialMA = filter(binomialCoeff, 1, tempC);
plot(days,tempC,'-.', ...
     days-fDelay/24,binomialMA)
axis tight
legend('每小时的温度','二项加权平均','location','best')
ylabel('温度(\circC)')
xlabel('时间从2018年1月1日开始 ')
title('洛根机场温度')

alpha = 0.45;
exponentialMA = filter(alpha, [1 alpha-1], tempC);
plot(days,tempC,'-.',...
     days-fDelay/24,binomialMA,'.', ...
     days-1/24,exponentialMA)

axis tight
legend('每小时的温度', ...
       '二项加权平均', ...
       '指数加权平均','location','best')
ylabel('温度(\circC)')
xlabel('时间从2018年1月1日开始 ')
title('洛根机场温度')


cubicMA   = sgolayfilt(tempC, 3, 7);
quarticMA = sgolayfilt(tempC, 4, 7);
quinticMA = sgolayfilt(tempC, 5, 9);
plot(days,[tempC cubicMA quarticMA quinticMA])
legend('每小时的温度','Cubic-Weighted平滑滤波器', 'Quartic-Weighted平滑滤波器', ...
       'Quintic-Weighted平滑滤波器','location','southeast')
ylabel('温度(\circC)')
xlabel('时间从2018年1月1日开始 ')
title('洛根机场温度')
axis([3 5 -5 2])

load openloop60hertz
fs = 1000;
t = (0:numel(openLoopVoltage)-1) / fs;
plot(t,openLoopVoltage)
ylabel('电压 (V)')
xlabel('时间(s)')
title('测量开环电压')

plot(t,sgolayfilt(openLoopVoltage,1,17))
ylabel('电压 (V)')
xlabel('时间(s)')
title('测量开环电压')
legend('移动平均滤波器工作在58.82 Hz', ...
       'Location','southeast')
   
   
fsResamp = 1020;
vResamp = resample(openLoopVoltage, fsResamp, fs);
tResamp = (0:numel(vResamp)-1) / fsResamp;
vAvgResamp = sgolayfilt(vResamp,1,17);
plot(tResamp,vAvgResamp)
ylabel('电压 (V)')
xlabel('时间(s)')
title('测量开环电压')
legend('移动平均滤波器工作在60Hz', ...
    'Location','southeast')


load clockex
yMovingAverage = conv(x,ones(5,1)/5,'same');
ySavitzkyGolay = sgolayfilt(x,3,5);
plot(t,x, ...
     t,yMovingAverage,'-.', ...
     t,ySavitzkyGolay,'.')
legend('原始信号 ','移动平均','Savitzky-Golay平滑')


yMedFilt = medfilt1(x,5,'truncate');
plot(t,x, ...
     t,yMedFilt,'-.')
legend('原始信号','中值滤波')

hold on
plot(medfilt1(y,3),'.')
hold off
legend('原始信号','滤波后信号')

hampel(y,13)
legend('location','best')