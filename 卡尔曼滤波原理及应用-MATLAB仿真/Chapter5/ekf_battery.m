%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子程序功能：扩展卡尔曼滤波算法
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xout,Pout]=ekf_battery(X,Zk,k,Q,R,P0)
% 相关参数
F=eye(4);
% 一步状态预测
Xpredict=F*X;
%  观测预测
Zpredict=hfun(Xpredict,k);
%  求线性化的观测矩阵H
ebk=exp(Xpredict(2)*k);  % Q(k)对a(k)求偏导数
akebk=Xpredict(1)*k*ebk; % Q(k)对b(k)求偏导数
edk=exp(Xpredict(4)*k);  % Q(k)对c(k)求偏导数
ckedk=Xpredict(3)*k*edk; % Q(k)对d(k)求偏导数
H=[ebk,akebk,edk,ckedk];
% 协方差预测
P=F*P0*F'+Q;
% 求Kalman增益
Kg=P*H'*inv(H*P*H'+R);
% 计算新息，即用观测值减去预测值
e=Zk-Zpredict;
% 状态更新
Xout=Xpredict+Kg*e;
% 方差更新
Pout=(eye(4)-Kg*H)*P;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%