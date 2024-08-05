load mtlb
%MAT文件包含语音波形mtlb和采样频率Fs。使用spectrogram函数识别一个浊音段进行分析。
segmentlen = 100;
noverlap = 90;
NFFT = 128;
spectrogram(mtlb,segmentlen,noverlap,NFFT,Fs,'yaxis')
title('信号频谱')

dt = 1/Fs;
I0 = round(0.1/dt);
Iend = round(0.25/dt);
x = mtlb(I0:Iend);

x1 = x.*hamming(length(x));

preemph = [1 0.63];
x1 = filter(1,preemph,x1);

A = lpc(x1,8);
rts = roots(A);

rts = rts(imag(rts)>=0);
angz = atan2(imag(rts),real(rts));

[frqs,indices] = sort(angz.*(Fs/(2*pi)));
bw = -1/2*(Fs/(2*pi))*log(abs(rts(indices)));

nn = 1;
for kk = 1:length(frqs)
    if (frqs(kk) > 90 && bw(kk) <400)
        formants(nn) = frqs(kk);
        nn = nn+1;
    end
end
formants