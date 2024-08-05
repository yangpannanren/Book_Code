t = 0:0.01:1.27;
s1 = sin(2*pi*45*t);
s2 = s1 + 0.5*[zeros(1,20) s1(1:108)];
%计算并绘制新信号的复倒频谱
c = cceps(s2);
plot(t,c)
y = [4 1 5];                 % 非最小相位序列
[xhat,yhat] = rceps(y);
xhat2 = rceps(yhat); 
[xhat' xhat2']