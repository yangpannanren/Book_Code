b = fir1(1024, .5);
[d,p0] = lpc(b,7);

rng(0,'twister'); %允许复制精确的实验
u = sqrt(p0)*randn(8192,1); % 方差为p0的高斯白噪声

x = filter(1,d,u);

[d1,p1] = aryule(x,7);

[H1,w1] = freqz(sqrt(p1),d1);