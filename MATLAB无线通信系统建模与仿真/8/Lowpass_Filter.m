N   = 120;
Fs  = 48e3;
Fp  = 8e3;
Ap  = 0.01;
Ast = 80;
%以线性单位获取通带和阻带纹波的最大偏差。
Rp  = (10^(Ap/20) - 1)/(10^(Ap/20) + 1);
Rst = 10^(-Ast/20);
%使用 firceqrip 设计滤波器并查看幅度频率响应。
NUM = firceqrip(N,Fp/(Fs/2),[Rp Rst],'passedge');
fvtool(NUM,'Fs',Fs)

Fst     = 10e3;
NumMin = firgr('minorder',[0 Fp/(Fs/2) Fst/(Fs/2) 1], [1 1 0 0],[Rp,Rst]);

hvft = fvtool(NUM,1,NumMin,1,'Fs',Fs);
legend(hvft,'N = 120','N = 100')

LP_FIR = dsp.FIRFilter('Numerator',NUM);
SA     = dsp.SpectrumAnalyzer('SampleRate',Fs,'SpectralAverages',5);
tic
while toc < 10
    x = randn(256,1);
    y = LP_FIR(x);
    step(SA,y);
end

LP_FIR = dsp.LowpassFilter('SampleRate',Fs,...
    'DesignForMinimumOrder',false,'FilterOrder',N,...
    'PassbandFrequency',Fp,'PassbandRipple',Ap,'StopbandAttenuation',Ast);

NUM_LP = tf(LP_FIR);

fvtool(LP_FIR,'Fs',Fs);
measure(LP_FIR)

LP_FIR_minOrd = dsp.LowpassFilter('SampleRate',Fs,...
    'DesignForMinimumOrder',true,'PassbandFrequency',Fp,...
    'StopbandFrequency',Fst,'PassbandRipple',Ap,'StopbandAttenuation',Ast);
measure(LP_FIR_minOrd)
Nlp = order(LP_FIR_minOrd)

N = 10;
LP_IIR = dsp.LowpassFilter('SampleRate',Fs,'FilterType','IIR',...
    'DesignForMinimumOrder',false,'FilterOrder',N,...
    'PassbandFrequency',Fp,'PassbandRipple',Ap,'StopbandAttenuation',Ast);

hfvt = fvtool(LP_FIR,LP_IIR,'Fs',Fs);
legend(hfvt,'FIR Equiripple, N = 120', 'IIR Elliptic, N = 10');
cost_FIR = cost(LP_FIR)
cost_IIR = cost(LP_IIR)

SA = dsp.SpectrumAnalyzer('SampleRate',Fs,'SpectralAverages',5);
tic
while toc < 10
    x = randn(256,1);
    y = LP_IIR(x);
    SA(y);
end