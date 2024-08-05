%设置仿真参数
M = 4;                 % 调制字母表
k = log2(M);           
numSC = 128;           % OFDM子载波数
cpLen = 32;            % OFDM循环前缀长度
maxBitErrors = 100;    % 最大误码数
maxNumBits = 1e7;      % 传输的最大比特数

qpskMod = comm.QPSKModulator('BitInput',true);
qpskDemod = comm.QPSKDemodulator('BitOutput',true);

%根据仿真参数设置OFDM调制器和解调器对
ofdmMod = comm.OFDMModulator('FFTLength',numSC,'CyclicPrefixLength',cpLen);
ofdmDemod = comm.OFDMDemodulator('FFTLength',numSC,'CyclicPrefixLength',cpLen);
%将AWGN通道对象的NoiseMethod属性设置为Variance，并定义VarianceSource属性，以便可以从输入端口设置噪声功率。
channel = comm.AWGNChannel('NoiseMethod','Variance','VarianceSource','Input port');
%将ResetInputPort属性设置为true，以允许在模拟过程中重置错误率计算器。
errorRate = comm.ErrorRate('ResetInputPort',true);
%使用ofdmMod对象的info函数来确定OFDM调制器的输入输出尺寸
 ofdmDims = info(ofdmMod)
%从ofdmDims结构变量确定数据子载波的数量
numDC = ofdmDims.DataInputSize(1)
%从数据子载波的数量和每个符号的比特数确定OFDM帧大小(单位为bit)
numDC = ofdmDims.DataInputSize(1)
frameSize = [k*numDC 1];
%根据期望的Eb/No范围、每个符号的bit数和数据子载波的数量与总子载波数量的比率设置为信噪比
EbNoVec = (0:10)';
snrVec = EbNoVec + 10*log10(k) + 10*log10(numDC/numSC);
%初始化误码率和错误统计数据数组
berVec = zeros(length(EbNoVec),3);
errorStats = zeros(1,3);
%在Eb/No值范围内模拟通信链路。对于每个Eb/No值，模拟运行直到记录maxBitErrors或传输的比特总数超过maxNumBits。
for m = 1:length(EbNoVec)
    snr = snrVec(m);    
    while errorStats(2) <= maxBitErrors && errorStats(3) <= maxNumBits
        dataIn = randi([0,1],frameSize);              % 生成二进制数据
        qpskTx = qpskMod(dataIn);                     % 采用QPSK调制
        txSig = ofdmMod(qpskTx);                      % 采用OFDM调制
        powerDB = 10*log10(var(txSig));               % 计算发送信号功率
        noiseVar = 10.^(0.1*(powerDB-snr));           % 计算噪声方差
        rxSig = channel(txSig,noiseVar);              % 将信号通过有噪声的信道传送
        qpskRx = ofdmDemod(rxSig);                    % 采用OFDM解调
        dataOut = qpskDemod(qpskRx);                  % 采用QPSK解调
        errorStats = errorRate(dataIn,dataOut,0);     % 收集错误统计信息
    end    
    berVec(m,:) = errorStats;                         %保存系统数据
    errorStats = errorRate(dataIn,dataOut,1);         % 重置错误率计算器
end
berTheory = berawgn(EbNoVec,'psk',M,'nondiff');
%将理论数据和模拟数据绘制在同一张图上，比较结果
figure
semilogy(EbNoVec,berVec(:,1),'*')
hold on
semilogy(EbNoVec,berTheory)
legend('模拟数据','理论数据','Location','Best')
xlabel('Eb/No (dB)')
ylabel('误比特率')
grid on
hold off
