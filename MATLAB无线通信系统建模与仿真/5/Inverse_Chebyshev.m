N           = 5;            % 滤波阶数
Fp          = 1/(2*pi);     % 通带截止频率
Ap          = 1;            % 通带衰减
As          = 50;           % 阻带衰减
%使用过滤器对象创建所需的过滤器。逆切比雪夫的唯一实现类型是“传递函数”。
r = rffilter('FilterType','InverseChebyshev','ResponseType','Lowpass',  ...
    'Implementation','Transfer function','FilterOrder',N,               ...
    'PassbandFrequency',Fp,'StopbandAttenuation',As,                    ...
    'PassbandAttenuation',Ap);
%利用tf函数生成传递函数多项式。
[numerator, denominator] = tf(r);
format long g
%显示Numerator{2,1}多项式系数。
disp('传递函数的分子多项式系数');
%传递函数的分子多项式系数
disp(numerator{2,1});

%显示分母的多项式系数。
disp('传递函数的分母多项式系数');
%传递函数的分母多项式系数
disp(denominator);

%可以选择使用“控制系统工具箱”来可视化所有传递函数。
G_s = tf(numerator,denominator)

%可视化滤波器的振幅响应
frequencies = linspace(0,1,1001);
Sparam      = sparameters(r, frequencies);
rfplot(Sparam,2,1)

freq     = 2/(2*pi);
hold on;
setrfplot('noengunits',false);
plot(freq*ones(1,101),linspace(-120,20,101));
%在2 rad/sec处计算准确值
S_freq   = sparameters(r,freq);
As_freq  = 20*log10(abs(rfparam(S_freq,2,1)));
sprintf('2rad/sec的振幅响应为 %d dB',As_freq)
Fs      = r.DesignData.Auxiliary.Wx*r.PassbandFrequency;
sprintf('阻带频率为 -%d dB是: %d Hz',As, Fs)
