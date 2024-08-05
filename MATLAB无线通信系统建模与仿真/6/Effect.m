NFrames = 4;               % 帧数
eqMethod = 'MMSE_IRC';     % MMSE, MMSE_IRC

SINR = 0.8;        % SINR单位为 dB
DIP2 = -1.73;      % 
DIP3 = -8.66;      % 
Noc = -98;         % 平均功率谱密度dBm/15kHz

% 设置随机数生成器种子
rng('default');
% 根据 R.47 设置小区间1 eNodeB 配置
simulationParameters = struct;
simulationParameters.NDLRB = 50;
simulationParameters.CellRefP = 2;
simulationParameters.NCellID = 0;
simulationParameters.CFI = 2;
simulationParameters.DuplexMode = 'FDD';
simulationParameters.TotSubframes = 1; % 这不是总数
% 模拟中使用的子帧，只是我们每次调用波形发生器生成的子帧数。 指定 PDSCH 配置子结构
simulationParameters.PDSCH.TxScheme = 'SpatialMux';
simulationParameters.PDSCH.Modulation = {'16QAM'};
simulationParameters.PDSCH.NLayers = 1;
simulationParameters.PDSCH.Rho = -3;
simulationParameters.PDSCH.PRBSet = (0:49)';
simulationParameters.PDSCH.TrBlkSizes = [8760 8760 8760 8760 8760 0 8760 8760 8760 8760];
simulationParameters.PDSCH.CodedTrBlkSizes = [24768 26400 26400 26400 26400 0 26400 26400 26400 26400];
simulationParameters.PDSCH.CSIMode = 'PUCCH 1-1';
simulationParameters.PDSCH.PMIMode = 'Wideband';
simulationParameters.PDSCH.CSI = 'On';
simulationParameters.PDSCH.W = [];
simulationParameters.PDSCH.CodebookSubset = '1111';
%指定 PDSCH OCNG 配置
simulationParameters.OCNGPDSCHEnable = 'On';             % 启用 OCNG 填充
simulationParameters.OCNGPDSCHPower = -3;                % OCNG 功率与 PDSCH Rho 相同
simulationParameters.OCNGPDSCH.RNTI = 0;                 % 虚拟 UE RNTI
simulationParameters.OCNGPDSCH.Modulation = 'QPSK';      % OCNG 符号调制
simulationParameters.OCNGPDSCH.TxScheme = 'TxDiversity'; % OCNG传输模式2

enb1 = lteRMCDL(simulationParameters);

enb2 = enb1;
enb2.NCellID = 1;
enb2.OCNGPDSCHEnable = 'Off';
% 单元格33
enb3 = enb1;
enb3.NCellID = 2;
enb3.OCNGPDSCHEnable = 'Off';

%eNodeB1到UE传播信道
channel1 = struct;                    %通道配置结构
channel1.Seed = 20;                   % 通道种子
channel1.NRxAnts = 2;                 % 2个接收天线
channel1.DelayProfile ='EVA';         % 延迟配置文件
channel1.DopplerFreq = 5;             % 多普勒频率
channel1.MIMOCorrelation = 'Low';     % 多相关天线
channel1.NTerms = 16;                 % 衰落模型中使用的振荡器
channel1.ModelType = 'GMEDS';         % 瑞利衰落模型类型
channel1.InitPhase = 'Random';        % 随机初始阶段
channel1.NormalizePathGains = 'On';   % 标准化延迟配置文件功率
channel1.NormalizeTxAnts = 'On';      %对发射天线进行归一化

ofdmInfo = lteOFDMInfo(enb1);
channel1.SamplingRate = ofdmInfo.SamplingRate;
%eNodeB2（干扰）使用传播信道
channel2 = channel1;
channel2.Seed = 122;                  % 通道种子
% eNodeB3（干扰）使用传播信道
channel3 = channel1;
channel3.Seed = 36;                   %通道种子

% 通道估计器行为
perfectChanEstimator = true;
% 信道估计器配置结构定义如下。 
%选择频率和时间平均窗口大小以跨越相对大量的资源元素。 
%选择大窗口大小以尽可能平均资源元素中的噪声和干扰。 
%请注意，过大的时间和/或频率平均窗口会由于平均信道变化而导致信息丢失。
%这会产生越来越不精准的信道估计，这会影响均衡器的性能。
cec = struct;                        % 信道估计配置结构
cec.PilotAverage = 'UserDefined';    % 导频符号平均的类型
cec.FreqWindow = 31;                 % 频率窗口大小
cec.TimeWindow = 23;                 %时间窗口大小
cec.InterpType = 'Cubic';            % 二维插值
cec.InterpWindow = 'Centered';       %插值窗类型
cec.InterpWinSize = 1;               %插值窗口大小


