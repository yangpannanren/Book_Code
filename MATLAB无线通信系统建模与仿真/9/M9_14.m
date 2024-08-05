 cdl = nrCDLChannel;
 cdl.DelayProfile = 'CDL-D';
 cdl.DelaySpread = 30e-9;
 cdl.MaximumDopplerShift = 5;
 
 %创建一个持续时间为 1 个子帧的随机波形。
 SR = 15.36e6;
T = SR*1e-3;
cdl.SampleRate = SR;
cdlInfo = info(cdl);
Nt = cdlInfo.NumTransmitAntennas;
in = complex(randn(T,Nt),randn(T,Nt));
%通过通道传输输入波形,获取通道过滤中使用的路径过滤器。
[~,pathGains,sampleTimes] = cdl(in);
pathFilters = getPathFilters(cdl);
%使用路径滤波器和路径增益执行时序偏移估计。
offset = nrPerfectTimingEstimate(pathGains,pathFilters);
%使用指定数量的块、子载波间距、时隙编号、定时偏移和采样时间执行完美的信道估计。
NRB = 25;
SCS = 15;
nSlot = 0;
hest = nrPerfectChannelEstimate(pathGains,pathFilters,...
    NRB,SCS,nSlot,offset,sampleTimes);
size(hest)
%绘制第一个接收天线的估计信道幅度响应。
figure;
surf(abs(hest(:,:,1)));
shading('flat');
xlabel('OFDM符号');
ylabel('副载波');
zlabel('|H|');
title('通道幅度响应');