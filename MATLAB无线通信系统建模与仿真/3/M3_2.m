load hychirp
plot(t,hychirp)
grid on
title('Signal')
axis tight
xlabel('时间(s)')
ylabel('幅值')

sigLen = numel(hychirp);
fchirp = fft(hychirp);
fr = Fs*(0:1/Fs:1-1/Fs);
plot(fr(1:sigLen/2),abs(fchirp(1:sigLen/2)),'x-')
xlabel('频率 (Hz)')
ylabel('幅值')
axis tight
grid on
xlim([0 200])


helperPlotSpectrogram(hychirp,t,Fs,200)


helperPlotSpectrogram(hychirp,t,Fs,50)


cwt(hychirp,Fs)


helperPlotScalogram3d(hychirp,Fs)

helperPlotScalogram(hychirp,Fs);
