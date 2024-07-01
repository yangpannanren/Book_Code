%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：比较白噪声和有色噪声
% Fig.3-11、3-12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function white_noise_and_colored_noise_compare1
% 参数设置
N=500; %时间序列长度
MEAN=0; %噪声的均值
VAR=1; %设置方差
X=MEAN+VAR*randn(1,N); %产生均值0.5,方差为1的白噪声X
Y=zeros(1,N); %产生有色噪声
Y(1)=X(1);
for k=2:N
    Y(k)=X(k)+0.5*X(k-1);
end
[Fx, fx]=myFFT(X',512); %计算白噪声的功率谱
Zx=1/N*Fx.*conj(Fx);
[Fy, fy]=myFFT(Y',512); %计算有色噪声的功率谱
Zy=1/N*Fy.*conj(Fy);
% 图1,显示两种信号的对比图
figure
subplot(2,1,1)
plot(X,'-b');
xlabel('k');
ylabel('白噪声')
subplot(2,1,2)
plot(Y,'-b','MarkerFace','g');
xlabel('k');
ylabel('有色噪声')
title('白噪声和有色噪声的对比')
% 测试功率谱
figure
subplot(2,1,1);
plot(fx,Zx);
xlabel('k');
ylabel('白噪声的频谱')
subplot(2,1,2);
plot(fy,Zy);
xlabel('k');
ylabel('有色噪声的频谱')
title('白噪声和有色噪声的频谱对比')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%