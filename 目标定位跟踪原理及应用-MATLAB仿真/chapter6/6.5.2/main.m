%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：粒子滤波用于高斯模型噪声的滤波
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main
% 初始化参数
randn('seed',4);
rand('seed',7);
T=1;   % 采样周期
M=30;  % 采样点数
delta_w=1e-4; % 过程噪声调整参数，设得越大，目标运行的机动性越大，轨迹越随机（乱）
Q=delta_w*diag([0.5,1,0.5,1]) ; % 过程噪声均方差
R=0.25;                            % 观测距离均方差
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];
Length=100;    % 目标运动的场地空间
Width=100;
% 观测站的位置随即部署
Station.x=Width*rand;
Station.y=Length*rand;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 目标的运动轨迹
X=zeros(4,M); % 目标状态
Z=zeros(1,M); % 观测数据
w=randn(4,M); % 过程噪声
v=randn(1,M); % 观测噪声
X(:,1)=[1,Length/M,20,60/M]'; % 初始化目标状态，读者可以设置成其他值
state0=X(:,1)+w(:,1);         % 估计的初始化
for t=2:M
    X(:,t)=F*X(:,t-1)+sqrtm(Q)*w(:,t);%目标真实轨迹
end
%  模拟目标运动过程，观测站对目标观测获取距离数据
for t=1:M
    Z(1,t)=feval('hfun',X(:,t),Station)+sqrtm(R)*v(1,t);
end
% 便于函数调用，将参数打包
canshu.T=T;canshu.M=M;canshu.Q=Q;canshu.R=R;canshu.F=F;canshu.state0=state0;
%  滤波
[Xpf,Tpf]=PF(Z,Station,canshu);
%  RMS比较图
for t=1:M
    PFrms(1,t)=distance(X(:,t),Xpf(:,t));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  画图
figure;hold on;box on  % 轨迹图
h1=plot(Station.x,Station.y,'ro','MarkerFaceColor','b'); % 观测站位置
h2=plot(X(1,:),X(3,:),'--m.','MarkerEdgeColor','m'); % 目标真实轨迹
% 滤波算法轨迹
h3=plot(Xpf(1,:),Xpf(3,:),'-k*','MarkerEdgeColor','b');
xlabel('X/m');ylabel('Y/m');
legend([h1,h2,h3],'观测站位置','目标真实轨迹','PF算法轨迹');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RMS 图  跟踪误差图
figure;hold on;box on
plot(PFrms(1,:),'-k.','MarkerEdgeColor','m');
xlabel('time/s');ylabel('error/m');
legend('RMS跟踪误差');
title(['RMSE,q=',num2str(delta_w)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  实时性比较图
figure;hold on;box on
plot(Tpf(1,:),'-k.','MarkerEdgeColor','m');
xlabel('step');ylabel('time/s');
legend('每个采样周期内PF计算时间');
title('Comparison of Realtime')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

