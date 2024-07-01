%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  程序说明： 单站单目标基于角度的跟踪系统，采用粒子滤波算法
%  状态方程  X（k+1）=F*X(k)+Lw(k)
%  观测方程  Z（k）=h（X）+v（k）
function only_azimuth_tracking_system_simulation
% 初始化参数
% rng(1);
T=1; %采样周期
M=30; %采样点数
delta_w=1e-4; %过程噪声调整参数，设得越大，目标运行的机动性越大，轨迹越随机
Q=delta_w*diag([0.5,1,0.5,1]) ; %过程噪声均方差
R=pi/180*0.1; %观测角度均方差，可将0.1设置得更小
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];
% 系统初始化
Length=100; %目标运动的场地空间
Width=100;
% 观测站的位置随即部署
Node.x=Width*rand;
Node.y=Length*rand;
% 目标的运动轨边
X=zeros(4,M); %目标状态
Z=zeros(1,M); %观测数据
w=randn(4,M); %过程噪声
v=randn(1,M); %观测噪声
X(:,1)=[1,Length/M,20,60/M]'; %初始化目标状态[x,vx,y,vy]，读者可以设置成其他值
state0=X(:,1); %估计的初始化
for t=2:M
    X(:,t)=F*X(:,t-1)+sqrtm(Q)*w(:,t);
end
% 模拟目标运动过程，观测站对目标观测获取距离数据
for t=1:M
    x0=Node.x;
    y0=Node.y;
    Z(1,t)=hfun(X(:,t),x0,y0)+sqrtm(R)*v(1,t);
end
% 便于函数调用，将参数打包
canshu.T=T;
canshu.M=M;
canshu.Q=Q;
canshu.R=R;
canshu.F=F;
canshu.state0=state0;
% 滤波
[Xpf,Tpf]=PF(Z,Node,canshu);
% RMS
PFrms=zeros(1,M);
for t=1:M
    PFrms(1,t)=distance(X(:,t),Xpf(:,t));
end
% 轨迹图
figure
hold on;box on;
% 观测站位置
h1=plot(Node.x,Node.y,'bo','MarkerFaceColor','b');
% 目标真实轨迹
h2=plot(X(1,:),X(3,:),'--m.','MarkerEdgeColor','m');
% 滤波算法轨迹
h3=plot(Xpf(1,:),Xpf(3,:),'-k*','MarkerEdgeColor','b');
xlabel('X/m');
ylabel('Y/m');
legend([h1,h2,h3],'观测站位置','目标真实轨迹','PF算法轨迹');
title('跟踪轨迹');
hold off;
% RMS跟踪误差图
figure
hold on;box on;
plot(PFrms(1,:),'-k.','MarkerEdgeColor','m');
xlabel('time/s');
ylabel('error/m');
legend('RMS跟踪误差');
title(['RMSE,q=',num2str(delta_w)])
hold off;
% 实时性比较图
figure
hold on;box on;
plot(Tpf(1,:),'-k.','MarkerEdgeColor','m');
xlabel('step');
ylabel('time/s');
legend('每个采样周期内PF计算时间');
title('实时性比较');
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  程序说明： 粒子滤波子程序
function [Xout,Tpf]=PF(Z,Station,canshu)
T=canshu.T;
M=canshu.M;
Q=canshu.Q;
R=canshu.R;
F=canshu.F;
state0=canshu.state0;
% 初始化滤波器
N=100; %粒子数
zPred=zeros(1,N);
Weight=zeros(1,N);
xparticlePred=zeros(4,N);
Xout=zeros(4,M);
Xout(:,1)=state0;
Tpf=zeros(1,M);
xparticle=zeros(4,N);
for j=1:N
    xparticle(:,j)=state0; %粒子集初始化
end
for t=2:M
    tic;
    % 采样
    for k=1:N
        xparticlePred(:,k)=sfun(xparticle(:,k),T,F)+5*sqrtm(Q)*randn(4,1);
    end
    % 重要性权值计算
    for k=1:N
        zPred(1,k)=hfun(xparticlePred(:,k),Station.x,Station.y);
        z1=Z(1,t)-zPred(1,k);
        Weight(1,k)=inv(sqrt(2*pi*det(R)))*exp(-.5*(z1)'*inv(R)*(z1))+ 1e-99;%权值计算
    end
    % 归一化权重
    Weight(1,:)=Weight(1,:)./sum(Weight(1,:));
    % 重新采样
    outIndex = randomR(1:N,Weight(1,:)'); %随机重采样
    xparticle= xparticlePred(:,outIndex); %获取新采样值
    target=[mean(xparticle(1,:)),mean(xparticle(2,:)),...
        mean(xparticle(3,:)),mean(xparticle(4,:))]';
    Xout(:,t)=target;
    Tpf(1,t)=toc;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明： 观测方程函数
% 输入参数： x目标的状态，（x0,y0)是观测站的位置
% 输出参数： y是角度
function [y]=hfun(x,x0,y0)
if nargin < 3
    error('Not enough input arguments.');
end
[row,col]=size(x);
if row~=4|col~=1
    error('Input arguments error!');
end
xx=x(1)-x0;
yy=x(3)-y0;
y=atan2(yy,xx);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%