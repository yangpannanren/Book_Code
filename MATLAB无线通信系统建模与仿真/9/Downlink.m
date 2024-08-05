rng(211);           % 为可重复性设置 RNG 状态
nID = 23;           % pdcch-DMRS-扰码ID
rnti = 100;         %UE特定搜索空间中PDCCH的C-RNTI
K = 64;             %DCI 消息位数
E = 288;            % PDCCH 资源的比特数

dciBits = randi([0 1],K,1,'int8');
dciCW = nrDCIEncode(dciBits,rnti,E);

sym = nrPDCCH(dciCW,nID,rnti);

EbNo = 3;                       %分贝
bps = 2;                        % 每个符号位，QPSK 为 2
EsNo = EbNo + 10*log10(bps);
snrdB = EsNo + 10*log10(K/E);
rxSym = awgn(sym,snrdB,'measured');

noiseVar = 10.^(-snrdB/10);     % 信号功率
rxCW = nrPDCCHDecode(rxSym,nID,rnti,noiseVar);

listLen = 8;                    % 极性解码列表长度
[decDCIBits,mask] = nrDCIDecode(rxCW,K,listLen,rnti);
isequal(mask,0)
isequal(decDCIBits,dciBits)