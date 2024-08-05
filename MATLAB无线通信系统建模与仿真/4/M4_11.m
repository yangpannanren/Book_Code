clear all;
t=[0:pi/60:2*pi];
x=sawtooth(3*t);  %原始信号
initcodebook=[-1:.1:1];  %初始化高斯噪声
%优化参数，使用初始序列initcodebook
[predictor,codebook,partition]=dpcmopt(x,1,initcodebook);
%使用DPCM量化X
encodedx=dpcmenco(x,codebook,partition,predictor);
%尝试从调制信号中恢复X
[decodedx,equant]=dpcmdeco(encodedx,codebook,predictor);
distor=sum((x-decodedx).^2)/length(x)  %均方误差
plot(t,x,t,equant,'*');
