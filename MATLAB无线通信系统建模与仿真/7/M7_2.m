chcfg.DelayProfile = 'EPA';
chcfg.NRxAnts = 1;
chcfg.DopplerFreq = 5;
chcfg.MIMOCorrelation = 'Low';
chcfg.Seed = 1;
chcfg.InitPhase = 'Random';
chcfg.ModelType = 'GMEDS';
chcfg.NTerms = 16;
chcfg.NormalizeTxAnts = 'On';
chcfg.NormalizePathGains = 'On';

rmc = lteRMCDL('R.10');
rmc.TotSubframes = 1;

delay = 25;
for subframeNumber = 0:9    
    rmc.NSubframe = mod(subframeNumber,10);
    chcfg.InitTime = subframeNumber/1000;    
    [txWaveform,txGrid,info] = lteRMCDLTool(rmc,[1;0;1;1]);    
    numTxAnt = size(txWaveform,2);
    chcfg.SamplingRate = info.SamplingRate;    
    rxWaveform = lteFadingChannel(chcfg,[txWaveform; zeros(delay,numTxAnt)]);
end