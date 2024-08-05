load officetemp
tempC = (temp-32)*5/9;
tempnorm = tempC-mean(tempC);
fs = 2*24;
t = (0:length(tempnorm) - 1)/fs;
plot(t,tempnorm)
xlabel('时间(天)')
ylabel('温度 ( {}^\circC )')
axis tight

[autocor,lags] = xcorr(tempnorm,3*7*fs,'coeff');

plot(lags/fs,autocor)
xlabel('滞后(天)')
ylabel('自相关')
axis([-21 21 -0.4 1.1])
[pksh,lcsh] = findpeaks(autocor);
short = mean(diff(lcsh))/fs

[pklg,lclg] = findpeaks(autocor, ...
    'MinPeakDistance',ceil(short)*fs,'MinPeakheight',0.3);
long = mean(diff(lclg))/fs

hold on
pks = plot(lags(lcsh)/fs,pksh,'or', ...
    lags(lclg)/fs,pklg+0.05,'vk');
hold off
legend(pks,[repmat('Period: ',[2 1]) num2str([short;long],0)])
axis([-21 21 -0.4 1.1])