% 通道噪声设置
nocLin = 10.^(Noc/10)*(1e-3); % 线性瓦特
% 考虑 FFT (OFDM) 缩放
No = sqrt(nocLin/(2*double(ofdmInfo.Nfft)));
%信号和干扰幅度缩放因子计算
[K1, K2, K3] = hENBscalingFactors(DIP2, DIP3, Noc, SINR, enb1, enb2, enb3);

% 初始化所有 HARQ 进程的状态
harqProcesses = hNewHARQProcess(enb1);
% 将HARQ进程ID初始化为1，因为第一个非零传输块将始终使用第一个HARQ进程传输。
%在第一次调用该函数后，这将使用lteRMCDLTool输出的完整序列进行更新
harqProcessSequence = 1;
% 为主循环设置变量
lastOffset = 0;       % 初始化与前一帧的帧时序偏移
frameOffset = 0;      % 初始化帧时序偏移
nPMI = 0;             % 初始化计算的预编码器矩阵指示（PMI）集的数量
blkCRC = [];          % 所有考虑的子帧的块 CRC
bitTput = [];         % 每个子帧成功接收的比特数
txedTrBlkSizes = [];  % 每子帧传输的比特数
%为每个子帧计算传输的总比特数向量。
runningMaxThPut = [];
% 为每个子帧计算存储成功接收比特数的向量。
runningSimThPut = [];
%获取发射天线的数量
dims = lteDLResourceGridSize(enb1);
P = dims(3);
% 为每个码字和每个子帧的传输块大小分配序列
rvSequence = enb1.PDSCH.RVSeq;
trBlkSizes = enb1.PDSCH.TrBlkSizes;
% 设置闭环空间复用的 PMI 延迟
pmiDelay = 8; % 
% 初始化第一个“pmiDelay”子帧的 PMI
pmiDims = ltePMIInfo(enb1,enb1.PDSCH);
txPMIs = zeros(pmiDims.NSubbands, pmiDelay);
%用于指示是否可以从 UE 获得有效 PMI 反馈的标志
pmiReady = false;



