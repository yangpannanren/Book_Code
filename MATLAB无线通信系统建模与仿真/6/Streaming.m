Fs = 2500;
Sineobject1 = dsp.SineWave('SamplesPerFrame',1024,...
                     'SampleRate',Fs,'Frequency',100);
Sineobject2 = dsp.SineWave('SamplesPerFrame',1024,...
                     'SampleRate',Fs,'Frequency',1000);

SA = dsp.SpectrumAnalyzer('SampleRate',Fs,'NumInputPorts',2,...
    'PlotAsTwoSidedSpectrum',false,...
    'ChannelNames',{'SinewaveInput','NotchOutput'},'ShowLegend',true);

Wo = 750;
Q  = 35;
BW = Wo/Q;
NotchFilter = dsp.NotchPeakFilter('Bandwidth',BW,...
    'CenterFrequency',Wo, 'SampleRate',Fs);
fvtool(NotchFilter);

FreqVec = [100 500 750 1000];
VecIndex = 1;
VecElem = FreqVec(VecIndex);
for Iter = 1:3000
    Sinewave1 = Sineobject1();
    Sinewave2 = Sineobject2();
    Input = Sinewave1 + Sinewave2;
    if (mod(Iter,350)==0)
        if VecIndex < 4
            VecIndex = VecIndex+1;
        else
            VecIndex = 1;
        end
        VecElem = FreqVec(VecIndex);
    end
    NotchFilter.CenterFrequency = VecElem;
    NotchFilter.Bandwidth = NotchFilter.CenterFrequency/Q;
    Output = NotchFilter(Input);
    SA(Input,Output);
end
fvtool(NotchFilter)