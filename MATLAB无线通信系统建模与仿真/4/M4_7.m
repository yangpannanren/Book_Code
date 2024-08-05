%生成随机符号。采用QPSK调制得到已调制信号。
data = randi([0 3],1000,1);
modSig = pskmod(data,4,pi/4);
%指定每个符号参数的输出样本数。创建一个传输过滤器对象txfilter。
sps=4;
txfilter = comm.RaisedCosineTransmitFilter('OutputSamplesPerSymbol',sps);
%对调制信号进行modSig滤波。
txSig = txfilter(modSig);
%显示眼图。
eyediagram(txSig,2*sps)