Sine1 = dsp.SineWave('Frequency',1e3,'SampleRate',44.1e3);
Sine2 = dsp.SineWave('Frequency',10e3,'SampleRate',44.1e3);

FIRLowPass = dsp.LowpassFilter('PassbandFrequency',5000,...
    'StopbandFrequency',8000);

SpecAna = dsp.SpectrumAnalyzer('PlotAsTwoSidedSpectrum',false, ...
    'SampleRate',Sine1.SampleRate, ...
    'NumInputPorts',2,...
    'ShowLegend',true, ...
    'YLimits',[-145,45]);

SpecAna.ChannelNames = {'Original noisy signal','Low pass filtered signal'};

Sine1.SamplesPerFrame = 4000;
Sine2.SamplesPerFrame = 4000;

for i = 1 : 1000
    x = Sine1()+Sine2()+0.1.*randn(Sine1.SamplesPerFrame,1);
    y = FIRLowPass(x);
    SpecAna(x,y);
end
release(SpecAna)