trainModel = false;

%设置可重复性的随机种子（如果使用 GPU，这没有影响）
rng(42)
if trainModel
    %生成训练数据
    [trainData,trainLabels] = hGenerateTrainingData(256);
    %设置每个小批量的实例数
    batchSize = 32;
    % 将实部和虚部网格拆分为 2 个图像集，然后连接
    trainData = cat(4,trainData(:,:,1,:),trainData(:,:,2,:));
    trainLabels = cat(4,trainLabels(:,:,1,:),trainLabels(:,:,2,:));
    % 拆分为训练集和验证集
    valData = trainData(:,:,:,1:batchSize);
    valLabels = trainLabels(:,:,:,1:batchSize);
    trainData = trainData(:,:,:,batchSize+1:end);
    trainLabels = trainLabels(:,:,:,batchSize+1:end);
    % 每个 epoch 验证大约 5 次
    valFrequency = round(size(trainData,4)/batchSize/5);
    % 定义CNN结构
    layers = [ ...
        imageInputLayer([612 14 1],'Normalization','none')
        convolution2dLayer(9,64,'Padding',4)
        reluLayer
        convolution2dLayer(5,64,'Padding',2,'NumChannels',64)
        reluLayer
        convolution2dLayer(5,64,'Padding',2,'NumChannels',64)
        reluLayer
        convolution2dLayer(5,32,'Padding',2,'NumChannels',64)
        reluLayer
        convolution2dLayer(5,1,'Padding',2,'NumChannels',32)
        regressionLayer
    ];
    % 设置训练数据
    options = trainingOptions('adam', ...
        'InitialLearnRate',3e-4, ...
        'MaxEpochs',5, ...
        'Shuffle','every-epoch', ...
        'Verbose',false, ...
        'Plots','training-progress', ...
        'MiniBatchSize',batchSize, ...
        'ValidationData',{valData, valLabels}, ...
        'ValidationFrequency',valFrequency, ...
        'ValidationPatience',5);

    % 训练网络。保存的结构trainingInfo包含训练进度供以后检查。这种结构对于比较不同优化方法的最佳收敛速度很有用。
    [channelEstimationCNN,trainingInfo] = trainNetwork(trainData, ...
        trainLabels,layers,options);
else
    % 如果 trainModel 设置为 false，则加载预训练网络
    load('trainedChannelEstimationNetwork.mat')
end

channelEstimationCNN.Layers

SNRdB = 10;

[gnb,pdsch] = hDeepLearningChanEstSimParameters();

channel = nrTDLChannel;
channel.Seed = 0;
channel.DelayProfile = 'TDL-A';
channel.DelaySpread = 3e-7;
channel.MaximumDopplerShift = 50;
%本实例仅支持SIS 配置
channel.NumTransmitAntennas = 1;
channel.NumReceiveAntennas = 1;
waveformInfo = hOFDMInfo(gnb);
channel.SampleRate = waveformInfo.SamplingRate;

chInfo = info(channel);
maxChDelay = ceil(max(chInfo.PathDelays*channel.SampleRate))+chInfo.ChannelFilterDelay;

% 生成DM-RS索引和符号
[~,dmrsIndices,dmrsSymbols,pdschIndicesInfo] = hPDSCHResources(gnb,pdsch);
% 创建PDSCH网格
pdschGrid = zeros(waveformInfo.NSubcarriers,waveformInfo.SymbolsPerSlot,1);
% 将PDSCH DM-RS符号映射到网格
pdschGrid(dmrsIndices) = pdschGrid(dmrsIndices)+dmrsSymbols;
% OFDM调制相关资源元素
txWaveform = hOFDMModulate(gnb,pdschGrid);

txWaveform = [txWaveform; zeros(maxChDelay,size(txWaveform,2))];
[rxWaveform,pathGains,sampleTimes] = channel(txWaveform);

SNR = 10^(SNRdB/20);    % 计算线性噪声增益
N0 = 1/(sqrt(2.0*gnb.NRxAnts*double(waveformInfo.Nfft))*SNR);
noise = N0*complex(randn(size(rxWaveform)),randn(size(rxWaveform)));
rxWaveform = rxWaveform + noise;


%获取路径过滤器以实现完美的信道估计
pathFilters = getPathFilters(channel);
[offset,~] = nrPerfectTimingEstimate(pathGains,pathFilters);
rxWaveform = rxWaveform(1+offset:end, :);

rxGrid = hOFDMDemodulate(gnb,rxWaveform);
%如果解调了不完整的时隙，则用零填充网格
[K,L,R] = size(rxGrid);
if (L < waveformInfo.SymbolsPerSlot)
    rxGrid = cat(2,rxGrid,zeros(K,waveformInfo.SymbolsPerSlot-L,R));
end

estChannelGridPerfect = nrPerfectChannelEstimate(pathGains, ...
    pathFilters,gnb.NRB,gnb.SubcarrierSpacing, ...
    0,offset,sampleTimes,gnb.CyclicPrefix);

[estChannelGrid,~] = nrChannelEstimate(rxGrid,dmrsIndices, ...
    dmrsSymbols,'CyclicPrefix',gnb.CyclicPrefix, ...
    'CDMLengths',pdschIndicesInfo.CDMLengths);

%使用导频符号位置插入接收到的资源网格
interpChannelGrid = hPreprocessInput(rxGrid,dmrsIndices,dmrsSymbols);
% 沿着批次维度连接实部和虚部网格
nnInput = cat(4,real(interpChannelGrid),imag(interpChannelGrid));
% 使用神经网络估计通道
estChannelGridNN = predict(channelEstimationCNN,nnInput);
% 将结果转换为复数
estChannelGridNN = complex(estChannelGridNN(:,:,:,1),estChannelGridNN(:,:,:,2));

neural_mse = mean(abs(estChannelGridPerfect(:) - estChannelGridNN(:)).^2);
interp_mse = mean(abs(estChannelGridPerfect(:) - interpChannelGrid(:)).^2);
practical_mse = mean(abs(estChannelGridPerfect(:) - estChannelGrid(:)).^2);

plotChEstimates(interpChannelGrid,estChannelGrid,estChannelGridNN,estChannelGridPerfect,...
    interp_mse,practical_mse,neural_mse);