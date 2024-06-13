%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：多站多目标跟踪的建模程序
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MTT_Model_Of_MutiStation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 初始化参数
% 仿真环境设置，假设目标在Length*Width的范围内运动
Length=500; % 场地的长
Width=500;  % 场地的宽
T=100;                 % 仿真时间长度
TargetNum=2;           % 目标个数
StationNum=4;          % 观测站个数
dt=1;                  % 采样时间间隔
F=[1,dt,0,0;0,1,0,0;0,0,1,dt;0,0,0,1];  % 采用CV模型的状态转移矩阵
G=[0.5*dt^2,0;dt,0;0,0.5*dt^2;0,dt];    % 过程噪声驱动矩阵
% 假设各个目标的过程噪声都是不一样的
for i=1:TargetNum
    Q{i}=diag([0.02+1e-3*randn,0.001+1e-4*randn]); % 过程噪声方差
end
% 假设各个观测站的传感器精度不一样，则观测噪声可设置不同值
for j=1:StationNum
    % 注意：距离的观测噪声方差较大，角度的方差为1度为佳
    Rr=(10+0.1*randn)^2;
    Rcita=(pi/180+1e-3*randn)^2;
    R{j}=diag([Rr,Rcita]);  % 观测噪声方差
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 观测站位置初始化，假设观测站的位置是随机的
for i=1:StationNum
    % 第i个观测站x位置
    Station{i}.x=Length*rand;
    % 第i个观测站y位置
    Station{i}.y=Width*rand;
    % 此为固定参数，便于计算先在此固化，以提高实时性
    Station{i}.D=Station{i}.x^2+Station{i}.y^2;
end
% 目标状态初始化
for i=1:TargetNum
    X{i}=zeros(4,T);
end
% 目标的初始状态赋值
for i=1:TargetNum
    X{i}(:,1)=[3,300/T,200*(i-1),300/T+0.1*randn]';
end
% 观测初始化
for i=1:TargetNum
    for j=1:StationNum
        % 第j个观测站对第i个目标观测
        Z{j,i}=zeros(2,T);
        Xn{j,i}=zeros(4,T);
    end
end
% 观测站对目标初始状态进行观测
for i=1:TargetNum
    for j=1:StationNum
        % 第j个观测站对第i个目标观测
        Z{j,i}(:,1)=hfun(X{i}(:,1),Station{j});
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 模拟目标运动，观测站对目标观测
for t=2:T
    for i=1:TargetNum
        % 目标运动，第i个目标的状态方程
        X{i}(:,t)=F*X{i}(:,t-1)+G*sqrt(Q{i})*randn(2,1);
        for j=1:StationNum
            % t时刻,第j个观测站对第i个目标观测
            Z{j,i}(:,t)=hfun(X{i}(:,t),Station{j})+sqrtm(R{i})*randn(2,1);
        end
    end
end
% 直接利用含噪声的观测数据计算目标位置
for t=1:T
    for i=1:TargetNum
        for j=1:StationNum
            Xn{j,i}(:,t)=pfun(Z{j,i}(:,t),Station{j});
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图
figure; hold on,box on;
for j=1:StationNum  % 画观测站
    plot(Station{j}.x,Station{j}.y,'ko','MarkerFace','r')
    text(Station{j}.x,Station{j}.y+5,['Station ',num2str(j)])
end
for i=1:TargetNum % 画轨迹
    plot(X{i}(1,:),X{i}(3,:),'-r.')  % 多个目标的真实轨迹
    for j=1:StationNum
        % 单个观测站对多个目标观测轨迹
        if i<2
            plot(Xn{j,i}(1,:),Xn{j,i}(3,:),'b.')  % 对轨迹点标不同颜色
        else
            plot(Xn{j,i}(1,:),Xn{j,i}(3,:),'g.')  % 对轨迹点标不同颜色
        end
    end
end
title('多站多目标跟踪系统仿真轨迹')
axis([0 500 0 500])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 观测子函数 hfun
function value=hfun(X,Station)
r=sqrt((X(1)-Station.x)^2+(X(3)-Station.y)^2);   % 观测站与目标之间的距离
cita=atan2(X(3)-Station.y,X(1)-Station.x);       % 返回观测偏向角
value=[r,cita]';                    % 返回值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 目标位置计算子函数 pfun
function Xn=pfun(Z,Station)
x=Z(1)*cos(Z(2))+Station.x;
y=Z(1)*sin(Z(2))+Station.y;
vx=0;vy=0;
Xn=[x,vx,y,vy]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%