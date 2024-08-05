%为物理层单元识别号42生成物理广播信道(PBCH)解调参考信号(DM-RS)符号
ncellid = 42;
ibar_SSB = 0;
dmrsSym = nrPBCHDMRS(ncellid,ibar_SSB);
%获取PBCH DM-RS的资源要素指数。
dmrsInd = nrPBCHDMRSIndices(ncellid);
%创建一个包含生成的DM-RS符号的资源网格。
nTxAnts = 1;
txGrid = complex(zeros([240 14 nTxAnts]));
txGrid(dmrsInd) = dmrsSym;
%使用指定的FFT长度和循环前缀长度调制资源网格。
nFFT = 512;
cpLengths = ones(1,14) * 36;
cpLengths([1 8]) = 40;
nulls = [1:136 377:512].';
txWaveform = ofdmmod(txGrid,nFFT,cpLengths,nulls);
%使用指定的属性创建一个TDL-C通道模型。
SR = 7.68e6;
channel = nrTDLChannel;
channel.NumReceiveAntennas = 1;
channel.SampleRate = SR;
channel.DelayProfile = 'TDL-C';
channel.DelaySpread = 100e-9;
channel.MaximumDopplerShift = 20;
%利用信道滤波器的最大时延和实现时延，从信道路径中获得最大延迟采样数。
chInfo = info(channel);
maxChDelay = ceil(max(chInfo.PathDelays*SR)) + chInfo.ChannelFilterDelay;
%为了从信道中清除延迟采样，在发射波形的末端附加最大延迟采样数和发射天线数对应的零。通过TDL-C信道模型发送填充波形。
[rxWaveform,pathGains] = channel([txWaveform; zeros(maxChDelay,nTxAnts)]);
%使用DM-RS符号作为参考符号估计传输的定时偏移量。参考符号的OFDM调制以15kHz子载波间距跨越20个资源块，并使用初始槽号0。
nrb = 20;
scs = 15;
initialSlot = 0;
offset = nrTimingEstimate(rxWaveform,nrb,scs,initialSlot,dmrsInd,dmrsSym);
%根据估计的定时偏移同步接收的波形。
rxWaveform = rxWaveform(1+offset:end,:);
%创建包含解调和同步接收波形的接收资源网格。
rxLength = sum(cpLengths) + nFFT*numel(cpLengths);
cpFraction = 0.55;
symOffsets = fix(cpLengths * cpFraction);
rxGrid = ofdmdemod(rxWaveform(1:rxLength,:),nFFT,cpLengths,symOffsets,nulls);
%获得实际的信道估计。
H = nrChannelEstimate(rxGrid,dmrsInd,dmrsSym);
%获得完美的信道估计。
pathFilters = getPathFilters(channel);
H_ideal = nrPerfectChannelEstimate(pathGains,pathFilters,nrb,scs,initialSlot,offset);
%比较实际和完善的信道估计。
figure;
subplot(1,2,1);
imagesc(abs(H));
xlabel('OFDM符号');
ylabel('副载波');
title('实际估计大小');
subplot(1,2,2);
imagesc(abs(H_ideal));
xlabel('OFDM符号');
ylabel('副载波');
title('完美估计大小');
