% 系统仿真参数
Fs = 1;           % 采样频率
nBits = 2048;     % 每个向量的BPSK符号数
maxErrs = 200;    % 每个Eb/No的目标错误数
maxBits = 1e6;    % 每个Eb/No的最大符号数
%调制信号参数
M = 2;                     % 模型阶数
Rs = Fs;                   % 符号率
nSamp = Fs/Rs;             % 每个符号样本
Rb = Rs*log2(M);           % 比特率
% 通道参数
chnl = [0.227 0.460 0.688 0.460 0.227]';  % 信道脉冲响应
chnlLen = length(chnl);                   % 样本中的通道长度
EbNo = 0:14;                              
BER = zeros(size(EbNo));                  % 初始化值
% 创建 BPSK模型
bpskMod = comm.BPSKModulator;
% 为随机数生成器指定种子以确保可重复性。
rng(12345)

% 线性均衡器参数
nWts = 31;               % 数量的权重
algType = 'RLS';         %RLS算法
forgetFactor = 0.999999; % RLS算法参数
% DFE参数-使用与线性均衡器相同的更新算法
nFwdWts = 15;            % 前馈权值的个数
nFbkWts = 15;            % 反馈权重数

% MLSE均衡器参数
tbLen = 30;                        %MLSE均衡器回溯长度
numStates = M^(chnlLen-1);         
[mlseMetric,mlseStates,mlseInputs] = deal([]);
const = constellation(bpskMod);    % 信号星座
mlseType = 'ideal';                % 完善的信道估计
mlseMode = 'cont';                 % 没有MLSE重置
%信道估计参数
chnlEst = chnl;         %完善的最初估计
prefixLen = 2*chnlLen;  % 循环前缀长度
excessEst = 1;          % 超出真实长度的估计信道脉冲响应长度   
%%初始化模拟图形。绘制一个理想BPSK系统的非均衡信道频率响应和误码率。
idealBER = berawgn(EbNo,'psk',M,'nondiff');
[hBER, hLegend,legendString,hLinSpec,hDfeSpec,hErrs,hText1,hText2, ...
  hFit,hEstPlot,hFig,hLinFig,hDfeFig] = eqber_graphics('init', ...
  chnl,EbNo,idealBER,nBits);


linEq = comm.LinearEqualizer('Algorithm', algType, ...
  'ForgettingFactor', forgetFactor, ...
  'NumTaps', nWts, ...
  'Constellation', const, ...
  'ReferenceTap', round(nWts/2), ...
  'TrainingFlagInputPort', true);

dfeEq = comm.DecisionFeedbackEqualizer('Algorithm', algType, ...
  'ForgettingFactor', forgetFactor, ...
  'NumForwardTaps', nFwdWts, ...
  'NumFeedbackTaps', nFbkWts, ...
  'Constellation', const, ...
  'ReferenceTap', round(nFwdWts/2), ...
  'TrainingFlagInputPort', true);

 firstRun = true;  %标记以确保噪音和数据的初始状态
eqType = 'linear';
eqber_adaptive;  

close(hFig(ishghandle(hFig)));
eqType = 'dfe';
eqber_adaptive;

 close(hLinFig(ishghandle(hLinFig)),hDfeFig(ishghandle(hDfeFig)));
eqType = 'mlse';
mlseType = 'ideal';
eqber_mlse;

mlseType = 'imperfect';
eqber_mlse;

firstRun = true;  %标记以确保噪音和数据的初始状态
eqType = 'linear';
eqber_adaptive;
firstRun = true;  %标记以确保噪音和数据的初始状态
eqType = 'linear';
eqber_adaptive;