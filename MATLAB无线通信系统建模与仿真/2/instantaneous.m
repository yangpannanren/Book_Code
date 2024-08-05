fs = 1000;
t = 0:1/fs:2-1/fs;
y = chirp(t,100,1,200);

pspectrum(y,fs,'spectrogram')

z = hilbert(y);
instfrq = fs/(2*pi)*diff(unwrap(angle(z)));

clf
plot(t(2:end),instfrq)
ylim([0 fs/2])

instfreq(y,fs,'Method','hilbert')

fs = 1023;
t = 0:1/fs:2-1/fs;
x = sin(2*pi*60*t)+sin(2*pi*90*t);

pspectrum(x,fs,'spectrogram')
yticks([60 90])

z = hilbert(x);
instfrq = fs/(2*pi)*diff(unwrap(angle(z)));

plot(t(2:end),instfrq)
ylim([60 90])
xlabel('时间(s)')
ylabel('频率(Hz)')

instfreq(x,fs,'Method','hilbert')
[s,f,tt] = pspectrum(x,fs,'spectrogram');
numcomp = 2;
[fridge,~,lr] = tfridge(s,f,0.1,'NumRidges',numcomp);
pspectrum(x,fs,'spectrogram')
hold on
plot3(tt,fridge,abs(s(lr)),'LineWidth',4)
hold off
yticks([60 90])