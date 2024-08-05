SampPerFrame = 1000;
Fs = 1000;
SW = dsp.SineWave('Frequency', 100, ...
  'SampleRate', Fs, 'SamplesPerFrame', SampPerFrame);
TS = dsp.TimeScope('SampleRate', Fs, 'TimeSpan', 0.1, ...
    'YLimits', [-2, 2], 'ShowGrid', true);
SA = dsp.SpectrumAnalyzer('SampleRate', Fs);
tic;
while toc < 5
  sigData = SW() + 0.05*randn(SampPerFrame,1);
  TS(sigData);
  SA(sigData);
end

Fs = 360;
frameSize = 500;
fileName = 'ecgsig.mat';
winLen = 13; % Window length for the filters.

