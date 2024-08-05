load sunspot.dat  %载入数据
year = sunspot(:,1); 
relNums = sunspot(:,2);
findpeaks(relNums,year)
xlabel('年')
ylabel('太阳黑子数')
title('寻找所有的山峰')

findpeaks(relNums,year,'MinPeakProminence',40)
xlabel('年')
ylabel('太阳黑子数')
title('寻找最大的山峰')

figure
[pks, locs] = findpeaks(relNums,year,'MinPeakProminence',40);
peakInterval = diff(locs);
hist(peakInterval)
grid on
xlabel('年的间隔')
ylabel('发生的频率')
title('峰值间隔直方图(年)')

AverageDistance_Peaks = mean(diff(locs))

load clippedpeaks.mat
figure
%第一个图显示所有峰值
ax(1) = subplot(2,1,1);
findpeaks(saturatedData)
xlabel('样本')
ylabel('幅度')
title('检测饱和峰')
% 第二个图指定最小偏移
ax(2) = subplot(2,1,2);
findpeaks(saturatedData,'threshold',5)
xlabel('样本')
ylabel('幅度')
title('滤除饱和峰')
%链接并放大以显示更改
linkaxes(ax(1:2),'xy')
axis(ax,[50 70 0 250])


load noisyecg.mat
t = 1:length(noisyECG_withTrend);
figure
plot(t,noisyECG_withTrend)
title('有趋势的信号')
xlabel('样本');
ylabel('电压(mV)')
legend('带噪声的心电图信号')
grid on

[p,s,mu] = polyfit((1:numel(noisyECG_withTrend))',noisyECG_withTrend,6);
f_y = polyval(p,(1:numel(noisyECG_withTrend))',[],mu);
ECG_data = noisyECG_withTrend - f_y;        % 去趋势数据
figure
plot(t,ECG_data)
grid on
ax = axis;
axis([ax(1:2) -1.2 1.2])
title('去趋势ECG信号')
xlabel('样本');
ylabel('电压(mV)')
legend('去趋势ECG信号')

[~,locs_Rwave] = findpeaks(ECG_data,'MinPeakHeight',0.5,...
                                    'MinPeakDistance',200);
 ECG_inverted = -ECG_data;
[~,locs_Swave] = findpeaks(ECG_inverted,'MinPeakHeight',0.5,...
                                        'MinPeakDistance',200);

                                    figure
hold on 
plot(t,ECG_data)
plot(locs_Rwave,ECG_data(locs_Rwave),'rv','MarkerFaceColor','r')
plot(locs_Swave,ECG_data(locs_Swave),'rs','MarkerFaceColor','b')
axis([0 1850 -1.1 1.1])
grid on
legend('ECG信号','R波','S波')
xlabel('样本')
ylabel('电压(mV)')
title('在带噪声的ECG信号中的R波与S波')

smoothECG = sgolayfilt(ECG_data,7,21);
figure
plot(t,ECG_data,'b',t,smoothECG,'r')
grid on
axis tight
xlabel('样本')
ylabel('电压(mV)')
legend('带噪声的ECG信号','过滤后的信号')
title('过滤有噪声的心电信号')

[~,min_locs] = findpeaks(-smoothECG,'MinPeakDistance',40);
% 峰值在-0.2mV和-0.5mV之间
locs_Qwave = min_locs(smoothECG(min_locs)>-0.5 & smoothECG(min_locs)<-0.2);
figure
hold on
plot(t,smoothECG); 
plot(locs_Qwave,smoothECG(locs_Qwave),'rs','MarkerFaceColor','g')
plot(locs_Rwave,smoothECG(locs_Rwave),'rv','MarkerFaceColor','r')
plot(locs_Swave,smoothECG(locs_Swave),'rs','MarkerFaceColor','b')
grid on
title('信号中的阈值峰值')
xlabel('样本')
ylabel('电压(mV)')
ax = axis;
axis([0 1850 -1.1 1.1])
legend('平滑ECG信号','Q波','R波','S波')

%极值的值
[val_Qwave, val_Rwave, val_Swave] = deal(smoothECG(locs_Qwave), smoothECG(locs_Rwave), smoothECG(locs_Swave));
meanError_Qwave = mean((noisyECG_withTrend(locs_Qwave) - val_Qwave))
meanError_Rwave = mean((noisyECG_withTrend(locs_Rwave) - val_Rwave))
meanError_Swave = mean((noisyECG_withTrend(locs_Swave) - val_Swave))

avg_riseTime = mean(locs_Rwave-locs_Qwave); % Average Rise time
avg_fallTime = mean(locs_Swave-locs_Rwave); % Average Fall time
avg_riseLevel = mean(val_Rwave-val_Qwave);  % Average Rise Level
avg_fallLevel = mean(val_Rwave-val_Swave);  % Average Fall Level

helperPeakAnalysisPlot(t,smoothECG,...
                    locs_Qwave,locs_Rwave,locs_Swave,...
                    val_Qwave,val_Rwave,val_Swave,...
                    avg_riseTime,avg_fallTime,...
                    avg_riseLevel,avg_fallLevel)
title('ECG信号中的ORS复合体')
xlabel('样本')
ylabel('电压(mV)')