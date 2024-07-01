% 函数说明:实现快速Fourier变换
% 输入参数:Xt为时域信号序列，sf为sample frequent简称，即采样频率
% 输出参数:Fs为经过FFT变换后的频域序列，f为其响应频率
function [Fs,f] = myFFT(Xt,sf)
L = length(Xt); %得到信号的数据长度
% 2^(NFFT)>=L，已知L，求最符合要求的NFFT的数值，要求NFET为整数
% 举个例子:如果工等于100，则NFFT=7，因为2的7次方等于128，而128是所有大于
% 100的2的整数次幂数字中最小的一个。
NFFT = 2^nextpow2(L);
% 做 FFT 变换
Fs = fft(Xt,NFFT)/L;
% 取模
Fs = 2*abs(Fs(1:NFFT/2+1));
% linspace()是用来生成等间距数组的方法
f = sf/2 * linspace(0,1,NFFT/2+1);