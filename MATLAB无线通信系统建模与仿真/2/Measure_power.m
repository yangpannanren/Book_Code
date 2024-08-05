N = 1200;
Fs = 1000;
t = (0:N-1)/Fs;
sigma = 0.01;
rng('default')
s = chirp(t,100,1,300)+sigma*randn(size(t));

pRMS = rms(s)^2

powbp = bandpower(s,Fs,[0 Fs/2])

obw(s,Fs);
[wd,lo,hi,power] = obw(s,Fs);
powtot = power/0.99

load AmpOutput
Fs = 3600;
y = y-mean(y);