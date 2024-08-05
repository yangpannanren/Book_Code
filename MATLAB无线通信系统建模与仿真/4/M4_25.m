chan = comm.MIMOChannel('SampleRate',1000,'PathDelays',[0 1.5e-3], ...
    'AveragePathGains',[1 0.8],'RandomStream','mt19937ar with seed', ...
    'Seed',10,'PathGainsOutputPort',true); 
chanInfo = info(chan);
pathFilters = chanInfo.ChannelFilterCoefficients;
%通过在信道中传递一个脉冲计算路径增益。
[~,pathGains] = chan(ones(1,2));
%计算信道定时延迟，指定检索到的路径滤波器和计算得到的路径增益。
delay = channelDelay(pathGains,pathFilters)