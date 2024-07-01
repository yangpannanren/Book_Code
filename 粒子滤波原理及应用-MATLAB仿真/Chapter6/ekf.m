%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 函数功能：扩展卡尔曼滤波算法
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xekf,Pout]=ekf(Xin,Z,Pin,t,Qekf,Rekf)
% 对粒子的一步预测
Xpre=ffun(Xin,t);
% 在用EKF时需要计算状态的雅可比矩阵，此处一维，算是非常简单的
Jx=0.5;
%方差预测
Pekfpre = Qekf + Jx*Pin*Jx';
%观测预测
Zekfpre= hfun(Xpre,t);
% 计算观测的雅可比矩阵
if t<=30
    Jy = 2*0.2*Xpre;
else
    Jy = 0.5;
end
% EKF方差更新
M = Rekf + Jy*Pekfpre*Jy';
% 计算 Kalman 增益
K = Pekfpre*Jy'*inv(M);
% EKE 状态更新
% 好了，这里就是EKF建议分布的均值，用它就可以指导粒子分布
Xekf=Xpre+K*(Z-Zekfpre);
% EKE 方差更新
% 好了，这里就是EKF建议分布的均值，用它就可以指导粒子分布
Pout = Pekfpre - K*Jy*Pekfpre;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%