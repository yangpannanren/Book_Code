E = 864;
cw = randi([0 1],E,1);
ncellid = 17;
v = 0;
pbchTxSym = nrPBCH(cw,ncellid,v);
pbchInd = nrPBCHIndices(ncellid);
%使用nrExtractResources为波束成形PBCH的两个发射天线创建索引。使用这些索引将波束成形的PBCH映射到发射机资源阵列中。
P = 2;
txGrid = zeros([240 4 P]);
F = [1 1i];
[~,bfInd] = nrExtractResources(pbchInd,txGrid);
txGrid(bfInd) = pbchTxSym*F;
%OFDM调制映射到发射机资源阵列中的PBCH符号。
txWaveform = ofdmmod(txGrid,256,[22 18 18 18],[1:8 249:256].');

R = 3;
H = dftmtx(max([P R]));
H = H(1:P,1:R);
H = H/norm(H);
rxWaveform = txWaveform*H;
%创建包括波束成形在内的信道估计。
hEstGrid = repmat(permute(H.'*F.',[3 4 1 2]),[240 4]);
nEst = 0;
%使用正交频分复用(OFDM)解调接收到的波形。
 rxGrid = ofdmdemod(rxWaveform,256,[22 18 18 18],0,[1:8 249:256].');
 %在准备PBCH解码时，从接收网格和信道估计网格中提取符号。
[pbchRxSym,pbchHestSym] = nrExtractResources(pbchInd,rxGrid,hEstGrid);
figure;
plot(pbchRxSym,'o:');
title('收到PBCH星座'); 
