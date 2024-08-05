load(fullfile(matlabroot,'examples','signal','earthquake.mat'))
pwelch(drift,[],[],[],Fs)
Nf = 50; 
Fpass = 100; 
Fstop = 120;
d = designfilt('differentiatorfir','FilterOrder',Nf, ...
    'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
    'SampleRate',Fs);
fvtool(d,'MagnitudeDisplay','zero-phase','Fs',Fs)
dt = t(2)-t(1);

vdrift = filter(d,drift)/dt;
delay = mean(grpdelay(d))
tt = t(1:end-delay);
vd = vdrift;
vd(1:delay) = [];
tt(1:delay) = [];
vd(1:delay) = [];

[pkp,lcp] = findpeaks(drift);
zcp = zeros(size(lcp));
[pkm,lcm] = findpeaks(-drift);
zcm = zeros(size(lcm));
subplot(2,1,1)
plot(t,drift,t([lcp lcm]),[pkp -pkm],'or')
xlabel('时间 (s)')
ylabel('位移(cm)')
grid
subplot(2,1,2)
plot(tt,vd,t([lcp lcm]),[zcp zcm],'or')
xlabel('时间(s)')
ylabel('速度(cm/s)')
grid

adrift = filter(d,vdrift)/dt;
at = t(1:end-2*delay);
ad = adrift;
ad(1:2*delay) = [];
at(1:2*delay) = [];
ad(1:2*delay) = [];
subplot(2,1,1)
plot(tt,vd)
xlabel('时间(s)')
ylabel('速度(cm/s)')
grid
subplot(2,1,2)
plot(at,ad)
ax = gca;
ax.YLim = 2000*[-1 1];
xlabel('时间 (s)')
ylabel('加速度 (cm/s^2)')
grid

vdiff = diff([drift;0])/dt;
adiff = diff([vdiff;0])/dt;
subplot(2,1,1)
plot(at,ad)
ax = gca;
ax.YLim = 2000*[-1 1];
xlabel('时间 (s)')
ylabel('加速度 (cm/s^2)')
grid
legend('滤波')
title('微分滤波器加速')
subplot(2,1,2)
plot(t,adiff)
ax = gca;
ax.YLim = 2000*[-1 1];
xlabel('时间(s)')
ylabel('加速度 (cm/s^2)')
grid
legend('导数（diff）')