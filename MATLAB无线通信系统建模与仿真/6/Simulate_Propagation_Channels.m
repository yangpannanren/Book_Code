enb.NDLRB = 9;
enb.CyclicPrefix = 'Normal';
enb.PHICHDuration = 'Normal';
enb.CFI = 3;
enb.Ng = 'Sixth';
enb.CellRefP = 1;
enb.NCellID = 10;
enb.NSubframe = 0;
enb.DuplexMode = 'FDD';
antennaPort = 0;

subframe = lteDLResourceGrid(enb);

cellRSsymbols = lteCellRS(enb,antennaPort);
cellRSindices = lteCellRSIndices(enb,antennaPort,{'1based'});
subframe(cellRSindices) = cellRSsymbols;

[txWaveform,info] = lteOFDMModulate(enb,subframe);

channel.Seed = 1;
channel.NRxAnts = 1;
channel.DelayProfile = 'EVA';
channel.DopplerFreq = 5;
channel.MIMOCorrelation = 'Low';
channel.SamplingRate = info.SamplingRate;
channel.InitTime = 0;

rxWaveform = lteFadingChannel(channel,txWaveform);
size(rxWaveform)

title = '波形前和后衰落信道';
saScope = dsp.SpectrumAnalyzer('SampleRate',info.SamplingRate,'ShowLegend',true,...
    'SpectralAverages',10,'Title',title,'ChannelNames',{'Before','After'});
saScope([txWaveform,rxWaveform]);