lte3d = lte3DChannel.makeCDL('CDL-B');
lte3d.MaximumDopplerShift = 300.0;
lte3d.SampleRate = 10e3;
lte3d.Seed = 19;

lte3d.TransmitAntennaArray.Size = [1 1 1];
lte3d.ReceiveAntennaArray.Size = [1 1 1];

T = 40; 
in = ones(T,1); 

s = [Inf 5 2]; %样本密度
legends = {};
figure; hold on;
SR = lte3d.SampleRate;
for i = 1:length(s)      
    % 使用选定的样本密度调用信道
    release(lte3d); lte3d.SampleDensity = s(i);
    [out,pathgains,sampletimes] = lte3d(in);
    chInfo = info(lte3d); tau = chInfo.ChannelFilterDelay;
      
    % 绘制通道输出时间
    t = lte3d.InitialTime + ((0:(T-1)) - tau).' / SR;
    h = plot(t,abs(out),'o-'); h.MarkerSize = 2; h.LineWidth = 1.5;
    desc = ['Sample Density=' num2str(s(i))];
    legends = [legends ['Output, ' desc]];
    disp([desc ', Ncs=' num2str(length(sampletimes))]);      
    % 根据样本时间绘制路径增益
    h2 = plot(sampletimes - tau/SR,abs(sum(pathgains,2)),'o');
    h2.Color = h.Color; h2.MarkerFaceColor = h.Color;
    legends = [legends ['Path Gains, ' desc]];      
end
xlabel('时间(s)');
title('相对于样本密度的通道输出和路径增益');
ylabel('通道幅度');
legend(legends,'Location','NorthWest'); 