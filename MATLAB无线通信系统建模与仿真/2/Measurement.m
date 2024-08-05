load('Ring.mat')
Time = 0:1/Fs:(length(y)-1)/Fs; 
m = min(y);
M = max(y);
Full_sig = double(y);
timeA = 7;
timeB = 8;
snip = timeA*Fs:timeB*Fs;
Fragment = Full_sig(snip);
%听，输入soundsc(片段，Fs)
%绘制信号和碎片，突出显示片段端点以供参考
plot(Time,Full_sig,[timeA timeB;timeA timeB],[m m;M M],'r--')
xlabel('时间(s)')
ylabel('清理')
axis tight

plot(snip/Fs,Fragment)
xlabel('时间(s)')
ylabel('清理')
title('片段')
axis tight

[xCorr,lags] = xcorr(Full_sig,Fragment);
plot(lags/Fs,xCorr)  %效果如图2-79所示。
grid
xlabel('滞后 (s)')
ylabel('清理')
axis tight

[~,I] = max(abs(xCorr));
maxt = lags(I);
Trial = NaN(size(Full_sig));
Trial(maxt+1:maxt+length(Fragment)) = Fragment;
plot(Time,Full_sig,Time,Trial)
xlabel('时间(s)')
ylabel('清理')
axis tight

NoiseAmp = 0.2*max(abs(Fragment));
Fragment = Fragment+NoiseAmp*randn(size(Fragment));
Full_sig = Full_sig+NoiseAmp*randn(size(Full_sig));
% 听，输入soundsc(片段，Fs)
plot(Time,Full_sig,[timeA timeB;timeA timeB],[m m;M M],'r--')
xlabel('时间 (s)')
ylabel('噪声')
axis tight

[xCorr,lags] = xcorr(Full_sig,Fragment);
plot(lags/Fs,xCorr)
grid
xlabel('滞后 (s)')
ylabel('噪声')
axis tight

[~,I] = max(abs(xCorr));
maxt = lags(I);

Trial = NaN(size(Full_sig));
Trial(maxt+1:maxt+length(Fragment)) = Fragment;

figure
plot(Time,Full_sig,Time,Trial)
xlabel('时间 (s)')
ylabel('噪声')
axis tight