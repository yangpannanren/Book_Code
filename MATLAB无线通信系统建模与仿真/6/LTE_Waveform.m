enb.NDLRB = 6;                % 下行块块编号(DL-RB)
enb.CyclicPrefix = 'Normal';  % CP长度
enb.PHICHDuration = 'Normal'; % 正常PHICH持续时间
enb.DuplexMode = 'FDD';       % FDD双工模式
enb.CFI = 3;                  % PDCCH符号
enb.Ng = 'Sixth';             % HICH组
enb.CellRefP = 4;             % 4天线端口
enb.NCellID = 10;             % 元胞数组ID
enb.NSubframe = 0;            % 子帧数0

subframe = lteDLResourceGrid(enb);

pdsch.NLayers = 4;                       % 没有层
pdsch.TxScheme = 'TxDiversity';          % 传输机制
pdsch.Modulation = 'QPSK';               % 调制机制
pdsch.RNTI = 1;                          % 16bit 特定标记
pdsch.RV = 0;                            % 冗余版本

pdsch.PRBSet = (0:enb.NDLRB-1).';   % 子帧资源分配
[pdschIndices,pdschInfo] = ...
    ltePDSCHIndices(enb, pdsch, pdsch.PRBSet, {'1based'});

codedTrBlkSize = pdschInfo.G;   % 可用PDSCH比特
transportBlkSize = 152;                % 传输块大小
dlschTransportBlk = randi([0 1], transportBlkSize, 1);
% 进行信道编码
codedTrBlock = lteDLSCH(enb, pdsch, codedTrBlkSize, ...
               dlschTransportBlk);

pdschSymbols = ltePDSCH(enb, pdsch, codedTrBlock);

% 将PDSCH符号映射到资源网格上
subframe(pdschIndices) = pdschSymbols;


dci.DCIFormat = 'Format1A';  % DCI消息格式
dci.Allocation.RIV = 26;     % 资源指示值
[dciMessage, dciMessageBits] = lteDCI(enb, dci); % DCI消息

pdcch.NDLRB = enb.NDLRB;  %DL-RB总体重数
pdcch.RNTI = pdsch.RNTI;  % 16位值
pdcch.PDCCHFormat = 0;    % 聚合级别1的cce
% 对DCI报文位进行编码，形成编码DCI位
codedDciBits = lteDCIEncode(pdcch, dciMessageBits);

cfiBits = lteCFI(enb);

pcfichSymbols = ltePCFICH(enb, cfiBits);

pcfichIndices = ltePCFICHIndices(enb);
%将PCFICH符号映射到资源网格
subframe(pcfichIndices) = pcfichSymbols;

surf(abs(subframe(:,:,1)));
view(2);
axis tight;
xlabel('OFDM符号');
ylabel('副载波');
title('资源网格');