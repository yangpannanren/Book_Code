%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 基本粒子滤波算法
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xo,Xoset]=pf(Xiset,Z,N,k,R,g1,g2)
% 采样策略
resamplingScheme=1;
% 中间变量初始化
Zpre=ones(1,N); %观测预测
Xsetpre=ones(1,N); %粒子集合预测
w = ones(1,N); %权值初始化
% 第一步，粒子采样
for i=1:N
    Xsetpre(i) = ffun(Xiset(i),k) + gengamma(g1,g2);
end
% 第二步:计算粒子权重
for i=1:N
    Zpre(i) = hfun(Xsetpre(i),k);
    w(i) = inv(sqrt(R)) * exp(-0.5*inv(R)*((Z-Zpre(i))^(2))) ...
        + 1e-99; %为了防止权值为0，加了最小数字1e-99
end
w = w./sum(w); %归一化权重
% 第三步，根据权重重新选择粒子
if resamplingScheme == 1
    outIndex = residualR(1:N,w'); %残差采样
elseif resamplingScheme == 2
    outIndex = systematicR(1:N,w'); %系统采样
else
    outIndex = multinomialR(1:N,w'); %多项式采样
end
% 第四步:更新粒子集合，并得到本次计算的最终的估计值
Xoset = Xsetpre(outIndex); %粒子集合更新
Xo=mean(Xoset);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%