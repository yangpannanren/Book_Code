s = rng;
rng(68521);
nsamp = 4; % 每个符号样本数量
ch1 = randi([0 1],3*nsamp,1); % 随机二进制通道
ch2 = rectpulse([1 2 3]',nsamp); % 矩形脉冲
x = [ch1 ch2]; % 双通道信号
y = intdump(x,nsamp)
rng(s);
%