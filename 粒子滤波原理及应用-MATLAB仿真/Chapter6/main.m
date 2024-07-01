%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：ekf,ukf,pf,epf,upf算法的综合比较程序
function main
% 因为本程序涉及太多的随机数，下面让随机数每次都不变
rng(1);
T = 50; %仿真时间步数
R =  1e-5; %测量噪声
% 产生均值为g1/g2，方差为g1/(g2*g2)
g1 = 3; %Gamma 分布参数，用于产生过程噪声
g2 = 2; %Gamma 分布参数，用于产生过程噪声
% 系统初始化
X = zeros(1,T);
Z = zeros(1,T);
processNoise = zeros(T,1);
measureNoise = zeros(T,1);
X(1) = 1; %状态初值
P0 = 3/4;
% EKF 滤波算法
Qekf=10*3/4; %EKF过程噪声方差
Rekf=1e-1; %EKF过程噪声方差
Xekf=zeros(1,T); %滤波状态
Pekf = P0*ones(1,T); %协方差
Tekf=zeros(1,T); %用于记录一个采样周期的算法时间消耗
% UKF 滤波算法
Qukf=2*3/4; %UKF过程噪声方差
Rukf=1e-1; %UKF过程噪声方差
Xukf=zeros(1,T); %滤波状态
Pukf = P0*ones(1,T); %协方差
Tukf=zeros(1,T); %用于记录一个采样周期的算法时间消耗
% 基本粒子滤波器设置
N=200; %粒子数
Xpf=zeros(1,T); %滤波状态
Xpfset=ones(T,N); %粒子集合初始化
Tpf=zeros(1,T); %用于记录一个采样周期的算法时间消耗
% EPF 滤波器设置
Xepf=zeros(1,T); %滤波状态
Xepfset=ones(T,N); %粒子集合初始化
Pepf = P0*ones(T,N); %各个粒子的协方差
Tepf=zeros(1,T); %用于记录一个采样周期的算法时间消耗
% UPF 滤波器设置
Xupf=zeros(1,T); %滤波状态
Xupfset=ones(T,N); %粒子集合初始化
Pupf = P0*ones(T,N); %各个粒子的协方差
Tupf=zeros(1,T); %用于记录一个采样周期的算法时间消耗
% 以下是模拟系统运行
for t=2:T
    processNoise(t) =  gengamma(g1,g2); %产生过程噪声
    measureNoise(t) =  sqrt(R)*randn; %产生观测噪声
    % 模拟系统状态运行一步
    X(t) = ffun(X(t-1),t) +processNoise(t);
    % 模拟传感器对系统观测(测量)一次
    Z(t) = hfun(X(t),t) + measureNoise(t);
    % 调用 EKF 算法
    tic
    [Xekf(t),Pekf(t)]=ekf(Xekf(t-1),Z(t),Pekf(t-1),t,Qekf,Rekf);
    Tekf(t)=toc;
    % 调用 UKF 算法
    tic
    [Xukf(t),Pukf(t)]=ukf(Xukf(t-1),Z(t),Pukf(t-1),Qukf,Rukf,t);
    Tukf(t)=toc;
    % 调用 PF 算法
    tic
    [Xpf(t),Xpfset(t,:)]=pf(Xpfset(t-1,:),Z(t),N,t,R,g1,g2);
    Tpf(t)=toc;
    % 调用 EPF 算法
    tic
    [Xepf(t),Xepfset(t,:),Pepf(t,:)]=epf(Xepfset(t-1,:),Z(t),t,Pepf(t-1,:),N,R,Qekf,Rekf,g1,g2);
    Tepf(t)=toc;
    % 调用 UPF 算法
    tic
    [Xupf(t),Xupfset(t,:),Pupf(t,:)]=upf(Xupfset(t-1,:),Z(t),t,Pupf(t-1,:),N,R,Qukf,Rukf,g1,g2);
    Tupf(t)=toc;
end
% 数据分析、偏差比较
ErrorEkf=abs(Xekf-X); %ekf 算法估计得到的状态与真实状态之间的偏差
ErrorUkf=abs(Xukf-X); %ukf 算法估计得到的状态与真实状态之间的偏差
ErrorPf=abs(Xpf-X);   %pf  算法估计得到的状态与真实状态之间的偏差
ErrorEpf=abs(Xepf-X); %epf 算法估计得到的状态与真实状态之间的偏差
ErrorUpf=abs(Xupf-X); %upf 算法估计得到的状态与真实状态之间的偏差
% 画图
figure
hold on;box on;
p1=plot(1:T,X,'-k.','lineWidth',2);
p2=plot(1:T,Xekf,'m:','lineWidth',2);
p3=plot(1:T,Xukf,'--','lineWidth',2);
p4=plot(1:T,Xpf,'-ro','lineWidth',2);
p5=plot(1:T,Xepf,'-g*','lineWidth',2);
p6=plot(1:T,Xupf,'-b^','lineWidth',2);
legend([p1,p2,p3,p4,p5,p6],'真实状态','EKF估计','UKF估计','PF估计','EPF估计','UPF估计')
xlabel('时间');ylabel('状态值');
title('系统状态图')
% 偏差比较图
figure
hold on;box on;
p1=plot(1:T,ErrorEkf,'-k.','lineWidth',2);
p2=plot(1:T,ErrorUkf,'-m^','lineWidth',2);
p3=plot(1:T,ErrorPf,'-ro','lineWidth',2);
p4=plot(1:T,ErrorEpf,'-g*','lineWidth',2);
p5=plot(1:T,ErrorUpf,'-bd','lineWidth',2);
legend([p1,p2,p3,p4,p5],'EKF偏差','UKF偏差','PF偏差','EPF偏差','UPF偏差')
xlabel('时间');ylabel('偏差');
title('状态偏差图');
% 算法实时性比较图
figure
hold on;box on;
p1=plot(1:T,Tekf,'-k.','lineWidth',2);
p2=plot(1:T,Tukf,'-m^','lineWidth',2);
p3=plot(1:T,Tpf,'-ro','lineWidth',2);
p4=plot(1:T,Tepf,'-g*','lineWidth',2);
p5=plot(1:T,Tupf,'-bd','lineWidth',2);
legend([p1,p2,p3,p4,p5],'EKF时间','UKF时间','PF时间','EPF时间','UPF时间')
xlabel('时间');ylabel('计算时间');
title('实时性比较');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%