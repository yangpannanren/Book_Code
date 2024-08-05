s = rng(100);       % 提高可重复性
%指定用于模拟的代码参数

K = 54;             % 以比特为单位的消息长度，包括CRC，K > 30
E = 124;            % 速率匹配输出长度，E <= 8192
EbNo = 0.8;         % 以 dB 为单位的 EbNo
L = 8;              % 列表长度，2 的幂，[1 2 4 8]
numFrames = 10;     % 要模拟的帧数
linkDir = 'DL';     % 链路方向：下行（'DL'）或上行（'UL'）

if strcmpi(linkDir,'DL')
    % 下行链路(K >= 36, 包括CRC位)
    crcLen = 24;      %DL 的 CRC 位数
    poly = '24C';     % CRC多项式
    nPC = 0;          %奇偶校验位的数量
    nMax = 9;         % n 的最大值
    iIL = true;       % 交错输入
    iBIL = false;     % 交织编码位
else
    % 上行链路(K > 30, 包括CRC位)
    crcLen = 11;
    poly = '11';
    nPC = 0;
    nMax = 10;
    iIL = false;
    iBIL = true;
end

R = K/E;                          % 有效码率
bps = 2;                          % 每个符号的位数，BPSK 为 1，QPSK 为 2
EsNo = EbNo + 10*log10(bps);
snrdB = EsNo + 10*log10(R);       % 分贝
noiseVar = 1./(10.^(snrdB/10));
% 通道
chan = comm.AWGNChannel('NoiseMethod','Variance','Variance',noiseVar);

% 误差
ber = comm.ErrorRate;

numferr = 0;
for i = 1:numFrames
    % 生成随机消息
    msg = randi([0 1],K-crcLen,1);
    % 附加CRC
    msgcrc = nrCRCEncode(msg,poly);
    % 极性编码
    encOut = nrPolarEncode(msgcrc,E,nMax,iIL);
    N = length(encOut);
    % 速率匹配
    modIn = nrRateMatchPolar(encOut,K,E,iBIL);
    % 调制
    modOut = nrSymbolModulate(modIn,'QPSK');
    % 添加高斯白噪声
    rSig = chan(modOut);
    % 软解调
    rxLLR = nrSymbolDemodulate(rSig,'QPSK',noiseVar);
    % 恢复率
    decIn = nrRateRecoverPolar(rxLLR,K,N,iBIL);
    % 极性解码
    decBits = nrPolarDecode(decIn,K,E,L,nMax,iIL,crcLen);
    % 比较 msg 和解码位
    errStats = ber(double(decBits(1:K-crcLen)), msg);
    numferr = numferr + any(decBits(1:K-crcLen)~=msg);
end
disp(['误块率: ' num2str(numferr/numFrames) ...
      ', 误码率: ' num2str(errStats(1)) ...
      ', 信噪比 = ' num2str(snrdB) ' dB'])
rng(s);     %恢复RNG