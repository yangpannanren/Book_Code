Fs = 44100;
Sineobject1 = dsp.SineWave('SamplesPerFrame',1024,'PhaseOffset',10,...
    'SampleRate',Fs,'Frequency',1000);
Sineobject2 = dsp.SineWave('SamplesPerFrame',1024,...
    'SampleRate',Fs,'Frequency',5000);
SA = dsp.SpectrumAnalyzer('SampleRate',Fs,'Method','Filter bank',...
    'SpectrumType','Power','PlotAsTwoSidedSpectrum',false,...
    'ChannelNames',{'Power spectrum of the input'},'YLimits',[-120 40],'ShowLegend',true);
data = [];
for Iter = 1:7000
    Sinewave1 = Sineobject1();
    Sinewave2 = Sineobject2();
    Input = Sinewave1 + Sinewave2;
    NoisyInput = Input + 0.001*randn(1024,1);
    SA(NoisyInput);
     if SA.isNewDataReady
        data = [data;getSpectrumData(SA)];
     end
end
release(SA);
release(Sineobject2);
Sineobject2.Frequency = 1015;
for Iter = 1:5000
    Sinewave1 = Sineobject1();
    Sinewave2 = Sineobject2();
    Input = Sinewave1 + Sinewave2;
    NoisyInput = Input + 0.001*randn(1024,1);
    SA(NoisyInput);
end
release(SA);
SA.RBWSource = 'property';
SA.RBW = 1;
for Iter = 1:5000
    Sinewave1 = Sineobject1();
    Sinewave2 = Sineobject2();
    Input = Sinewave1 + Sinewave2;
    NoisyInput = Input + 0.001*randn(1024,1);
    SA(NoisyInput);
end
release(SA);
release(Sineobject2);
SA.RBWSource = 'Auto';
for Iter = 1:5000
    Sinewave1 = Sineobject1();
    if (mod(Iter,1000) == 0)
        release(Sineobject2);
        Sineobject2.Frequency = Iter;
        Sinewave2 = Sineobject2();
    else
        Sinewave2 = Sineobject2();
    end
    Input = Sinewave1 + Sinewave2;
    NoisyInput = Input + 0.001*randn(1024,1);
    SA(NoisyInput);
end
release(SA);
Fs = 44100;
Sineobject1 = dsp.SineWave('SamplesPerFrame',1024,'PhaseOffset',10,...
    'SampleRate',Fs,'Frequency',1000);
Sineobject2 = dsp.SineWave('SamplesPerFrame',1024,...
    'SampleRate',Fs,'Frequency',5000);

SpecEst = dsp.SpectrumEstimator('Method','Filter bank',...
    'PowerUnits','dBm','SampleRate',Fs,'FrequencyRange','onesided');
ArrPlot = dsp.ArrayPlot('PlotType','Line','ChannelNames',{'Power spectrum of the input'},...
    'YLimits',[-80 30],'XLabel','Number of samples per frame','YLabel',...
    'Power (dBm)','Title','One-sided power spectrum with respect to samples');
for Iter = 1:5000
    Sinewave1 = Sineobject1();
    Sinewave2 = Sineobject2();
    Input = Sinewave1 + Sinewave2;
    NoisyInput = Input + 0.001*randn(1024,1);
    PSoutput = SpecEst(NoisyInput);
    ArrPlot(PSoutput);
end
ArrPlot.SampleIncrement = (Fs/1000)/1024;
ArrPlot.XLabel = 'Frequency (kHz)';
ArrPlot.Title = 'One-sided power spectrum with respect to frequency';

for Iter = 1:5000
    Sinewave1 = Sineobject1();
    Sinewave2 = Sineobject2();
    Input = Sinewave1 + Sinewave2;
    NoisyInput = Input + 0.001*randn(1024,1);
    PSoutput = SpecEst(NoisyInput);
    ArrPlot(PSoutput);
end
