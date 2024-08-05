ckt = read(rfckt.passive,'default.s4p');
data = ckt.AnalyzedResult;
%创建一个数据对象来存储不同的s参数。
diffSparams = rfdata.network;
diffSparams.Freq = data.Freq;
diffSparams.Data = s2sdd(data.S_Parameters);
diffSparams.Z0 = 2*data.Z0;
%使用数据对象中的数据创建一个新的电路对象。
diffCkt = rfckt.passive;
diffCkt.NetworkData = diffSparams;
%分析新的电路对象。
frequencyRange = diffCkt.NetworkData.Freq;
ZL = 50;
ZS = 50;
Z0 = diffSparams.Z0;
analyze(diffCkt,frequencyRange,ZL,ZS,Z0);
diffData = diffCkt.AnalyzedResult;
%将差分s参数写入Touchstone数据文件。
write(diffCkt,'diffsparams.s2p')
