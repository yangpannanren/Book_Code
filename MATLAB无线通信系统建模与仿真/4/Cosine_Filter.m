clear all;
M = 16; % 模型阶数
k = log2(M); 
n = 20000; % 传输比特
nSamp = 4; % 每个符号样本
EbNo = 10; % Eb/No (dB)
%设置滤波参数
span = 10; % 符号中的过滤器跨度
rolloff = 0.25; % 滚动系数
%使用前面定义的参数创建升起的余弦发送和接收滤波器。
txfilter = comm.RaisedCosineTransmitFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',span,'OutputSamplesPerSymbol',nSamp);
rxfilter = comm.RaisedCosineReceiveFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',span,'InputSamplesPerSymbol',nSamp, ...
    'DecimationFactor',nSamp);
%绘制hTxFilter的脉冲响应。
fvtool(txfilter,'impulse')
title('脉冲响应');
xlabel('样本');ylabel('幅度')

%通过匹配的滤波器计算延迟。组延迟为一个滤波器的滤波器跨度的一半，即等于两个滤波器的滤波器跨度。如果乘以每个符号的位数，得到以位数为单位的延迟。
filtDelay = k*span;
%创建错误率计数器系统对象。设置ReceiveDelay属性来考虑通过匹配的过滤器的延迟。
errorRate = comm.ErrorRate('ReceiveDelay',filtDelay);
%生成二进制数据。
x = randi([0 1],n,1);
%调整数据。
modSig = qammod(x,M,'InputType','bit');
%对调制信号进行滤波。
txSig = txfilter(modSig);
%绘制前1000个样本的眼图。
eyediagram(txSig(1:1000),nSamp)

%计算给定EbNo的dB的信噪比(SNR)。通过AWGN函数将发射信号通过AWGN信道。
SNR = EbNo + 10*log10(k) - 10*log10(nSamp);
noisySig = awgn(txSig,SNR,'measured');
%滤波噪声信号并显示其散点图。
rxSig = rxfilter(noisySig);
scatterplot(rxSig)
%对滤波后的信号进行解调并计算误差统计量。通过errorRate中的ReceiveDelay属性解释滤器的延迟。
z = qamdemod(rxSig,M,'OutputType','bit');

errStat = errorRate(x,z);
fprintf('\nBER = %5.2e\nBit Errors = %d\nBits Transmitted = %d\n',...
    errStat)