% 以下实例显示了如何创建20MHz，QPSK，3/4速率波形，该波形与全分配和2个发射天线的传输模式8（“ Port7-8”传输方案）相对应。
dataStream = [1 0 0 1];     % 定义输入用户数据流
params = struct();          % 初始化参数结构
params.NDLRB = 100;         % 20 MHz bandwidth
params.CellRefP = 2;        % 前两个端口上的单元参考信号
params.PDSCH.PRBSet = (0:params.NDLRB-1)'; % 全额分配
params.PDSCH.TargetCodeRate = 3/4; % 目标码率
params.PDSCH.TxScheme = 'Port7-8'; % 传输模式8
params.PDSCH.NLayers = 2;          % 2层传输
params.PDSCH.Modulation = 'QPSK';  % 调制方式
params.PDSCH.NSCID = 0;            %
params.PDSCH.NTxAnts = 2;          % 2个发射天线
params.PDSCH.W = lteCSICodebook(params.PDSCH.NLayers,...
                        params.PDSCH.NTxAnts,0).'; % 预编码矩阵

% 使用lteRMCDL填充其他参数字段
fullParams = lteRMCDL(params);
% 使用完整参数集“ fullParams”生成波形
[dlWaveform, dlGrid, dlParams] = lteRMCDLTool(fullParams,dataStream);
% dlWaveform是时域波形，dlGrid是资源网格，
%dlParams是在波形生成中使用的完整参数集。

params = lteRMCDL('R.0'); % 定义参数集
[dlWaveform, dlGrid, dlParams] = lteRMCDLTool(params,dataStream);
%如果最终应用是生成波形，我们还可以直接将RMC编号与发生器一起使用来创建波形
[dlWaveform, dlGrid, dlParams] = lteRMCDLTool('R.0',dataStream);

params = struct(); % 初始化参数结构
params.RC = 'R.31-3A';
params.PDSCH.TargetCodeRate = 1/2;
params.PDSCH.Modulation = '16QAM';
%使用lteRMCDL填充其他参数字段
fullParams = lteRMCDL(params);
% 使用完整参数集“ fullParams”生成波形
[dlWaveform, dlGrid, dlParams] = lteRMCDLTool(fullParams,{dataStream, dataStream}); 


mcsIndex = 10;
%从MCS值获取ITBS和调制
[itbs,modulation] = lteMCS(mcsIndex);
params = struct(); % 初始化参数结构
%带宽（NDLRB）必须大于或等于分配
params.NDLRB = 50;                         % 设置带宽
params.PDSCH.PRBSet = (0:params.NDLRB-1)'; %全额分配
params.PDSCH.Modulation = modulation;      % 设置调制方式
nrb = size(params.PDSCH.PRBSet,1);         % 获取分配的RB数
tbs = double(lteTBS(nrb,itbs));            % 获取运输块尺寸
% 现在创建在子帧5中没有传输的“ TrBlkSizes”向量
params.PDSCH.TrBlkSizes = [ones(1,5)*tbs 0 ones(1,4)*tbs];
%现在使用lteRMCDL填充其他参数字段
fullParams = lteRMCDL(params);
% 现在使用完整参数集“ fullparams”生成波形
[dlWaveform, dlGrid, dlParams] = lteRMCDLTool(fullParams,dataStream);


params = struct();            %初始化参数结构
params.NDLRB = 100;           %设置带宽（20MHz）
params.CellRefP = 2;          % 设置特定于单元的参考信号端口
params.CFI = 1;               % 给PDCCH分配1个符号
params.PDSCH.PRBSet = {(0:99)' (0:99)' (0:99)' (0:99)' (0:99)'  ...
                       (4:99)' (0:99)' (0:99)' (0:99)' (0:99)'};
params.PDSCH.TargetCodeRate = [0.61 0.59 0.59 0.59 0.59 0.62 0.59 0.59 0.59 0.59];
params.PDSCH.TxScheme = 'CDD';% 2个码字闭环空间复用器
params.PDSCH.NLayers = 2;     %每个代码字1层
params.PDSCH.Modulation = {'64QAM', '64QAM'};% 设置2个调制码字
%使用lteRMCDL填充其他参数字段。
fullParams = lteRMCDL(params);
% 使用完整参数集“ fullParams”生成波形
[dlWaveform, dlGrid, dlParams] = lteRMCDLTool(fullParams,{dataStream, dataStream});