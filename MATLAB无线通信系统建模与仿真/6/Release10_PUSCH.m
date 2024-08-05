% 为FRC A3-2生成配置
frc = lteRMCUL('A3-2');
% UE配置
frc.TotSubframes = 1;   % 子帧总数
frc.NTxAnts = 2;        % 发射天线数量
% 更新物理上行共享通道（PUSCH）配置为2个相同配置的码字
frc.PUSCH.NLayers = 2;
frc.PUSCH.Modulation = repmat({frc.PUSCH.Modulation},1,2);
frc.PUSCH.RV = repmat(frc.PUSCH.RV,1,2);
frc.PUSCH.TrBlkSizes = repmat(frc.PUSCH.TrBlkSizes,2,1);

%设置两个码字的传输块大小和数据
TBSs = frc.PUSCH.TrBlkSizes(:,frc.NSubframe+1); % transport block sizes
trBlks = {(randi([0 1], TBSs(1), 1)) (randi([0 1], TBSs(2), 1))}; % data
% 设置UCI内容
CQI = [1 0 1 0 0 0 1 1 1 0 0 0 1 1].';
RI  = [0 1 1 0].';
ACK = [1 0].';
% UL-SCH编码包括UCI编码
cws = lteULSCH(frc,frc.PUSCH,trBlks,CQI,RI,ACK);
%PUSCH调制
puschSymbols = ltePUSCH(frc,frc.PUSCH,cws);

% PUSCH解调
ulschInfo = lteULSCHInfo(frc,frc.PUSCH,TBSs,length(CQI),length(RI),...
            length(ACK),'chsconcat');    % 获取 UL-SCH信息
llrs = ltePUSCHDecode(frc,ulschInfo,puschSymbols); %PUSCH解码
% UL-SCH解码
softBuffer = [];
[rxtrblks,crc,softBuffer] = lteULSCHDecode(frc,ulschInfo,TBSs,llrs,softBuffer);
% UCI 解码
[llrsData,llrsCQI,llrsRI,llrsACK] = lteULSCHDeinterleave(frc,ulschInfo,llrs);
rxCQI = lteCQIDecode(ulschInfo,llrsCQI);    %CQI解码
rxRI = lteRIDecode(ulschInfo,llrsRI);       % RI解码
rxACK = lteACKDecode(ulschInfo,llrsACK);    % ACK解码