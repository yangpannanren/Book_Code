%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 用EKE改进的粒子滤波算法--EPF
% 用EKF产生建议分布
% 输入参数说明:
%   Xiset是上t-1时刻的粒子集合，Z是t时刻的观测
%   Pin对应xiset粒子集合的方差
% 输出参数说明:
%   Xo是epf算法最终的估计结果
%   Xoset是k时刻的粒子集合，其均值就是xo
%   Pout是Xoset 对应的方差
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xo,Xoset,Pout]=epf(Xiset,Z,t,Pin,N,R,Qekf,Rekf,g1,g2)
% 采样策略
resamplingScheme=1;
% 中间变量初始化
Zpre=ones(1,N); %观测预测
Xsetpre=ones(1,N); %粒子集合预测
w = ones(1,N); %权值初始化
Pout=ones(1,N); %协方差预测
Xekf=ones(1,N); %EKF估计结果
% 第一步:根据EKF计算得到的结果进行采样
for i=1:N
% 利用 EKF 计算得到 均值和方差
    [Xekf(i),Pout(i)]=ekf(Xiset(i),Z,Pin(i),t,Qekf,Rekf);
% 现在用上面的均值和方差来为粒子集合采样
    Xsetpre(i)=Xekf(i)+sqrtm(Pout(i))*randn;
end
% 第二步:计算权重
for i=1:N
% 观测预测
    Zpre(i) = hfun(Xsetpre(i),t);
% 计算权重，1e-99为最小非0数字，防止变0
    lik = inv(sqrt(R)) * exp(-0.5*inv(R)*((Z-Zpre(i))^(2)))+1e-99;
    prior = ((Xsetpre(i)-Xiset(i))^(g1-1)) * exp(-g2*(Xsetpre(i)-Xiset(i)));
    proposal = inv(sqrt(Pout(i))) * ...
        exp(-0.5*inv(Pout(i)) *((Xsetpre(i)-Xekf(i))^(2)));
    w(i) = lik*prior/proposal;
end
% 权值归一化
w= w./sum(w);
% 第三步:重采样
if resamplingScheme == 1
    outIndex = residualR(1:N,w'); %残差采样
elseif resamplingScheme == 2
    outIndex = systematicR(1:N,w'); %系统采样
else
    outIndex = multinomialR(1:N,w'); %多项式采样
end
% 第四步:集合更新
Xoset = Xsetpre(outIndex); % 粒子集合更新
Pout = Pout(outIndex); %方差更新
% 均值，作为最终估计
Xo = mean(Xoset);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%