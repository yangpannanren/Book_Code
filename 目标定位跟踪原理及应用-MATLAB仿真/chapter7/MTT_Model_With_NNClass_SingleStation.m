%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：
% 单站多目标跟踪的建模程序，并用近邻法分类
% 主要模拟多目标的运动和观测过程，涉及融合算法---近邻法
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MTT_Model_With_NNClass_SingleStation
% 初始化参数
% 观测站位置，随机的
T=10;                 % 仿真时间长度
TargetNum=3;           % 目标个数
dt=1;                  % 采样时间间隔
Station.x=100*rand;          % 观测站水平位置
Station.y=100*rand;          % 观测站纵向位置
F=[1,dt,0,0;0,1,0,0;0,0,1,dt;0,0,0,1];  % 采用CV模型的状态转移矩阵
G=[0.5*dt^2,0;dt,0;0,0.5*dt^2;0,dt];    % 过程噪声驱动矩阵
H=[1,0,0,0;0,0,1,0];                    % 观测矩阵
Q=diag([2,2]); % 过程噪声方差
R=diag([10,10]);         % 观测噪声方差
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 状态和观测的初始化
for i=1:TargetNum
    % y的位置和y方向的速度是随机的
    % 注意，把80设置为其他值，可以调整轨迹之间的间隔
    % 建议设置成20、40、60、80，可以对比分类效果
    X{i}(:,1)=[3,100/T,80*(i-1),100/T+0.1*randn];
    % 观测初始化
    Z{i}(:,1)=H*X{i}(:,1)+sqrt(R)*randn(2,1);
end
% 模拟目标运动，观测站对目标观测
for t=2:T
    for j=1:TargetNum
        % 第j个目标的状态方程
        X{j}(:,t)=F*X{j}(:,t-1)+G*sqrt(Q)*randn(2,1);
        % 单个观测站对第j个目标观测，观测方程
        Z{j}(:,t)=H*X{j}(:,t)+sqrt(R)*randn(2,1);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图
figure
hold on,box on;
for j=1:TargetNum
    h1=plot(X{j}(1,:),X{j}(3,:),'-r.');  % 多个目标的真实轨迹
    h2=plot(Z{j}(1,:),Z{j}(2,:),'b*');  % 单个观测站对多个目标观测轨迹
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 假定传感器对目标的观测，它是不知道观测数据是属于哪个目标的,现在开始关联算法
% 这里的Z{j}(:,t),即t时刻的数据，并没有开始分类，下面就要开始对其分类
for j=1:TargetNum
    XX{j}=Z{j}(:,1) ; % 初始化已知的样本集合
end
for t=2:T
    % 按照时间序列，逐个将未知的样本点输入分类器进行分类
    Xun=[];
    for j=1:TargetNum
        Xun=[Xun,Z{j}(:,t)]; % 获取t时刻的TargetNum个数据Xun
    end
    % 对Xun关联，t时刻未知类别的样本输入分类器
    [XXout]=NNClass(Xun,XX);
    XX=XXout; % 分类好的样本点输出
end
for j=1:TargetNum
    h3=plot(XX{j}(1,:),XX{j}(2,:),'-go'); % 分类后的轨迹
end
legend([h1,h2,h3],'真实轨迹','观测样本','近邻法融合轨迹')
title('近邻法对轨迹关联仿真结果')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子函数说明：分类算法子函数
% Xun为输入的未知样本集合，XX为输入的已知样本集合（种子样本）
% XXout为最终分好类别的样本集合
function [XXout]=NNClass(Xun,XX)
ALL=length(Xun(1,:));   % 剩余未知样本点个数
Type=length(XX);
% 从已知样本点出发，找到最近的未知样本点
while (ALL>0)
    % 近邻法跟开始分类的顺序有关，顺序不一样，分类的结果也不一样
    d=1e5; % 为了要找到最近的样本，假定初始距离无穷大
    for i=1:Type
        % 去寻找离第i类距离最近的样本
        [~,col]=size(XX{i}); % 得到第i类已知类别的样本中的样本数
        for j=1:col
            % 找到离已知样本点最近的点
            for k=1:ALL
                dist=sqrt( (Xun(1,k)-XX{i}(1,j))^2+(Xun(2,k)-XX{i}(2,j))^2 );
                if dist<d
                    d=dist;
                    % 最近的已知-未知样本序列对
                    label.class=i; % 存放已知类别的样本的标号
                    label.unclass=k; % 存放未知类别的样本的标号
                    X0=[Xun(1,k),XX{i}(1,j)];
                    Y0=[Xun(2,k),XX{i}(2,j)];
                end
            end
        end
    end
    % 将距离近的点归并到第label.class类
    XX{label.class}=[XX{label.class},Xun(:,label.unclass)];
    line(X0,Y0);  % 与最近的样本同类，两者之间连线
    pause(0.5);    % 设置停止时间可以在图形界面上看分类过程
    % 同时将Xun的第label个样本删除
    Xun(:,label.unclass)=[];
    % 继续遍历其他类
    ALL=ALL-1;
end
XXout=XX;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%