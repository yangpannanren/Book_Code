%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序功能：扩展卡尔曼滤波在基于测距的目标跟踪系统中的应用
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EKF_For_Dist_Only_Tracking_System
T=1;%雷达扫描周期,
N=60/T; %总的采样次数
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];  % 状态转移矩阵
G=[T^2/2,0;T,0;0,T^2/2;0,T]; % 过程噪声驱动矩阵
delta_w=1e-3; %如果增大这个参数，目标真实轨迹就是曲线了
Q=diag([delta_w,delta_w]) ; % 过程噪声方差
R=5;  %观测噪声方差
W=sqrt(Q)*randn(2,N);
V=sqrt(R)*randn(1,N);
% 观测站的位置，可以设为其他值
station.x=200;
station.y=300;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X=zeros(4,N); % 目标真实位置、速度
X(:,1)=[-100,2,200,20];% 目标初始位置、速度
Z=zeros(1,N); % 传感器对位置的观测
for k=2:N
    X(:,k)=F*X(:,k-1)+G*W(:,k);    %目标真实轨迹
end
for k=1:N
    target.x=X(1,k);
    target.y=X(3,k);
    Z(k)=Dist(target,station)+V(k);  %对目标观测
end
% EKF滤波
Xekf=zeros(4,N);
Xekf(:,1)=X(:,1); % kalman滤波状态初始化
P0=eye(4); % 协方差阵初始化
for i=2:N
    Xn=F*Xekf(:,i-1); %预测
    P1=F*P0*F'+G*Q*G';%预测误差协方差
    target_pre.x=Xn(1);target_pre.y=Xn(3);
    dd=Dist(target_pre,station); % 观测预测
    % 求雅可比矩阵H
    H=[(Xn(1,1)-station.x)/dd,0,(Xn(3,1)-station.y)/dd,0];
    K=P1*H'*inv(H*P1*H'+R);%增益
    Xekf(:,i)=Xn+K*(Z(:,i)-dd);%状态更新
    P0=(eye(4)-K*H)*P1;%滤波误差协方差更新
end
% 误差分析
for i=1:N
    A.x=X(1,i);A.y=X(3,i);B.x=Xekf(1,i);B.y=Xekf(3,i);
    Err_KalmanFilter(i)=Dist(A,B); % 滤波后的误差
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图
figure
hold on;box on;
plot(X(1,:),X(3,:),'-k.'); % 真实轨迹
plot(Xekf(1,:),Xekf(3,:),'-r+'); % 扩展kalman滤波轨迹
legend('真实轨迹','EKF轨迹')
figure
hold on; box on;
plot(Err_KalmanFilter,'-ks','MarkerFace','r')
% 子函数：求两点间的距离
function d=Dist(A,B);
d=sqrt( (A.x-B.x)^2 + (A.y-B.y)^2 );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
