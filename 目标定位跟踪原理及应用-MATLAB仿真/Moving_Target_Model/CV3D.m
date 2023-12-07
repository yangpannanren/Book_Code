clc;clear;close all;
%% 三维匀速CV运动目标轨迹 
n=6; % state dimension : 6
T=1; % sample time.
N=100; %the runs atime，跟踪总时长
w_mu=[0,0,0]';
v_mu=[0,0,0]';
%% target model
q=0.1; % 目标运动学标准差，过程噪声
Qk=q^2*eye(3);% cov. of process noise
Fk=[  1,T,0,0,0,0;
      0,1,0,0,0,0;
      0,0,1,T,0,0;
      0,0,0,1,0,0;
      0,0,0,0,1,T;
      0,0,0,0,0,1 ];
Gk=[  T^2/2,    0,    0;
          T,    0,    0;
          0,T^2/2,    0;
          0,    T,    0;
          0,    0,T^2/2;
          0,    0,    T ];
% define parameter
sV=zeros(n,N,1,1); % state
x=[1000,60,1000,60,1000,50]';%初始状态
P_0=diag([1e5,1e2,1e5,1e2,1e5,1e2]); %初始状态方差

%x0=mvnrnd(x,P_0); % 初始状态
%x0=(x+normrnd(0,0.001)')';
%x=x0';

%% 目标运动学模型(被跟踪目标建模)，匀速运动CV模型
%%%%%%%%% target model and measurement model%%%%%%%%%%%%%%%%%%%%
for k=1:N
    w=mvnrnd(w_mu',Qk)';%过程噪声方差
    x=Fk*x+Gk*w;
    sV(:,k,1,1)=x;
end
% 三维匀速运动目标轨迹       
figure
plot3(sV(1,:,1,1),sV(3,:,1,1),sV(5,:,1,1),'-*r','LineWidth',1)
xlabel('x/m');ylabel('y/m');zlabel('z/m');
legend('真实轨迹')
title('三维匀速运动目标轨迹')

