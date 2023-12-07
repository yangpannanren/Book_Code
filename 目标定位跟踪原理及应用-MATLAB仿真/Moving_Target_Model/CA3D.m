%% 三维匀加速CA运动目标轨迹       
clc;clear;close all;
n=9; % state dimension : 0
T=1; % sample time.
N=100; %the runs atime，跟踪总时长
chan=1; %channel, 算法的个数，
w_mu=[0,0,0]';
v_mu=[0,0,0]';
%% target model
q=0.1; % 目标运动学标准差，过程噪声
Qk=q^2*eye(3);% cov. of process noise
F=[1, T, T^2/2'; 0 1 T; 0 0 1];
Fk=blkdiag(F,F,F);
G=[T^2/2;T;1];
Gk=blkdiag(G,G,G);

%% define parameter
sV=zeros(n,N,1,1); % state
x=[1000,60,5,1000,60,10,1000,50,5]';%初始状态
P_0=diag([1e5,1e2,10, 1e5,1e2,10, 1e5,1e2,10]); %初始状态方差
%滤波器初始化
%x0=mvnrnd(x,P_0); % 初始状态
%x0=(x+normrnd(0,0.001)')';
%x=x0';

%% 目标运动学模型(被跟踪目标建模)，匀速运动CV模型
for k=1:N
    %%%%%%%%% target model and measurement model%%%%%%%%%%%%%%%%%%%%
    w=mvnrnd(w_mu',Qk)';%过程噪声方差
    x=Fk*x+Gk*w;
    sV(:,k,1,1)=x;
end
% 三维匀速运动目标轨迹       
figure
plot3(sV(1,:,1,1),sV(4,:,1,1),sV(7,:,1,1),'-*r','LineWidth',1);grid on
xlabel('m');ylabel('m');
legend('位置轨迹')
title('三维匀加速运动目标轨迹')
% 三维匀速运动目标轨迹       
figure
hold on;grid on;
plot(sV(2,:,1,1),'-*b','LineWidth',1);
plot(sV(5,:,1,1),'-*g','LineWidth',1);
plot(sV(8,:,1,1),'-*r','LineWidth',1);
xlabel('t');ylabel('m/s');
legend('Vx','Vy','Vz')
title('三维匀加速运动目标速度')
% 三维匀速运动目标轨迹       
figure
hold on;grid on;
plot(sV(3,:,1,1),'-*b','LineWidth',1);
plot(sV(6,:,1,1),'-*g','LineWidth',1);
plot(sV(9,:,1,1),'-*r','LineWidth',1);
xlabel('t');ylabel('m/s^2');
legend('Vx','Vy','Vz')
legend('加速度真实轨迹',Location='northwest')
title('三维匀加速运动目标加速度')