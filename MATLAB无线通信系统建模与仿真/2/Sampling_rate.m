Fs = 44.1e3;
t = 0:1/Fs:1-1/Fs;
x = cos(2*pi*2000*t)+1/2*sin(2*pi*4000*(t-pi/4))+1/4*cos(2*pi*8000*t);

[P,Q] = rat(48e3/Fs);
abs(P/Q*Fs-48000)

xnew = resample(x,P,Q);

load mtlb
[P,Q] = rat(8192/Fs);
mtlb_new = resample(mtlb,P,Q);

subplot(2,1,1)
plot((0:length(mtlb)-1)/Fs,mtlb)
subplot(2,1,2)
plot((0:length(mtlb_new)-1)/(P/Q*Fs),mtlb_new)


