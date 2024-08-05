ccdf = comm.CCDF('PAPROutputPort',true,'MaximumPowerLimit', 50);
ofdmMod = comm.OFDMModulator('FFTLength',256,'CyclicPrefixLength',32);
%使用comm.OFDMModulator对象的info函数确定OFDM调制器对象的输入和输出大小。
ofdmDims = info(ofdmMod)
ofdmInputSize = ofdmDims.DataInputSize;
ofdmOutputSize = ofdmDims.OutputSize;
%设置OFDM帧的个数。
numFrames = 20;
%为信号阵列分配内存。
qamSig = repmat(zeros(ofdmInputSize),numFrames,1);
ofdmSig = repmat(zeros(ofdmOutputSize),numFrames,1);
%对生成的64-QAM和OFDM信号进行评估。
for k = 1:numFrames
    % 生成随机数据符号
    data = randi([0 63],ofdmInputSize);
    % 采用64-QAM调制
    tmpQAM = qammod(data,64);
    % 对OFDM调制信号进行OFDM调制
    tmpOFDM = ofdmMod(tmpQAM);
    % 保存信号数据
    qamSig((1:ofdmInputSize)+(k-1)*ofdmInputSize(1)) = tmpQAM;
    ofdmSig((1:ofdmOutputSize)+(k-1)*ofdmOutputSize(1)) = tmpOFDM;
end
%确定平均信号功率，峰值信号功率，和两个信号的PAPR比率。两个被评估的信号必须是相同的长度，以便前4000个符号被评估。
[Fy,Fx,PAPR] = ccdf([qamSig(1:4000),ofdmSig(1:4000)]);
%绘制CCDF数据。
plot(ccdf)
legend('QAM','OFDM','location','best')

%比较QAM调制信号和OFDM调制信号的PAPR值。
fprintf('\nPAPR for 64-QAM = %5.2f dB\nPAPR for OFDM = %5.2f dB\n',...
    PAPR(1), PAPR(2))