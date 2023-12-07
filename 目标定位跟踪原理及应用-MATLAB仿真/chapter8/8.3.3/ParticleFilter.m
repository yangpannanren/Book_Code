%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：基于观测距离，粒子滤波完成对目标状态估计
function [sys,x0,str,ts]=ParticleFilter(t,x,u,flag)
global Zdist;  % 观测信息
global Xpf;    % 粒子滤波估计状态
global Xpfset;  % 粒子集合
randn('seed',20);
N=200; % 粒子数目
% 粒子滤波“网”的半径，衡量粒子集合的分散度，相当于过程噪声Q
NETQ=diag([0.0001,0.0009]); 
% NETR相当于测量噪声R
NETR=0.01;
switch flag
    case 0  % 系统进行初始化，调用mdlInitializeSizes函数
        [sys,x0,str,ts]=mdlInitializeSizes(N);
    case 2  % 更新离散状态变量，调用mdlUpdate函数
        sys=mdlUpdate(t,x,u,N,NETQ,NETR);
    case 3  % 计算S函数的输出，调用mdlOutputs
        sys=mdlOutputs(t,x,u);
    case {1,4}
        sys=[];
    case 9   % 仿真结束，保存状态值
        save('Xpf','Xpf');
        save('Zdist','Zdist');
    otherwise   % 其他未知情况处理，用户可以自定义
        error(['Unhandled flag = ',num2str(flag)]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1、系统初始化子函数
function [sys,x0,str,ts]=mdlInitializeSizes(N)
sizes = simsizes;
sizes.NumContStates  = 0;   % 无连续量
sizes.NumDiscStates  = 4;   % 离散状态4维
sizes.NumOutputs     = 4;   % 输出4维，应为状态量是x-y方向的位置和速度
sizes.NumInputs      = 1;   % 输入维数，因为噪声模型是2维的
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % 至少需要的采样时间
sys = simsizes(sizes);
x0  = [10,10,12,10]';             % 初始条件
str = [];               % str总是设置为空
ts  = [-1 0];  % 表示该模块采样时间继承其前的模块采样时间设置
% 粒子集合初始化
global Xpfset;
Xpfset=zeros(4,N);
for i=1:N
    Xpfset(:,i)=x0+0.1*randn(4,1);
end
global Zdist;  % 观测信息
Zdist=[];
global Xpf;    % 粒子滤波估计状态
Xpf=[x0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2、进行离散状态变量的更新
function sys=mdlUpdate(t,x,u,N,NETQ,NETR)
global Zdist;  % 观测信息
global Xpf;
global Xpfset;  % 粒子集合
Zdist=[Zdist,u]; % 保存观测信息
%——————————————————————————————————————
% 下面开始用粒子滤波对状态更新
G=[0.5,0;1,0;0,0.5;0,1];
F=[1,1,0,0;0,1,0,0;0,0,1,1;0,0,0,1];
x0=0;y0=0; % 雷达站的位置
% 第一步：粒子集合采样
for i=1:N
    Xpfset(:,i)=F*Xpfset(:,i)+G*sqrt(NETQ)*randn(2,1);
end
% 权值计算
for i=1:N
    zPred(1,i)=hfun(Xpfset(:,i),x0,y0);
    weight(1,i)=exp( -0.5*NETR^(-1)*( zPred(1,i)-u )^2 )+1e-99;
end
% 归一化权值
weight=weight./sum(weight);
% 重采样
outIndex=randomR(1:N,weight');
% 新的粒子集合
Xpfset=Xpfset(:,outIndex);
% 状态更新
Xnew=[mean(Xpfset(1,:)),mean(Xpfset(2,:)),...
    mean(Xpfset(3,:)),mean(Xpfset(4,:))]';
% 保存最新的状态并输出返回
Xpf=[Xpf,Xnew];
sys=Xnew;  % 计算的距离返回值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3、求取系统的输出信号
function sys=mdlOutputs(t,x,u)
sys = x;  % 把算得的模块输出向量赋给sys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d=hfun(X,x0,y0)
d=sqrt( (X(1)-x0)^2+(X(3)-y0)^2 );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outIndex = randomR(inIndex,q)
outIndex=zeros(size(inIndex));
[num,col]=size(q);
u=rand(num,1);
u=sort(u);
l=cumsum(q);
i=1;
for j=1:num
    while (i<=num)&(u(i)<=l(j))
        outIndex(i)=j;
        i=i+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
