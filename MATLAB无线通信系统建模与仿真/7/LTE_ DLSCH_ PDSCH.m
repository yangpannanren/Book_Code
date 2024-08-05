%计算单元范围的设置
%单元范围的参数被分组成一个结构enb。
%本例中使用的许多函数需要下面指定的参数子集。
enb.NDLRB = 50;                 % 资源块数量
enb.CellRefP = 4;               % cell特定的参考信号端口
enb.NCellID = 0;                % Cell ID
enb.CyclicPrefix = 'Normal';    % 正常循环前缀
enb.CFI = 2;                    % 控制区域长度
enb.DuplexMode = 'FDD';         % FDD双模式
enb.TDDConfig = 1;              % 上行/下行配置(仅TDD)
enb.SSC = 4;                    % 特殊子帧配置(仅限TDD)
enb.NSubframe = 0;              % 子帧数


%DL-SCH和PDSCH通道特定设置在参数结构PDSCH中指定。对于R.14 FDD RMC，有两个码字，
%因此调制方案被指定为包含字符向量或具有字符向量的单元阵列的调制方案的单元阵列。
%同样重要的是配置TrBlkSizes参数，使其具有正确的元素数量作为预期的码字数量。
%速率匹配阶段的软比特数由终端决定

% 设置DL-SCH
TrBlkSizes = [11448; 11448];    % 2个元件用于2个码字传输
pdsch.RV = [0 0];               % RV为2个码字
pdsch.NSoftbits = 1237248;      % UE的软信道位的数目为2
% PDSCH Settings
pdsch.TxScheme = 'SpatialMux';  
pdsch.Modulation = {'16QAM','16QAM'}; % 用于2个码字的符号调制
pdsch.NLayers = 2;              % 两个空间传输层
pdsch.NTxAnts = 2;              % 发射天线数量
pdsch.RNTI = 1;                 % RNTI值
pdsch.PRBSet = (0:enb.NDLRB-1)';% 充分分配的PRBs
pdsch.PMISet = 0;               % 预编码矩阵指数
pdsch.W = 1;                    % 没有形成UE-specific波束
%只需要'Port5'， 'Port7-8'， 'Port8'和'Port7-14'方案
if any(strcmpi(pdsch.TxScheme,{'Port5','Port7-8','Port8', 'Port7-14'}))
    pdsch.W = transpose(lteCSICodebook(pdsch.NLayers,pdsch.NTxAnts,[0 0]));
end



% 用于创建随机传输块的随机数初始化
rng('default');
%将调制字符阵列或单元阵列转换为字符串阵列以便统一处理
pdsch.Modulation = string(pdsch.Modulation);
% 从传输块的数量中获取码字的数量
nCodewords = numel(TrBlkSizes);
%生成传输块
trBlk = cell(1,nCodewords); % Initialize the codeword(s)
for n=1:nCodewords
    trBlk{n} = randi([0 1],TrBlkSizes(n),1);
end
% 从ltePDSCHIndices信息输出中获取速率匹配所需的物理通道位容量
[~,pdschInfo] = ltePDSCHIndices(enb,pdsch,pdsch.PRBSet);
% 为lteRateMatchTurbo定义一个带参数的结构数组
chs = pdsch;
chs(nCodewords) = pdsch; % 对于两个码字，数组有两个元素
% 初始化代码字(s)
cw = cell(1,nCodewords);
for n=1:nCodewords
    % 为传输块添加CRC
    crccoded = lteCRCEncode(trBlk{n},'24A');
    % 代码块分段返回带有填充位和类型为24b的CRC的代码块段的单元数组
    blksegmented = lteCodeBlockSegment(crccoded);
    % 信道编码返回单元数组中的turbo编码段
    chencoded = lteTurboEncode(blksegmented);
    % 将参数捆绑在结构chs中以进行速率匹配，因为该函数同时需要单元范围和通道特定的参数
    chs(n).Modulation = pdsch.Modulation{n};
    chs(n).DuplexMode = enb.DuplexMode;
    chs(n).TDDConfig = enb.TDDConfig;
    % 计算码字的层数
    if n==1
        chs(n).NLayers = floor(pdsch.NLayers/nCodewords);
    else
        chs(n).NLayers = ceil(pdsch.NLayers/nCodewords);
    end
    %速率匹配返回为turbo编码数据定义的子块交错、位收集、位选择和修剪后的码字，并合并代码块段的单元数组
    cw{n} = lteRateMatchTurbo(chencoded,pdschInfo.G(n),pdsch.RV(n),chs(n));
end



% 初始化已调制的符号
modulated = cell(1,nCodewords);
for n=1:nCodewords
   % 生成置乱序列
   scramseq = ltePDSCHPRBS(enb,pdsch.RNTI,n-1,length(cw{n}));
   % 扰乱码字
   scrambled = xor(scramseq,cw{n});
   % 符号调制置乱码字
   modulated{n} = lteSymbolModulate(scrambled,pdsch.Modulation{n});
end
% 层映射的结果是一个(每层符号)NLayers矩阵
layermapped = lteLayerMap(pdsch,modulated);
% 预编码结果为(每个天线的符号)NTxAnts矩阵
precoded = lteDLPrecode(enb, pdsch, layermapped);
% 选择性地应用波束形成(如果没有波束形成，W可能是1或与1一性)
pdschsymbols = precoded*pdsch.W;






% 反预编码(伪逆基)返回(符号数)×NLayers矩阵
if (any(strcmpi(pdsch.TxScheme,{'Port5' 'Port7-8' 'Port8' 'Port7-14'})))
    rxdeprecoded=pdschsymbols*pinv(pdsch.W);
else
    rxdeprecoded = lteDLDeprecode(enb,pdsch,pdschsymbols);
end
%层映射返回包含一个或两个码字的单元格数组。由调制方式字符向量的个数推导出调制词的个数
layerdemapped = lteLayerDemap(pdsch,rxdeprecoded);

% 初始化恢复的码字
cws = cell(1,nCodewords);
for n=1:nCodewords
    % 接收符号的软解调
    demodulated = lteSymbolDemodulate(layerdemapped{n},pdsch.Modulation{n},'Soft');
    % 生成用于反扰的置乱序列
    scramseq = ltePDSCHPRBS(enb,pdsch.RNTI,n-1,length(demodulated),'signed');
    % Descrambling of received bits
    cws{n} = demodulated.*scramseq;
end


% 初始化接收到的传输块和CRC
rxTrBlk = cell(1,nCodewords);
crcError = zeros(1,nCodewords);
for n=1:nCodewords   
    cbsbuffers = []
    raterecovered = lteRateRecoverTurbo(cws{n},TrBlkSizes,pdsch.RV(n),chs(n),cbsbuffers);
    NTurboDecIts = 5; %turbo解码迭代周期数
    % Turbo解码返回已解码代码块的单元数组
    turbodecoded = lteTurboDecode(raterecovered,NTurboDecIts);
    %在移除任何填充和可能存在的24b型CRC位之后，将输入代码块段分割为单个输出数据块，
    [blkdesegmented,segErr] = lteCodeBlockDesegment(turbodecoded,(TrBlkSizes+24));
    % 在检查CRC错误后，CRC解码返回传输块
    [rxTrBlk{n},crcError(n)] = lteCRCDecode(blkdesegmented,'24A');
end