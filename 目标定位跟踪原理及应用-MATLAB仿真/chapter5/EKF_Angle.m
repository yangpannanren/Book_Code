%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序功能：扩展卡尔曼滤波在基于纯方位角的目标跟踪系统中的应用
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EKF_Angle
T=1;    %雷达扫描周期,
N=40/T;   %总的采样次数
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];    % 状态转移矩阵
G=[T^2/2,0;T,0;0,T^2/2;0,T];   % 过程噪声驱动矩阵
delta_w=1e-4;    % 如果增大这个参数，目标真实轨迹就是曲线了
Q=delta_w*diag([1,1]) ;   % 过程噪声均值
R=0.01*pi/180;     %观测噪声方差,读者可以修改值观察其对角度测量的影响
W=sqrtm(Q)*randn(2,N);     % 过程噪声
V=sqrt(R)*randn(1,N);      % 观测噪声
% 观测站的位置，可以设为其他值
station.x=0;
station.y=1000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X=zeros(4,N);   % 目标真实位置、速度
X(:,1)=[0,2,1400,-10];   % 目标初始位置、速度
Z=zeros(1,N);    % 传感器对位置的观测
for k=2:N
    X(:,k)=F*X(:,k-1)+G*W(:,k);    %目标真实轨迹
end
for k=1:N
    target.x=X(1,k);target.y=X(3,k);
    Z(k)=hfun(target,station)+V(k);       %对目标观测
end
% EKF滤波
Xekf=zeros(4,N);
Xekf(:,1)=X(:,1);     % kalman滤波状态初始化
P0=eye(4);          % 协方差阵初始化
for i=2:N
    Xn=F*Xekf(:,i-1);      %预测
    P1=F*P0*F'+G*Q*G';   %预测误差协方差
    target.x=Xn(1);target.y=Xn(3);
    dd=hfun(target,station);   % 观测预测
    % 求雅可比矩阵H
    D=Dist(target,station);
    H=[-(Xn(3,1)-station.y)/D,0,(Xn(1,1)-station.x)/D,0];
    K=P1*H'*inv(H*P1*H'+R);                %增益
    Xekf(:,i)=Xn+K*(Z(:,i)-dd);                %状态更新
    P0=(eye(4)-K*H)*P1;                     %滤波误差协方差更新
end
% 误差分析
for i=1:N
  target.x=X(1,i);target.y=X(3,i);
  s.x=Xekf(1,i);s.y=Xekf(3,i);
  Err_KalmanFilter(i)=Dist(target,s);%滤波后误差
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图
figure
hold on;box on;
plot(X(1,:),X(3,:),'-k.');            % 真实轨迹
plot(Xekf(1,:),Xekf(3,:),'-r+');       % 扩展kalman滤波轨迹
legend('真实轨迹','EKF轨迹')
figure
hold on; box on;
plot(Err_KalmanFilter,'-ks','MarkerFace','r')
figure 
hold on;box on;
plot(Z/pi*180-V/pi*180,'-r.','MarkerFace','r');          % 真实角度值
plot(Z/pi*180,'-ko','MarkerFace','g'); % 受噪声污染的观测值
legend('真实角度','观测角度');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 子函数
function cita=hfun(X1,X0);
cita=atan2(X1.y-X0.y,X1.x-X0.x);
function d=Dist(X1,X2);
d=sqrt( (X1.x-X2.x)^2+(X1.y-X2.y)^2 );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
