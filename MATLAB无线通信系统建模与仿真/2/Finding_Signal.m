
data = sin(2*pi*(0:25)/16);
%想要找到信号的位置
signal = cos(2*pi*(0:10)/16);
%strfind无法在从第5个样本开始的数据中定位正弦信号
iStart = strfind(data,signal)


%strfind无法在数据中找到信号，因为由于舍入误差，不是所有的值在数字上都相等。为了看到这一点，从匹配区域的信号中减去数据。
data(5:15) - signal

findsignal(data,signal)

data = sin(2*pi*(0:100)/16);
signal = cos(2*pi*(0:10)/16);
findsignal(data,signal,'MaxDistance',1e-14)

[iStart, iStop, distance] = findsignal(data,signal,'MaxDistance',1e-14);
fprintf('iStart iStop  total squared distance\n')

fprintf('%4i %5i     %.7g\n',[iStart; iStop; distance])



load cursiveex
plot(data)
xlabel('实轴')
ylabel('虚轴')
plot(signal)
title('signal')
xlabel('real')
ylabel('imag')
findsignal(data,signal)
findsignal(data,signal,'TimeAlignment','dtw', ...
               'Normalization','center', ...
               'NormalizationLength',600, ...
               'MaxNumSegments',2)
           
           
load slogan
soundsc(phrase,fs)
soundsc(hotword,fs)

Nwindow = 64;
Nstride = 8;
Beta = 64;

Noverlap = Nwindow - Nstride;
[~,~,~,PxxPhrase] = spectrogram(phrase, kaiser(Nwindow,Beta), Noverlap);
[~,~,~,PxxHotWord] = spectrogram(hotword, kaiser(Nwindow,Beta), Noverlap);

[istart,istop] = findsignal(PxxPhrase, PxxHotWord, ...
    'Normalization','power','TimeAlignment','dtw','Metric','symmkl')

findsignal(PxxPhrase, PxxHotWord, 'Normalization','power', ...
    'TimeAlignment','dtw','Metric','symmkl')
soundsc(phrase(Nstride*istart-Nwindow/2 : Nstride*istop+Nwindow/2),fs)
           