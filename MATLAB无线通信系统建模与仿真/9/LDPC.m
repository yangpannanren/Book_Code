rng(210);              % 为可重复性设置 RNG 状态

A = 10000;             % 传输块长度，为正整数
rate = 449/1024;       % 目标码率，0<R<1
rv = 0;                %冗余版本，0~3
modulation = 'QPSK';   % 调制方案，QPSK，16QAM，64QAM，256QAM
nlayers = 1;           %层数，传输块为1~4

% DL-SCH编码参数
cbsInfo = nrDLSCHInfo(A,rate);
disp('DL-SCH编码参数')
disp(cbsInfo)

% 随机传输块数据生成
in = randi([0 1],A,1,'int8');
% 传输块 CRC 附件
tbIn = nrCRCEncode(in,cbsInfo.CRC);
%代码块分段和CRC附件
cbsIn = nrCodeBlockSegmentLDPC(tbIn,cbsInfo.BGN);
%LDPC编码
enc = nrLDPCEncode(cbsIn,cbsInfo.BGN);
% 速率匹配和码块级联
outlen = ceil(A/rate);
chIn = nrRateMatchLDPC(enc,outlen,rv,modulation,nlayers);

chOut = double(1-2*(chIn));

% 速率恢复
raterec = nrRateRecoverLDPC(chOut,A,rate,rv,modulation,nlayers);
% LDPC解码
decBits = nrLDPCDecode(raterec,cbsInfo.BGN,25);
% 代码块分割和CRC解码
[blk,blkErr] = nrCodeBlockDesegmentLDPC(decBits,cbsInfo.BGN,A+cbsInfo.L);
disp(['每个CRC代码块的错误: [' num2str(blkErr) ']'])
% 传输块CRC解码
[out,tbErr] = nrCRCDecode(blk,cbsInfo.CRC);
disp(['错误的CRC传输块: ' num2str(tbErr)])
disp(['没有错误的恢复的传输块: ' num2str(isequal(out,in))])