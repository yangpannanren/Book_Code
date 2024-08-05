Fs = 1e3;
t = 0:1/Fs:1-1/Fs;
comp1 = cos(2*pi*200*t).*(t>0.7);
comp2 = cos(2*pi*60*t).*(t>=0.1 & t<0.3);
trend = sin(2*pi*1/2*t);
rng default
wgnNoise = 0.4*randn(size(t));
x = comp1+comp2+trend+wgnNoise;
mra = modwtmra(modwt(x,8));
helperMRAPlot(x,mra,t,'wavelet','小波MRA',[2 3 4 9])

%绘制同一信号的EMD分析图
[imf_emd,resid_emd] = emd(x);
helperMRAPlot(x,imf_emd,t,'emd','经验模态分解',[1 2 3 6])

[imf_vmd,resid_vmd] = vmd(x);
helperMRAPlot(x,imf_vmd,t,'vmd','变分模态分解',[2 4 5])