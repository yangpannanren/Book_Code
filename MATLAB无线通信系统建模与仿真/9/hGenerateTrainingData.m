function [trainData,trainLabels] = hGenerateTrainingData(dataSize)
%执行完美的定时同步和OFDM解调，在每次迭代时提取导频符号并执行线性插值。 
%使用完美的通道信息来创建标签数据。该函数返回2个数组：训练数据和标签。
    fprintf('Starting data generation...\n')
    % 可能的频道配置文件列表
    delayProfiles = {'TDL-A', 'TDL-B', 'TDL-C', 'TDL-D', 'TDL-E'};
    [gnb, pdsch] = hDeepLearningChanEstSimParameters();
    % 创建通道模型对象
    nTxAnts = gnb.NTxAnts;
    nRxAnts = gnb.NRxAnts;
    channel = nrTDLChannel; % TDL 通道对象
    channel.NumTransmitAntennas = nTxAnts;
    channel.NumReceiveAntennas = nRxAnts;
    % 使用从 <matlab:edit('hOFDMInfo') hOFDMInfo> 返回的值来设置信道模型采样率
    waveformInfo = hOFDMInfo(gnb);
    channel.SampleRate = waveformInfo.SamplingRate;
    %得到一个信道多径分量的最大延迟采样数。这个数字是从延迟最大的信道路径和信道滤波器的实现延迟计算出来的，需要冲洗信道滤波器以获得接收信号。
    chInfo = info(channel);
    maxChDelay = ceil(max(chInfo.PathDelays*channel.SampleRate)) + chInfo.ChannelFilterDelay;
    % 返回 DM-RS 索引和符号
    [~,dmrsIndices,dmrsSymbols,~] = hPDSCHResources(gnb,pdsch);
    % 与PDSCH传输周期相关的网格中的PDSCH映射
    pdschGrid = zeros(waveformInfo.NSubcarriers,waveformInfo.SymbolsPerSlot,nTxAnts);
    % PDSCH DM-RS 预编码和映射
    [~,dmrsAntIndices] = nrExtractResources(dmrsIndices,pdschGrid);
    pdschGrid(dmrsAntIndices) = pdschGrid(dmrsAntIndices) + dmrsSymbols;
    % 相关资源元素的 OFDM 调制
    txWaveform_original = hOFDMModulate(gnb,pdschGrid);
    % 获取用于神经网络预处理的线性插值器坐标
    [rows,cols] = find(pdschGrid ~= 0);
    dmrsSubs = [rows, cols, ones(size(cols))];
    hest = zeros(size(pdschGrid));
    [l_hest,k_hest] = meshgrid(1:size(hest,2),1:size(hest,1));
    % 为训练数据和标签预分配内存
    numExamples = dataSize;
    [trainData, trainLabels] = deal(zeros([612 14 2 numExamples]));
    %数据生成的主循环，迭代函数调用中指定的实例数量。 
    %循环的每次迭代都会产生一个具有随机延迟扩展、多普勒频移和延迟分布的新信道实现。 
    %带有DM-RS符号的传输波形的每个扰动都存储在trainData中，并且在trainLabels中实现了完美的信道。
    for i = 1:numExamples
        % 释放通道以更改不可调属性
        channel.release
        % 选择一个随机种子来创建不同的通道实现
        channel.Seed = randi([1001 2000]);
        % 选择随机延迟分布、延迟扩展和最大多普勒频移
        channel.DelayProfile = string(delayProfiles(randi([1 numel(delayProfiles)])));
        channel.DelaySpread = randi([1 300])*1e-9;
        channel.MaximumDopplerShift = randi([5 400]);
        % 通过通道模型发送数据。在传输的波形末尾添加零以刷新通道内容。 
        %这些零考虑了信道中引入的任何延迟，例如多径延迟和实现延迟。此值取决于采样率、延迟配置文件和延迟扩展
        txWaveform = [txWaveform_original; zeros(maxChDelay, size(txWaveform_original,2))];
        [rxWaveform,pathGains,sampleTimes] = channel(txWaveform);
        %将加性高斯白噪声(AWGN)添加到接收到的时域波形中。要考虑采样率，请对噪声功率进行归一化。 
        %SNR是针对每个接收天线按RE定义的 (3GPP TS 38.101-4)。
        SNRdB = randi([0 10]);  % 0到10dB之间的随机SNR值
        SNR = 10^(SNRdB/20);    %计算线性噪声增益
        N0 = 1/(sqrt(2.0*nRxAnts*double(waveformInfo.Nfft))*SNR);
        noise = N0*complex(randn(size(rxWaveform)),randn(size(rxWaveform)));
        rxWaveform = rxWaveform + noise;
        %完美同步。 使用信道提供的信息找到最强的多径分量
        pathFilters = getPathFilters(channel); % 获取路径过滤器以实现完美的信道估计
        [offset,~] = nrPerfectTimingEstimate(pathGains,pathFilters);
        rxWaveform = rxWaveform(1+offset:end, :);
        % 对接收到的数据执行OFDM解调以重新创建资源网格，包括填充以防实际同步导致解调不完整时隙
        rxGrid = hOFDMDemodulate(gnb,rxWaveform);
        [K,L,R] = size(rxGrid);
        if (L < waveformInfo.SymbolsPerSlot)
            rxGrid = cat(2,rxGrid,zeros(K,waveformInfo.SymbolsPerSlot-L,R));
        end
        %使用信道提供的路径增益值实现完美的信道估计。该信道估计不包括发射机预编码的影响
        estChannelGridPerfect = nrPerfectChannelEstimate(pathGains, ...
            pathFilters,gnb.NRB,gnb.SubcarrierSpacing,0,offset, ...
            sampleTimes,gnb.CyclicPrefix);
        % 线性插值
        dmrsRx = rxGrid(dmrsIndices);
        dmrsEsts = dmrsRx .* conj(dmrsSymbols);
        f = scatteredInterpolant(dmrsSubs(:,2),dmrsSubs(:,1),dmrsEsts);
        hest = f(l_hest,k_hest);
        %将内插网格拆分为实部和虚部，并沿第三维将它们连接起来，以用于真实通道响应
        rx_grid = cat(3, real(hest), imag(hest));
        est_grid = cat(3, real(estChannelGridPerfect), ...
            imag(estChannelGridPerfect));
        %将生成的训练实例和标签添加到相应的数组
        trainData(:,:,:,i) = rx_grid;
        trainLabels(:,:,:,i) = est_grid;
        % 数据生成跟踪器
        if mod(i,round(numExamples/25)) == 0
            fprintf('%3.2f%% complete\n',i/numExamples*100);
        end
    end
    fprintf('Data generation complete!\n')
end