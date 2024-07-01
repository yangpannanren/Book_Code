%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function multi_station_only_azimuth_tracking_system_simulation
% 初始化参数
% rng(1);
T=1; %采样周期
M=30; %采样点数
delta_w=1e-3; %过程噪声调整参数，设得越大，目标运行的机动性越大，轨迹越随机
Q=delta_w*diag([0.5,1,0.5,1]) ; %过程噪声均方差
% 注意:下面R是观测噪声，设都相等，即所有观测站功能完全一样，传感器性能完全一样
% 如果要考虑更真实的情况，需要将其设为不同的值，以便做更复杂的数据融合算法
R=2; %观测角度均方差
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];
Node_number=6; %观测站个数
Length=100; %目标运动的场地空间
Width=100;
% 观测站的位置随即部署
for i=1:Node_number
    Node(i).x=Width*rand;
    Node(i).y=Length*rand;
end
% 保存观测站位置到一个矩阵上
for i=1:Node_number
    NodePostion(:,i)=[Node(i).x,Node(i).y]';
end
% 目标的运动轨边
X=zeros(4,M); %目标状态
Z=zeros(Node_number,M); %观测数据
w=randn(4,M); %过程噪声
v=randn(Node_number,M); %观测噪声
X(:,1)=[1,Length/M,20,60/M]'; %初始化目标状态[x,vx,y,vy]
state0=X(:,1); %估计的初始化
% 模拟目标运动
for t=2:M
    % 状态方程
    X(:,t)=F*X(:,t-1)+sqrtm(Q)*w(:,t); %目标真实轨迹
end
% 模拟目标运动过程，各个观测站采集角度信息
for t=1:M
    for i=1:Node_number
        x0=NodePostion(1,i);
        y0=NodePostion(2,i);
        % 观测方程
        Z(i,t)=hfun(X(:,t),x0,y0)+sqrtm(R)*v(i,t);
    end
end
% 便于函数调用，将参数打包
canshu.T=T;
canshu.M=M;
canshu.Q=Q;
canshu.R=R;
canshu.F=F;
canshu.state0=state0;
canshu.Node_number=Node_number;
% 滤波
[Xpf,Tpf]=PF(Z,NodePostion,canshu);
% RMS
PFrms=zeros(1,M);
for t=1:M
    PFrms(1,t)=distance(X(:,t),Xpf(:,t));
end
% 轨迹图
figure
hold on;box on;
for i=1:Node_number
    % 观测站位置
    h1=plot(NodePostion(1,i),NodePostion(2,i),'bo','MarkerFaceColor','b');
    text(NodePostion(1,i)+0.5,NodePostion(2,i),['Node',num2str(i)])
end
% 目标真实轨迹
h2=plot(X(1,:),X(3,:),'--m.','MarkerEdgeColor','m');
% 滤波算法轨迹
h3=plot(Xpf(1,:),Xpf(3,:),'-k*','MarkerEdgeColor','b');
xlabel('X/m');
ylabel('Y/m');
legend([h1,h2,h3],'观测站位置','目标真实轨迹','PF算法融合轨迹');
title('多站数据融合')
hold off
% RMS跟踪误差图
figure
hold on;box on;
plot(PFrms(1,:),'-k.','MarkerEdgeColor','m');
xlabel('time/s');
ylabel('error/m');
legend('RMS跟踪误差');
title('跟踪误差图');
hold off
% 实时性比较图
figure
hold on
box on
plot(Tpf(1,:),'-k.','MarkerEdgeColor','m');
xlabel('step');
ylabel('time/s');
legend('每个采样周期内PF计算时间');
title('实时性比较');
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明:粒子滤波子程序
% 输入参数:X{i}(4,M,Node number)为Node number个传感器节点对i个
%       目标进行观测值，传感器节点的位置为NodePostion，参数包
% 输出参数:目标的估计状态输出
function [Xout,Tpf]=PF(Z,NodePostion,canshu)
M=canshu.M;
Q=canshu.Q;
R=canshu.R;
F=canshu.F;
T=canshu.T;
state0=canshu.state0;
Node_number=canshu.Node_number;
% 初始化滤波器
N=100; %粒子数
zPred=zeros(1,N);
Weight=zeros(1,N);
xparticlePred=zeros(4,N);
Xout=zeros(4,M);
Xout(:,1)=state0;
Tpf=zeros(1,M);
for i=1:Node_number
    xparticle{i}=zeros(4,N);
    for j=1:N %粒子集初始化
        xparticle{i}(:,j)=state0;
    end
    Xpf{i}=zeros(4,N);
    Xpf{i}(:,1)=state0;
end
for t=2:M
    tic;
    XX=0;
    for i=1:Node_number
        x0=NodePostion(1,i);
        y0=NodePostion(2,i);
        % 采样
        for k=1:N
            xparticlePred(:,k)=sfun(xparticle{i}(:,k),T,F)+5*sqrtm(Q)*randn(4,1);
        end
        % 重要性权值计算
        for k=1:N
            zPred(1,k)=hfun(xparticlePred(:,k),x0,y0);
            z1=Z(i,t)-zPred(1,k);
            Weight(1,k)=inv(sqrt(2*pi*det(R)))*exp(-.5*(z1)'*inv(R)*(z1))+ 1e-99;
        end
        % 归一化权重
        Weight(1,:)=Weight(1,:)./sum(Weight(1,:));
        % 重新采样
        outIndex = randomR(1:N,Weight(1,:)');
        xparticle{i}= xparticlePred(:,outIndex);
        target=[mean(xparticle{i}(1,:)),mean(xparticle{i}(2,:)),...
            mean(xparticle{i}(3,:)),mean(xparticle{i}(4,:))]';
        Xpf{i}(:,t)=target;
        % 注意，下面只是对各个观测站的数据做平均，如需做更复杂的数据融合算法
        % 可以考虑将观测噪声R设置不同的值，再次做加权平均，或者其他融合算法
        % 有兴趣的读者可以在此做深入的研究
        XX=XX+Xpf{i}(:,t);
    end
    Xout(:,t)=XX/Node_number;
    Tpf(1,t)=toc;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%