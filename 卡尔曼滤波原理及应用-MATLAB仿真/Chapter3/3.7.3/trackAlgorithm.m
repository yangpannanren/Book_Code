%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  版权声明
%  黄小平，王岩 著，《卡尔曼滤波原理及应用-MATLAB仿真》第2版，电子工业出版社
%  功能说明：Kalman滤波用于牧场奶牛尾部跟踪程序
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function trackAlgorithm
% 加载观测数据,数据名字其实是Z
load('Observation.mat')
% 观测数据大小
[row,col]=size(Z)

% Kalman滤波相关设置
X_kf=zeros(row,col);
X_kf(:,1)=Z(:,1);                  % 状态初始化
P_kf=diag([0.1,0.01,0.1,0.01]);    % 协方差
Time_kf=zeros(1,col);              % 运算时间

% 主程序
for k=2:col
    % kalman滤波算法
    [X_kf(:,k),P_kf,Time_kf(k)]=kalman(X_kf(:,k-1),Z(:,k),P_kf);
end

% 第1个时刻用第2个时刻代替
Time_kf(1)=Time_kf(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图，显示轨迹
figure
hold on;box on;
plot(Z(1,:),Z(3,:),'-r.')
plot(X_kf(1,:),X_kf(3,:),'-b*')
legend('观测结果','卡尔曼滤波')

% 显示x方向的速度
figure
hold on;box on;
plot(Z(2,:),'-r.')
plot(X_kf(2,:),'-b*')
legend('观测速度x','卡尔曼滤波速度x')

% 显示y方向的速度
figure
hold on;box on;
plot(Z(4,:),'-r.')
plot(X_kf(4,:),'-b*')
legend('观测速度y','卡尔曼滤波速度y')

% 显示时间
figure
hold on;box on;
plot(Time_kf,'-r.')
mean(Time_kf)
legend('卡尔曼滤波计算时间')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kalman滤波算法
function [Xnew,Pnew,time]=kalman(X,Z,P)
tic;
% 状态矩阵
dt=1/25; % 采样时间，也就是视频帧播放时间
A=[1,dt,0,0;
    0,1,0,0;
    0,0,1,dt;
    0,0,0,1];
% 没有控制量
B=0;
% 过程噪声驱动矩阵
C=eye(4);
% 观测矩阵
D=eye(4);
% 测量噪声驱动矩阵
E=eye(4);
% 过程噪声
Q=diag([0.01,0.0001,0.01,0.0001]); % 过程噪声
R=diag([0.1,0.01,0.1,0.01]);       % 测量噪声

% 下面是Kalman滤波的核心算法
% 1. 对状态一步预测
Xpred=A*X;
% 2. 对协方差进行预测
Ppre=A*P*A'+C*Q*C';
% 3. 计算Kalman增益
KalmanGain=Ppre*D'*inv(D*Ppre*D'+R);
% 4. 计算新息
e=Z-D*Xpred;
% 5. 状态更新
Xnew=Xpred+KalmanGain*e;
% 6. 方差更新
Pnew=(eye(4)-KalmanGain*D)*Ppre;
% 一次kalman计算，从tic开始到toc结束，总共花费的计算时间
time=toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%