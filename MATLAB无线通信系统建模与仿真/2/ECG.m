load ecgSignals
t = (1:length(ecgl))';
subplot(2,1,1)
plot(t,ecgl), grid
title( '心电信号趋势'),ylabel('电压(mV)')
subplot(2,1,2)
plot(t,ecgnl), grid
xlabel('样本'), ylabel('电压(mV)')

dt_ecgl = detrend(ecgl);

opol = 6;
[p,s,mu] = polyfit(t,ecgnl,opol);
f_y = polyval(p,t,[],mu);
dt_ecgnl = ecgnl - f_y;
subplot(2,1,1)
plot(t,dt_ecgl), grid
title '去趋势ECG信号', ylabel '电压(mV)'

subplot(2,1,2)
plot(t,dt_ecgnl), grid
xlabel 样本, ylabel '电压(mV)'