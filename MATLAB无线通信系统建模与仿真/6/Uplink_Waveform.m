ue = struct;
ue.NULRB = 15;                  % 资源块数量
ue.NCellID = 10;                % 物理层特性
ue.Hopping = 'Off';             % 禁用跳频
ue.CyclicPrefixUL = 'Normal';   % 正常循环前缀
ue.DuplexMode = 'FDD';          % 双频分（FDD）
ue.NTxAnts = 1;                 % 发射天线数量
ue.NFrame = 0;                  % 帧数

pucch = struct;
% PUCCH资源索引向量，每个传输天线一个
pucch.ResourceIdx = 0:ue.NTxAnts-1;
pucch.DeltaShift = 1;               % PUCCH增量移位参数
pucch.CyclicShifts = 0;             % PUCCH增量偏移参数
pucch.ResourceSize = 0;             % 分配给PUCCH的资源大小

srs = struct;
srs.NTxAnts = 1;        % 发射天线数量
srs.SubframeConfig = 3; %  SRS 周期= 5ms, 偏移 = 0
srs.BWConfig = 6;       % SRS带宽配置
srs.BW = 0;             %UE特有的SRS带宽配置
srs.HoppingBW = 0;      % SRS跳频配置
srs.TxComb = 0;         % 偶指数蜂窝传输
srs.FreqPosition = 0;   %频域位置
srs.ConfigIdx = 7;      % UE特有SRS period = 10ms, offset = 0
srs.CyclicShift = 0;    % UE跳频


txGrid = [];    % 创建空的资源网格
for i = 1:10    % 10个子帧程序
        % 配置子帧号(基于0)
        ue.NSubframe = i-1;
        fprintf('Subframe %d:\n',ue.NSubframe);
       %确定此子帧是否为cell-specific SRS子帧，如果是，配置PUCCH以缩短传输
        srsInfo = lteSRSInfo(ue, srs);
        ue.Shortened = srsInfo.IsSRSSubframe; % 复制SRS信息到UE结构
        % 创建空上行链路子帧
        txSubframe = lteULResourceGrid(ue);
        % 生成PUCCH1 DRS并将其映射到资源网格
        drsIndices = ltePUCCH1DRSIndices(ue, pucch);% DRS索引
        drsSymbols = ltePUCCH1DRS(ue, pucch);       % DRS序列
        txSubframe(drsIndices) = drsSymbols;        % 映射到资源网格
        % 生成并映射PUCCH1到资源网格
        pucchIndices = ltePUCCH1Indices(ue, pucch); % PUCCH1指数
        ACK = [0; 1];                               % HARQ指示值
        pucchSymbols = ltePUCCH1(ue, pucch, ACK);   % PUCCH1序列
        txSubframe(pucchIndices) = pucchSymbols;    % 映射到资源网格
        if (ue.Shortened)
            disp('PUCCH短传输');
        else
            disp('PUCCH长传输');
        end        
        srs.SeqGroup = mod(ue.NCellID,30);
        % 根据TS 36.211 5.5.1.4配置SRS base sequence number (v)
        srs.SeqIdx = 0;
        % 生成SRS并将其映射到资源网格(在特定于UE的SRS配置下处于活动状态)
        [srsIndices, srsIndicesInfo] = lteSRSIndices(ue, srs);% SRS索引
        srsSymbols = lteSRS(ue, srs);                         % SRS 顺序
        if (srs.NTxAnts == 1 && ue.NTxAnts > 1) % 映射到资源网格
            % 在多天线中选择分集天线
            txSubframe( ...
                hSRSOffsetIndices(ue, srsIndices, srsIndicesInfo.Port)) = ...
                srsSymbols;
        else
            txSubframe(srsIndices) = srsSymbols;
        end
        %到控制台的消息，指示何时将SRS映射到资源网格。
        if(~isempty(srsIndices))
            disp('Transmitting SRS');
        end
        %连接子框以形成框
        txGrid = [txGrid txSubframe]; %#ok
end

figure;
for i = 1:ue.NTxAnts
    subplot(ue.NTxAnts,1,i);
    plot(0:size(txGrid,2)-1,sum(abs(txGrid(:,:,i)) ~= 0),'r:o')
    xlabel('符号数');
    ylabel('活跃的副载波');
    title(sprintf('天线 %d',i-1));
end

figure;
pcolor(abs(txGrid));
colormap([1 1 1; 0 0 0.5])
shading flat;
xlabel('SC-FDMA符号'); ylabel('副载波')