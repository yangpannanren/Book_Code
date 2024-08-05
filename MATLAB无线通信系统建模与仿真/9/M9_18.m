ncellid = 146;
v = 0;
E = 864;
cw = randi([0 1],E,1);
pbchTxSym = nrPBCH(cw,ncellid,v);
pbchInd = nrPBCHIndices(ncellid);
%为一个发射天线生成一个空的资源阵列，并使用生成的PBCH索引用PBCH符号填充阵列。
P = 1;
txGrid = zeros([240 4 P]);
txGrid(pbchInd) = pbchTxSym;
%执行OFDM调制。
txWaveform = ofdmmod(txGrid,256,[22 18 18 18],[1:8 249:256].');
%创建通道矩阵并将通道应用于传输波形。
R = 4;
H = dftmtx(max([P R]));
H = H(1:P,1:R);
H = H / norm(H);
rxWaveform = txWaveform * H;
%创建信道估计。
hEstGrid = repmat(permute(H.',[3 4 1 2]),[240 4]);
nEst = 0.1;
%执行OFDM解调。
rxGrid = ofdmdemod(rxWaveform,256,[22 18 18 18],0,[1:8 249:256].');
%为了准备PBCH解码，使用nrExtractResources从接收和信道估计网格中提取符号。绘制接收到的PBCH星座图。
[pbchRxSym,pbchHestSym] = nrExtractResources(pbchInd,rxGrid,hEstGrid);
figure;
plot(pbchRxSym,'o:');
title('收到PBCH星座');
%使用提取的资源元素对PBCH进行解码。绘制均衡的PBCH星座图。
[pbchEqSym,csi] = nrEqualizeMMSE(pbchRxSym,pbchHestSym,nEst);
pbchBits = nrPBCHDecode(pbchEqSym,ncellid,v);
figure;
plot(pbchEqSym,'o:');
title('均衡PBCH星座');