txRCosFilt = comm.RaisedCosineTransmitFilter;
%调制和过滤随机64元符号。
M= 64;
data = randi([0 M-1],100000,1);
dataMod = qammod(data,M);
txSig = txRCosFilt(dataMod);
%指定振幅和相位不平衡。
ampImb = 2; % dB
phImb = 15; % 角度
%应用指定的I/Q不平衡。
gainI = 10.^(0.5*ampImb/20);
gainQ = 10.^(-0.5*ampImb/20);
imbI = real(txSig)*gainI*exp(-0.5i*phImb*pi/180);
imbQ = imag(txSig)*gainQ*exp(1i*(pi/2 + 0.5*phImb*pi/180));
rxSig = imbI + imbQ;
%将接收到的信号的功率标准化。
rxSig = rxSig/std(rxSig);
%通过创建和应用一个comm.IQImbalanceCompensator对象来消除I/Q不平衡。设置补偿器，使复系数可用作输出参数。
iqComp = comm.IQImbalanceCompensator('CoefficientOutputPort',true);
[compSig,coef] = iqComp(rxSig);
%将最终补偿器系数与由iqimbal2coef函数生成的系数进行比较。
idealcoef = iqimbal2coef(ampImb,phImb);
[coef(end); idealcoef]