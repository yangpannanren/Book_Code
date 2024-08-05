tdl = nrTDLChannel;
tdl.DelayProfile = 'TDL-C';
tdl.DelaySpread = 100e-9;
%创建一个持续时间为1个子帧的随机波形。
tdlInfo = info(tdl);
Nt = tdlInfo.NumTransmitAntennas;
in = complex(zeros(100,Nt),zeros(100,Nt));
%通过通道传输输入波形。
[~,pathGains] = tdl(in);
%获取通道过滤中使用的路径过滤器。
pathFilters = getPathFilters(tdl);
%估计时序偏移。
[offset,mag] = nrPerfectTimingEstimate(pathGains,pathFilters);
%绘制信道脉冲响应的幅度和定时偏移估计。
[Nh,Nr] = size(mag);
plot(0:(Nh-1),mag,'o:');
hold on;
plot([offset offset],[0 max(mag(:))*1.25],'k:','LineWidth',2);
axis([0 Nh-1 0 max(mag(:))*1.25]);
legends = "|h|, 附件" + num2cell(1:Nr);
legend([legends "时序偏移估计"]);
ylabel('|h|');
xlabel('通道脉冲响应样本');