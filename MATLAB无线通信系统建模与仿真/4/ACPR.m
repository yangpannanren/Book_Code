sps = 4;
bw = 50e3;
%为QSPK调制生成10,000个4元符号
data = randi([0 3],10000,1);
%构造一个QPSK调制器，然后对输入数据进行调制。
qpskMod = comm.QPSKModulator;
x = qpskMod(data);
y = rectpulse(x,sps);
acpr = comm.ACPR('SampleRate',bw*sps,...
    'MainChannelFrequency',0,...
    'MainMeasurementBandwidth',bw,...
    'AdjacentChannelOffset',50e3,...
    'AdjacentMeasurementBandwidth',bw,...
    'MainChannelPowerOutputPort', true,...
    'AdjacentChannelPowerOutputPort',true);
%测量信号y的ACPR、主信道功率和相邻信道功率。
[ACPRout,mainPower,adjPower] = acpr(y)
%创建一个升余弦滤波器并对调制信号进行滤波。
txfilter = comm.RaisedCosineTransmitFilter('OutputSamplesPerSymbol', sps);
z = txfilter(x);

release(acpr)
acpr.AdjacentChannelOffset = 75e3;
ACPRout = acpr(y)

release(acpr)
acpr.AdjacentChannelOffset = 50e3;
%创建一个凸起余弦滤波器并对调制信号进行滤波。
ACPRout = acpr(z)
freqOffset = 1e3*(30:10:70);
release(acpr)
acpr.AdjacentChannelOffset = freqOffset;
%确定矩形和凸起余弦脉冲形状信号的ACPR值。
ACPR1 = acpr(y);
ACPR2 = acpr(z);
%绘制相邻信道功率比。
plot(freqOffset/1000,ACPR1,'*-',freqOffset/1000, ACPR2,'o-')
xlabel('相邻信道偏移(kHz)')
ylabel('ACPR (dB)')
legend('矩形','升余弦','location','best')
grid