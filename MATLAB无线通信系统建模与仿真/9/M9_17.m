ncellid = 42;
pssSym = nrPSS(ncellid);
%获取PSS的资源元素索引。
pssInd = nrPSSIndices();
%创建一个包含生成的PSS符号的资源网格。
txGrid = zeros([240 4]);
txGrid(pssInd) = pssSym;
%OFDM调制资源网格。
txWaveform = ofdmmod(txGrid,512,[40 36 36 36],[1:136 377:512].');
%使用7.68MHz的采样率，通过TDL-C信道模型发送波形。
SR = 7.68e6;
channel = nrTDLChannel;
channel.SampleRate = SR;
channel.DelayProfile = 'TDL-C';
rxWaveform = channel(txWaveform);
%使用PSS符号作为参考符号来估计传输的定时偏移量。参考符号的OFDM调制在15kHz子载波间距跨越20个资源块，并使用初始槽号0。
nrb = 20;
scs = 15;
initialSlot = 0;
offset = nrTimingEstimate(rxWaveform,nrb,scs,initialSlot,pssInd,pssSym)
