ue1.NULRB = 6;                  %资源块数量
ue1.NSubframe = 0;              % 子帧数
ue1.NCellID = 10;               % 物理层单元特性
ue1.RNTI = 61;                  % 无线网络临时标识符
ue1.CyclicPrefixUL = 'Normal';  % 循环前缀
ue1.Hopping = 'Off';            % 跳频
ue1.Shortened = 0;              %保留最后的符号用于SRS传输
ue1.NTxAnts = 1;                % 发射天线数量

ue2.NULRB = 6;                  % 资源块数量   
ue2.NSubframe = 0;              % 子帧数
ue2.NCellID = 10;               % 物理层单元特性
ue2.RNTI = 77;                  %无线网络临时标识符  
ue2.CyclicPrefixUL = 'Normal';  % 循环前缀
ue2.Hopping = 'Off';            % 跳频
ue2.NTxAnts = 1;                %发射天线数量

pucch1.ResourceIdx = 0;   %PUCCH资源索引
pucch1.DeltaShift = 1;    % δ移位
pucch1.CyclicShifts = 1;  % 循环移位次数
pucch1.ResourceSize = 0;  %分配给PUCCH格式1的资源大小

pucch2.ResourceIdx = 0;   % PUCCH资源索引
pucch2.CyclicShifts = 1;  %循环移位次数
pucch2.ResourceSize = 0;  % 分配给PUCCH格式2的资源大小

channel.NRxAnts = 4;                % 接收天线数量 
channel.DelayProfile = 'ETU';       % 延迟概率
channel.DopplerFreq = 300.0;        % 多普勒频率  
channel.MIMOCorrelation = 'Low';    % MIMO相关
channel.InitTime = 0.0;             % 初始化时间
channel.NTerms = 16;                % 衰落模型中的振荡器
channel.ModelType = 'GMEDS';        % 瑞利衰落模型类型
channel.InitPhase = 'Random';       % 随机的初始阶段
channel.NormalizePathGains = 'On';  % 归一化延迟功率
channel.NormalizeTxAnts = 'On';     % 对发射天线进行标准化
% 设置采样率
info = lteSCFDMAInfo(ue1);
channel.SamplingRate = info.SamplingRate;

SNRdB = 21.0;
% 标准化噪声功率
SNR = 10^(SNRdB/20);
N = 1/(SNR*sqrt(double(info.Nfft)))/sqrt(2.0);
% 设置随机数生成器
rng('default');

cec = struct;                     % 信道估计配置结构
cec.PilotAverage = 'UserDefined'; % 导频平均类型
cec.FreqWindow = 12;              % REs(特殊模式)窗口的平均频率
cec.TimeWindow = 1;               % REs的平均时间窗(特殊模式)
cec.InterpType = 'cubic';         % 三次插值

% PUCCH 1调制/编码
hi1 = [0; 1];  % 创建HARQ指标
disp('hi1:');
pucch1Sym = ltePUCCH1(ue1, pucch1, hi1);    
pucch1DRSSym = ltePUCCH1DRS(ue1, pucch1);

% pucch2 DRS调制
hi2 = [1; 1];  % 创建HARQ指标
disp('hi2:');
disp(hi2.');
pucch2DRSSym = ltePUCCH2DRS(ue2, pucch2, hi2);
cqi = [0; 1; 1; 0; 0; 1];  % 创建通道质量信息
disp('cqi:');
disp(cqi.');

codedcqi = lteUCIEncode(cqi);
% PUCCH 2调制
pucch2Sym = ltePUCCH2(ue2, pucch2, codedcqi);

pucch1Indices = ltePUCCH1Indices(ue1, pucch1);    
pucch2Indices = ltePUCCH2Indices(ue2, pucch2);        

pucch1DRSIndices = ltePUCCH1DRSIndices(ue1, pucch1);  
pucch2DRSIndices = ltePUCCH2DRSIndices(ue2, pucch2);

% 创建资源网格
grid1 = lteULResourceGrid(ue1);
grid1(pucch1Indices) = pucch1Sym;
grid1(pucch1DRSIndices) = pucch1DRSSym;
% SC-FDMA调制
txwave1 = lteSCFDMAModulate(ue1, grid1);
%信道建模。在波形末端添加额外的25个样本，以覆盖从信道建模中预期的时延范围(实现时延和信道时延扩展的组合)
channel.Seed = 13;
rxwave1 = lteFadingChannel(channel,[txwave1; zeros(25,1)]);

% 创建资源网格
grid2 = lteULResourceGrid(ue2);
grid2(pucch2Indices) = pucch2Sym;            
grid2(pucch2DRSIndices) = pucch2DRSSym; 
% SC-FDMA调制
txwave2 = lteSCFDMAModulate(ue2, grid2);
% %信道建模。在波形末端添加额外的25个样本，以覆盖从信道建模中预期的时延范围(实现时延和信道时延扩展的组合)
channel.Seed = 15;
rxwave2 = lteFadingChannel(channel, [txwave2; zeros(25, 1)]);

rxwave = rxwave1 + rxwave2;         
%添加噪声
noise = N*complex(randn(size(rxwave)), randn(size(rxwave)));
rxwave = rxwave + noise;

% 同步
offset1 = lteULFrameOffsetPUCCH1(ue1, pucch1, rxwave);
% SC-FDMA解调
rxgrid1 = lteSCFDMADemodulate(ue1, rxwave(1+offset1:end, :));

% 信道估计
[H1, n0] = lteULChannelEstimatePUCCH1(ue1, pucch1, cec, rxgrid1);
%从所有接收天线和信道估计的给定子帧中提取PUCCH对应的REs
[pucchrx1, pucchH1] = lteExtractResources(pucch1Indices, rxgrid1, H1);
% 均衡
eqgrid1 = lteULResourceGrid(ue1);   
eqgrid1(pucch1Indices) = lteEqualizeMMSE(pucchrx1, pucchH1, n0);

rxhi1 = ltePUCCH1Decode(ue1, pucch1, length(hi1), ...
    eqgrid1(pucch1Indices));
disp('rxhi1:');
disp(rxhi1.');

% 同步(和PUCCH 2 DRS解调/解码)
[offset2,rxhi2] = lteULFrameOffsetPUCCH2(ue2,pucch2,rxwave,length(hi2));
disp('rxhi2:');
disp(rxhi2.');

%SC-FDMA解调
rxgrid2 = lteSCFDMADemodulate(ue2, rxwave(1+offset2:end, :));
% 信道估计
[H2, n0] = lteULChannelEstimatePUCCH2(ue2, pucch2, cec, rxgrid2, rxhi2);
% 从所有接收天线和信道估计的给定子帧中提取PUCCH对应的REs
[pucchrx2, pucchH2] = lteExtractResources(pucch2Indices, rxgrid2, H2);
% 均衡
eqgrid2 = lteULResourceGrid(ue2);  
eqgrid2(pucch2Indices) = lteEqualizeMMSE(pucchrx2, pucchH2, n0);
% PUCCH2 解调
rxcodedcqi = ltePUCCH2Decode(ue2, pucch2, eqgrid2(pucch2Indices));
% PUCCH2 解码
rxcqi = lteUCIDecode(rxcodedcqi, length(cqi));
disp('rxcqi:');
disp(rxcqi.');

hPUCCHMixedFormatDisplay(H1, eqgrid1, H2, eqgrid2);