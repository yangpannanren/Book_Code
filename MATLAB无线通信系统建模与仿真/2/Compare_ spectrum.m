load relatedsig
Fs = FsSig;
[P1,f1] = periodogram(sig1,[],[],Fs,'power');
[P2,f2] = periodogram(sig2,[],[],Fs,'power');
subplot(2,1,1)
plot(f1,P1,'k')
grid
ylabel('P_1')
title('功率谱')
subplot(2,1,2)
plot(f2,P2,'r')
grid
ylabel('P_2')
xlabel('频率(Hz)')

[pk1,lc1] = findpeaks(P1,'SortStr','descend','NPeaks',3);
P1peakFreqs = f1(lc1)

[pk2,lc2] = findpeaks(P2,'SortStr','descend','NPeaks',3);
P2peakFreqs = f2(lc2)


figure
plot(f,Cxy)
ax = gca;
grid
xlabel('频率(Hz)')
title('一致性估计')
ax.XTick = MatchingFreqs;
ax.YTick = thresh;
axis([0 200 0 1])