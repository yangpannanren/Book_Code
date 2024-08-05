%{定义参数
M = 16; % 调制顺序(信号星座中的字母大小或点数)
k = log2(M); % 每个符号的位数
n = 30000; % 数据流长度
%}

sps = 1; %每个符号的采样数(过采样系数)


rng default;
dataIn = randi([0 1],n,1); %生成二进制数据的矢量

stem(dataIn(1:40),'filled');
title('随机比特');
xlabel('比特序列');
ylabel('二进制值');

%
dataInMatrix = reshape(dataIn,length(dataIn)/k,k);
dataSymbolsIn = bi2de(dataInMatrix);
%在散点图中前10个符号
figure; % 创建一个新的图形窗口
stem(dataSymbolsIn(1:10));
title('随机符号');
xlabel('符号序列');
ylabel('二进制值');

dataMod = qammod(dataSymbolsIn,M,'bin'); % 相位偏移为零的二进制编码
dataModG = qammod(dataSymbolsIn,M); % 相位偏移为零的灰度编码

EbNo = 10;
snr = EbNo+10*log10(k)-10*log10(sps);
%将信号通过AWGN信道进行二进制和灰色编码的符号映射
receivedSignal = awgn(dataMod,snr,'measured');
receivedSignalG = awgn(dataModG,snr,'measured');

sPlotFig = scatterplot(receivedSignal,1,0,'g.');
hold on
scatterplot(dataMod,1,0,'k*',sPlotFig)
title('绘制散点图');
xlabel('同相分量');ylabel('正交分量')

dataSymbolsOut = qamdemod(receivedSignal,M,'bin');
dataSymbolsOutG = qamdemod(receivedSignalG,M);


dataOutMatrix = de2bi(dataSymbolsOut,k);
dataOut = dataOutMatrix(:); % 返回列向量中的数据
dataOutMatrixG = de2bi(dataSymbolsOutG,k);
dataOutG = dataOutMatrixG(:); % 返回列向量中的数据

[numErrors,ber] = biterr(dataIn,dataOut);
fprintf('\n二进制编码误码率为 %5.2e, 基于 %d 误码数.\n',ber,numErrors)

[numErrorsG,berG] = biterr(dataIn,dataOutG);
fprintf('\n灰色编码误码率为 %5.2e, 基于 %d 误码数.\n',berG,numErrorsG)


M = 16; % 模型阶数
x = (0:15); % 整数输入
symbin = qammod(x,M,'bin'); % 16-QAM输出(natural-coded二进制)
symgray = qammod(x,M,'gray'); % 16-QAM输出 (Gray-coded)

scatterplot(symgray,1,0,'b*');
for k = 1:M
    text(real(symgray(k)) - 0.0,imag(symgray(k)) + 0.3,...
        dec2base(x(k),2,4));
     text(real(symgray(k)) - 0.5,imag(symgray(k)) + 0.3,...
         num2str(x(k)));    
    text(real(symbin(k)) - 0.0,imag(symbin(k)) - 0.3,...
        dec2base(x(k),2,4),'Color',[1 0 0]);
    text(real(symbin(k)) - 0.5,imag(symbin(k)) - 0.3,...
        num2str(x(k)),'Color',[1 0 0]);
end
title('16-QAM 符号映射')
axis([-4 4 -4 4])
xlabel('同相分量');ylabel('正交分量')