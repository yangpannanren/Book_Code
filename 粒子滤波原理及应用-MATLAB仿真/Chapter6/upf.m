%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 用UKF改进的粒子滤波算法--EPF
% 用UKF产生建议分布
% 输入参数说明：
%    Xiset是上t-1时刻的粒子集合，Z是t时刻的观测
%    Pin对应Xiset粒子集合的方差\
% 输出参数说明：
%    Xo是upf算法最终的估计结果
%    Xoset是k时刻的粒子集合，其均值就是Xo
%    Pout是Xoset对应的方差
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xo,Xoset,Pout]=upf(Xiset,Z,t,Pin,N,R,Qukf,Rukf,g1,g2)
% 采样策略
resamplingScheme=1;
% 中间变量初始化
Xukf=ones(1,N); %UKF估计结果
Xset_pre=ones(1,N); %UKF的一步预测
Zpre=ones(1,N); %观测预测
Pout=ones(1,N); %协方差预测
w = ones(1,N); %权值初始化
% 第一步:粒子采样
for i=1:N
% 利用 UKF 计算得到 UKF的状态和方差
    [Xukf(i),Pout(i)]=ukf(Xiset(i),Z,Pin(i),Qukf,Rukf,t);
% 根据均值Xukf(i)和方差Pout(i)，为粒子集合采样
    Xset_pre(i) = Xukf(i) + sqrtm(Pout(i))*randn;
end
% 第二步:计算权重
for i=1:N
% 观测预测
    Zpre(i) = hfun(Xset_pre(i),t);
% 计算权重
    lik = inv(sqrt(R)) * exp(-0.5*inv(R)*((Z-Zpre(i))^(2)))+1e-99;
    prior = ((Xset_pre(i)-Xiset(i))^(g1-1)) * exp(-g2*(Xset_pre(i)-Xiset(i)));
    proposal = inv(sqrt(Pout(i))) * ...
        exp(-0.5*inv(Pout(i)) *((Xset_pre(i)-Xukf(i))^(2)));
    w(i) = lik*prior/proposal;
end
% 权值归一化
w = w./sum(w);
% 第三步:重采样
if resamplingScheme == 1
    outIndex = residualR(1:N,w'); %残差采样
elseif resamplingScheme == 2
    outIndex = systematicR(1:N,w'); %系统采样
else
    outIndex = multinomialR(1:N,w'); %多项式采样
end
% 第四步:集合更新
Xoset = Xset_pre(outIndex); % 粒子集合更新
Pout = Pout(outIndex); %方差更新
% 均值，作为最终估计
Xo = mean(Xoset);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%