fprintf('\nSimulating %d frame(s)\n',NFrames);
% 主循环：对于所有子帧
for subframeNo = 0:(NFrames*10-1)
    % 为每个子帧重新初始化通道种子以增加可变性
    channel1.Seed = 1+subframeNo;
    channel2.Seed = 1+subframeNo+(NFrames*10);
    channel3.Seed = 1+subframeNo+2*(NFrames*10);
    % 更新子帧号
    enb1.NSubframe = subframeNo;
    enb2.NSubframe = subframeNo;
    enb3.NSubframe = subframeNo;
    duplexInfo = lteDuplexingInfo(enb1);
    if  duplexInfo.NSymbolsDL ~= 0 % 仅针对下行链路子帧
        % 从 HARQ 进程序列中获取子帧的 HARQ 进程 ID
        harqID = harqProcessSequence(mod(subframeNo, length(harqProcessSequence))+1);
        %如果当前子帧中有调度的传输块（由非零'harqID'表示），则执行发送和接收。 否则，继续下一个子帧。
        if harqID == 0
            continue;
        end
        % 更新当前 HARQ 进程
        harqProcesses(harqID) = hHARQScheduling( ...
            harqProcesses(harqID), subframeNo, rvSequence);
        % 提取当前子帧传输块大小
        trBlk = trBlkSizes(:, mod(subframeNo, 10)+1).';
        % 使用 HARQ 进程状态更新 PDSCH 传输配置
        enb1.PDSCH.RVSeq = harqProcesses(harqID).txConfig.RVSeq;
        enb1.PDSCH.RV = harqProcesses(harqID).txConfig.RV;
        dlschTransportBlk = harqProcesses(harqID).data;
        % 将 PMI 设置为延迟队列中的适当值
        if strcmpi(enb1.PDSCH.TxScheme,'SpatialMux')
            pmiIdx = mod(subframeNo, pmiDelay);      % 延迟队列中的PMI指数
            enb1.PDSCH.PMISet = txPMIs(:, pmiIdx+1); % 设置PMI
        end
        % 创建发射波形
        [tx,~,enbOut] = lteRMCDLTool(enb1, dlschTransportBlk);
        % 填充 25 个样本以覆盖通道建模预期的延迟范围（实现延迟和通道延迟扩展的组合）
        txWaveform1 = [tx; zeros(25, P)];
        % 从“enbOut”获取 HARQ ID 序列以进行 HARQ 处理
        harqProcessSequence = enbOut.PDSCH.HARQProcessSequence;
        % 函数 hTM4InterfModel 生成干扰发射信号。
        txWaveform2 = [hTM4InterfModel(enb2); zeros(25,P)];
        txWaveform3 = [hTM4InterfModel(enb3); zeros(25,P)];
        % 指定当前子帧的通道时间
        channel1.InitTime = subframeNo/1000;
        channel2.InitTime = channel1.InitTime;
        channel3.InitTime = channel1.InitTime;
        % 通过通道传递数据
        rxWaveform1 = lteFadingChannel(channel1,txWaveform1);
        rxWaveform2 = lteFadingChannel(channel2,txWaveform2);
        rxWaveform3 = lteFadingChannel(channel3,txWaveform3);
        % 产生噪音
        noise = No*complex(randn(size(rxWaveform1)), ...
            randn(size(rxWaveform1)));
        % 将AWGN添加到接收到的时域波形
        rxWaveform = K1*rxWaveform1 + K2*rxWaveform2 + K3*rxWaveform3 + noise;
        % 在子帧 0 上，计算一个新的同步偏移
        if (mod(subframeNo,10) == 0)
            frameOffset = lteDLFrameOffset(enb1, rxWaveform);
            if (frameOffset > 25)
                frameOffset = lastOffset;
            end
            lastOffset = frameOffset;
        end
        % 同步接收波形
        rxWaveform = rxWaveform(1+frameOffset:end, :);
        % 按 1/K1 缩放 rxWaveform 以避免通道解码阶段的数值问题
        rxWaveform = rxWaveform/K1;
        % 对接收到的数据进行OFDM解调得到资源网格
        rxSubframe = lteOFDMDemodulate(enb1, rxWaveform);
        % 执行信道估计
        if(perfectChanEstimator)
            estChannelGrid = lteDLPerfectChannelEstimate(enb1, channel1, frameOffset);
            noiseInterf = K2*rxWaveform2 + K3*rxWaveform3 + noise;
            noiseInterf = noiseInterf/K1;
            noiseGrid = lteOFDMDemodulate(enb1, noiseInterf(1+frameOffset:end ,:));
            noiseEst = var(noiseGrid(:));
        else
            [estChannelGrid, noiseEst] = lteDLChannelEstimate( ...
                enb1, enb1.PDSCH, cec, rxSubframe);
        end
        %获取 PDSCH 索引
        pdschIndices = ltePDSCHIndices(enb1,enb1.PDSCH,enb1.PDSCH.PRBSet);
        % 获取 PDSCH 资源元素。 通过 PDSCH 功率因数 Rho 缩放接收到的子帧。
        [pdschRx, pdschHest] = lteExtractResources(pdschIndices, ...
            rxSubframe*(10^(-enb1.PDSCH.Rho/20)), estChannelGrid);
        % 执行均衡和解预编码
        if strcmp(eqMethod,'MMSE')
            % MIMO 均衡和解预编码（基于 MMSE）
            [rxDeprecoded,csi] = lteEqualizeMIMO(enb1,enb1.PDSCH,...
                pdschRx,pdschHest,noiseEst);
        else
            % MIMO 均衡和解预编码（基于 MMSE-IRC）
            [rxDeprecoded,csi] = hEqualizeMMSEIRC(enb1,enb1.PDSCH,...
                rxSubframe,estChannelGrid,noiseEst);
        end
        % 执行层解映射、解调和解扰
        cws = ltePDSCHDecode(enb1,setfield(enb1.PDSCH,'TxScheme',...
            'Port7-14'),rxDeprecoded); % PDSCH传输方式修改为port7-14，以跳过解预编码操作
        % 通过 CSI 缩放 LLR
        cws = hCSIscaling(enb1.PDSCH,cws,csi);
        % 解码 DL-SCH
        [decbits, harqProcesses(harqID).blkerr,harqProcesses(harqID).decState] = ...
            lteDLSCHDecode(enb1, enb1.PDSCH, trBlk, cws, ...
            harqProcesses(harqID).decState);
        % 存储值以计算吞吐量
        % 仅适用于具有数据和有效 PMI 反馈的子帧
        if any(trBlk) && pmiReady
            blkCRC = [blkCRC harqProcesses(harqID).blkerr];
            txedTrBlkSizes =  [txedTrBlkSizes trBlk];
            bitTput = [bitTput trBlk.*(1-harqProcesses(harqID).blkerr)];
        end
        runningSimThPut = [runningSimThPut sum(bitTput,2)];
        runningMaxThPut = [runningMaxThPut sum(txedTrBlkSizes,2)];
        %向 eNodeB 提供 PMI 反馈
        if strcmpi(enb1.PDSCH.TxScheme,'SpatialMux')
            PMI = ltePMISelect(enb1, enb1.PDSCH, estChannelGrid, noiseEst);
            txPMIs(:, pmiIdx+1) = PMI;
            nPMI = nPMI+1;
            if nPMI>=pmiDelay
                pmiReady = true;
            end
        end
    end
end

maxThroughput = sum(txedTrBlkSizes); %最大可能吞吐量
simThroughput = sum(bitTput,2);      % 模拟吞吐量
% 显示达到的吞吐量百分比
disp(['Achieved throughput ' num2str(simThroughput*100/maxThroughput) '%'])
% 绘制运行吞吐量
figure;plot(runningSimThPut*100./runningMaxThPut)
ylabel('吞吐量(%)');
xlabel('模拟子帧');
title('吞吐量');
