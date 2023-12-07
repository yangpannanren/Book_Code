%% 一维匀加速CA运动目标轨迹       
clc;clear;close all;
n=6; % state dimension : 3
T=1; % sample time.
N=100; %the runs atime，跟踪总时长
w_mu=[0,0]';

%% target model
q=0.1; % 目标运动学标准差，过程噪声
Qk=q^2*eye(2);% cov. of process noise
% state matrix
Fk= [1 T T^2/2 0 0 0  
     0 1 T 0 0 0 
     0 0 1 0 0 0
     0 0 0 1 T T^2/2
     0 0 0 0 1 T
     0 0 0 0 0 1]; %
 Gk= [ T^2/2 0  
       T     0      
       1     0
       0     T^2/2
       0     T
       0     1]; 

%% define parameter
sV=zeros(n,N,1,1); % state
x=[0,50,1,0,100,10]';
P_0=diag([1e5,1e2,1e5,1e2,1e5,1e2]); 

%x0=mvnrnd(x,P_0); % 初始状态
%x0=(x+normrnd(0,0.001)')';
%x=x0';
%% 目标运动学模型(被跟踪目标建模)，匀速运动CV模型
for k=1:N
   %%%%%%%%% target model %%%%%%%%%%%%%%%%%%%%
    w=mvnrnd(w_mu',Qk)';%过程噪声方差
    x=Fk*x+Gk*w;
    sV(:,k,1,1)=x;
end
%% 一维匀速CV运动目标轨迹 
ii=1:N;
figure
plot(sV(1,:,1,1),sV(4,:,1,1),'-*r','LineWidth',1)
grid on
xlabel('x/m');ylabel('y/m');
legend('真实轨迹')
title('二维匀加速运动目标轨迹(位置)')
figure
plot(ii,sV(2,:,1,1),'-*b','LineWidth',1)
hold on;
plot(ii,sV(5,:,1,1),'-*r','LineWidth',1)
legend('Vx','Vy')
grid on
xlabel('时间（s）');ylabel('m/s');
title('一维维匀速运动目标轨迹（速度）')
figure
plot(ii,sV(3,:,1,1),'-*b','LineWidth',1)
hold on;
plot(ii,sV(6,:,1,1),'-*r','LineWidth',1)
grid on
xlabel('时间（s）');ylabel('m/s^2');
legend('ax','ay')
title('一维维匀速运动目标轨迹（加速度）')

