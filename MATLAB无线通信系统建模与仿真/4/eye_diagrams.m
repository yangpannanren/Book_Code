span = 10;          % 过滤器跨度
rolloff = 0.2;      %滚降系数
sps = 8;            % 每个符号样本
M = 4;              % 调制字母大小
k = log2(M);       
phOffset = pi/4;    % 相位偏移（弧度）
n = 1;              % 画出信号的第n个值
offset = 0;         % 从偏移量+1开始，绘制信号的第n个值

filtCoeff = rcosdesign(rolloff,span,sps);
rng default
data = randi([0 M-1],5000,1);

dataMod = pskmod(data,M,phOffset);
%过滤调制数据
txSig = upfirdn(dataMod,filtCoeff,sps);
%计算过采样的QPSK信号的信噪比
EbNo = 20;
snr = EbNo + 10*log10(k) - 10*log10(sps);
%将AWGN添加到传输信号中
rxSig = awgn(txSig,snr,'measured');
%应用RRC接收过滤器
rxSigFilt = upfirdn(rxSig, filtCoeff,1,sps);
%解调滤波后的信号
dataOut = pskdemod(rxSigFilt,M,phOffset,'gray');
h = scatterplot(sqrt(sps)*txSig(sps*span+1:end-sps*span),sps,offset,'g.');
hold on
scatterplot(rxSigFilt(span+1:end-span),n,offset,'kx',h)
scatterplot(dataMod,n,offset,'r*',h)
legend('传输信号','接收信号','理想的','location','best')