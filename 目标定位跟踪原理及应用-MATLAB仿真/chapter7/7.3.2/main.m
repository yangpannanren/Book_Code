%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：
% 单站多目标跟踪的建模程序，并用近邻法分类
% 主要模拟多目标的运动和观测过程，涉及融合算法---近邻法
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main
% 初始化参数
T=20;                 % 仿真时间长度
TargetNum=3;           % 目标个数
dt=1;                  % 采样时间间隔
S.x=100*rand;          % 观测站水平位置
S.y=100*rand;          % 观测站纵向位置
F=[1,dt,0,0;0,1,0,0;0,0,1,dt;0,0,0,1];  % 采用CV模型的状态转移矩阵
G=[0.5*dt^2,0;dt,0;0,0.5*dt^2;0,dt];    % 过程噪声驱动矩阵
H=[1,0,0,0;0,0,1,0];                    % 观测矩阵
Q=diag([0.01,0.01]); % 过程噪声方差
cigma_cita=pi/180*0.1; % 角度协方差
cigma_r=10;             % 距离协方差
R=diag([cigma_r,cigma_cita]);  % 观测噪声方差
% 状态和观测的初始化
for i=1:TargetNum
    % y的位置和y方向的速度是随机的
    % 注意，把80设置为其他值，可以调整轨迹之间的间隔
    % 建议设置成20、40、60、80，可以对比分类效果
    X{i}(:,1)=[3,100/T,80*(i-1),100/T+0.1*randn]';
    state0{i}=X{i}(:,1)+G*sqrt(Q)*G'*randn(4,1);
    % 观测初始化
    Z{i}(:,1)=hfun(X{i}(:,1),S.x,S.y)+sqrt(R)*randn(2,1);
    % 根据观测粗算位置
    Xn{i}(:,1)=pfun(Z{i}(:,1),S.x,S.y);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 模拟目标运动，观测站对目标观测
for t=2:T
    for j=1:TargetNum
        % 第j个目标的状态方程
        X{j}(:,t)=F*X{j}(:,t-1)+G*sqrt(Q)*randn(2,1);
        % 单个观测站对第j个目标观测，观测方程
        Z{j}(:,t)=hfun(X{j}(:,t),S.x,S.y)+sqrt(R)*randn(2,1);
        % 根据观测粗算位置
        Xn{j}(:,t)=pfun(Z{j}(:,t),S.x,S.y);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图
figure
hold on,box on;
for j=1:TargetNum
    h1=plot(X{j}(1,:),X{j}(3,:),'-r.');  % 多个目标的真实轨迹
    h2=plot(Xn{j}(1,:),Xn{j}(2,:),'b*');  % 单个观测站对多个目标观测轨迹
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 假定传感器对目标的观测，它是不知道观测数据是属于哪个目标的
% 这里的Z{j}(:,t),即t时刻的数据，并没有开始分类，下面就要开始对其分类
for j=1:TargetNum
    % 初始化已知的样本集合
    X_class{j}(:,1)=Xn{j}(:,1) ;
    Z_class{j}(:,1)=Z{j}(:,1) ;
end
% 粒子滤波初始化
N=300; % 粒子数
for i=1:TargetNum
    xparticle{i}=zeros(4,N);
    Xpf{i}=zeros(4,T); % 状态估计的初始化
    Xpf{i}(:,1)=state0{i};
    for j=1:N      % 粒子集初始化
        xparticle{i}(:,j)=state0{i};
    end
end
% 参数打包传递
canshu.Q=Q;
canshu.R=R;
canshu.F=F;
canshu.G=G;
canshu.N=N; % 粒子数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=2:T
    % 按照时间序列，逐个将未知的样本点输入分类器进行分类
    Xun=[]; % 用来存放t时刻所有采集到的未知样本
    Zun=[]; % 用来存放t时刻所有采集到的未知观测数据
    for j=1:TargetNum
        Xun=[Xun,Xn{j}(:,t)];
        Zun=[Zun,Z{j}(:,t)];
    end
    % t时刻未知类别的样本输入分类器
    [X_class,Z_class]=NNClass(Xun,X_class,Zun,Z_class);
    % 分类好的样本点送进滤波器滤波处理
    % 调用粒子滤波算法
    for i=1:TargetNum
        % 找到观测数据集中当前时刻的观测数据
        last=length(Z_class{i}(1,:));
        Z_last=Z_class{i}(:,last);
        [Xout,xparticle_return,Tpf]=PF(Z_last,S,canshu,xparticle{i});
        xparticle{i}=xparticle_return;
        Xpf{i}(:,t)=Xout;
    end
end
for j=1:TargetNum
    % 分类后的轨迹
    h3=plot(X_class{j}(1,:),X_class{j}(2,:),'-go');
    h4=plot(Xpf{j}(1,:),Xpf{j}(3,:),'-b.');
end
legend([h1,h2,h3,h4],'真实轨迹','观测样本','近邻法融合轨迹','粒子滤波估计')
xlabel('X/m');ylabel('Y/m');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 计算跟踪误差
for i=1:TargetNum
    for t=1:T
        XX=X{i}(:,t);
        YY=Xn{i}(:,t);
        Deviation_Xn_X{i}(t)=getDist(XX,YY); % 计算偏差
        Deviation_Xpf_X{i}(t)=getDist(X{i}(:,t),Xpf{i}(:,t)); % 滤波后的偏差
    end
    % 平均偏差
    Ave_Deviation(i,1)=mean(Deviation_Xn_X{i});
    Ave_Deviation(i,2)=mean(Deviation_Xpf_X{i});
end
figure  % 画出分类跟踪偏差图
for i=1:TargetNum
    subplot(3,1,i)
    hold on;box on;
    plot(Deviation_Xn_X{i},'-ko')
    plot(Deviation_Xpf_X{i},'-r.')
    xlabel('Time/s');ylabel('Value of Deviation/m');
end
figure % 画出平均误差
hold on;box on;
bar(Ave_Deviation,'group')
legend('观测平均偏差','滤波平均偏差')
xlabel('Target ID');ylabel('Value of Average Deviation/m');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
