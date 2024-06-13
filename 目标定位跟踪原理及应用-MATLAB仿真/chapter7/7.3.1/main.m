%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：2个观测站对2个目标观测跟踪程序
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main
TargetNum=2; StationNum=2; % 初始化
T=30;  % 总仿真时间
dt=1;  % 采样周期
F=[1,dt,0,0;0,1,0,0;0,0,1,dt;0,0,0,1]; % 状态转移矩阵
G=[0.5*dt^2,0;dt,0;0,0.5*dt^2;0,dt];   % 过程噪声驱动矩阵
H=[1,0,0,0;0,0,1,0];   % 观测矩阵
Q1=diag([0.0001,0.0001]); % 目标1的过程噪声方差
Q2=diag([0.0009,0.0009]); % 目标2的过程噪声方差
R1=diag([0.25,0.25]);  % 观测站1的测量噪声方差
R2=diag([0.81,0.81]);  % 观测站2的测量噪声方差
rng(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 模拟目标运动过程，观测站探测过程
V{1,1}=sqrt(R1)*randn(2,T);  % 观测站1的测量噪声
V{1,2}=sqrt(R1)*randn(2,T);  % 观测站1的测量噪声
V{2,1}=sqrt(R2)*randn(2,T);  % 观测站2的测量噪声
V{2,2}=sqrt(R2)*randn(2,T);  % 观测站2的测量噪声
W{1}=sqrt(Q1)*randn(2,T);    % 目标1过程噪声
W{2}=sqrt(Q2)*randn(2,T);    % 目标2过程噪声
X{1}=zeros(4,T);             % 目标1状态初始化
X{1}(:,1)=[0,1.0,0,1.2];     % 初始时刻的状态
X{2}=zeros(4,T);             % 目标1状态初始化
X{2}(:,1)=[0,1.2,30,-1.0];   % 初始时刻的状态
Xkf{1,1}(:,1)=X{1}(:,1)+G*W{1}(:,1); % 滤波器初始
Xkf{1,2}(:,1)=X{2}(:,1)+G*W{2}(:,1);
Xkf{2,1}(:,1)=X{1}(:,1)+G*W{1}(:,1); % 滤波器初始
Xkf{2,2}(:,1)=X{2}(:,1)+G*W{2}(:,1);
P{1,1}=eye(4);   % Kalman滤波器协方差初始化
P{1,2}=eye(4);
P{2,1}=eye(4);
P{2,2}=eye(4);
Xmean{1}=zeros(4,T); % 多观测站数据融合最终估计的目标1状态
Xmean{1}(:,1)=(Xkf{1,1}(:,1)+Xkf{2,1}(:,1))/2;
Xmean{2}=zeros(4,T);% 多观测站数据融合最终估计的目标1状态
Xmean{2}(:,1)=(Xkf{1,2}(:,1)+Xkf{2,2}(:,1))/2;
for i=1:TargetNum            % 初始时刻
    for j=1:StationNum
        Z{j,i}=zeros(2,T);   % 第j个观测站对第i个目标观测,正确情况
        Z{j,i}(:,1)=H*X{i}(:,1)+V{j,i}(:,1);
        Zun{j,i}=[]; % 第j个观测站对第i个目标观测,近邻法关联结果放在此
        Zun{j,i}(:,1)=Z{j,i}(:,1);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=2:T
    % 对照书中第（1）步
    ZZ=[]; % 存储观测数据的临时变量
    for i=1:TargetNum
        X{i}(:,k)=F*X{i}(:,k-1)+G*W{i}(:,k);% 第i个目标运动
        for j=1:StationNum
            Z{j,i}(:,k)=H*X{i}(:,k)+V{j,i}(:,k);% 第j个观测站对第i个目标观测
            ZZ=[ZZ,Z{j,i}(:,k)];
        end
    end
    % 这时候得到的观测数据ZZ是未知目标类别的，需要调用近邻法对其航迹关联
    % 观测站1的测量数据：ZZ(:,1),ZZ(:,3);观测站2的数据：ZZ(:,2),ZZ(:,4)
    % 现在需要调用近邻法关联到目标1和2当中去，观测站1和2各自运行近邻法
    % 对照书中第（2）步
    [Zun{1,1},Zun{1,2}]=NNClassfier(ZZ(:,1),ZZ(:,3),Zun{1,1},Zun{1,2});
    [Zun{2,1},Zun{2,2}]=NNClassfier(ZZ(:,2),ZZ(:,4),Zun{2,1},Zun{2,2});
    % 接下来对关联的数据进行kalman滤波，对照书中第（3）步
    [Xkf{1,1}(:,k),P{1,1}]=KalmanFilter(Xkf{1,1}(:,k-1),...
        Zun{1,1}(:,k),P{1,1},F,G,H,Q1,R1); % 观测站1对目标1滤波
    [Xkf{1,2}(:,k),P{1,2}]=KalmanFilter(Xkf{1,2}(:,k-1),...
        Zun{1,2}(:,k),P{1,2},F,G,H,Q2,R1); % 观测站1对目标2滤波
    [Xkf{2,1}(:,k),P{2,1}]=KalmanFilter(Xkf{2,1}(:,k-1),...
        Zun{2,1}(:,k),P{2,1},F,G,H,Q1,R2); % 观测站2对目标1滤波
    [Xkf{2,2}(:,k),P{2,2}]=KalmanFilter(Xkf{2,2}(:,k-1),...
        Zun{2,2}(:,k),P{2,2},F,G,H,Q2,R2); % 观测站2对目标2滤波
    % 最后，对照书中第（4）步，用均值法融合两个观测站的滤波结果
    Xmean{1}(:,k)=(Xkf{1,1}(:,k)+Xkf{2,1}(:,k))/2;
    Xmean{2}(:,k)=(Xkf{1,2}(:,k)+Xkf{2,2}(:,k))/2;
end
%%%%%%%%%%%%%%%%%
% 误差分析
Div_Observation{1,1}=zeros(1,T); % 观测站1对目标1的测量偏差
Div_Observation{1,2}=zeros(1,T); % 观测站1对目标2的测量偏差
Div_Observation{2,1}=zeros(1,T); % 观测站2对目标1的测量偏差
Div_Observation{2,2}=zeros(1,T); % 观测站2对目标2的测量偏差
Div_Fusion{1}=zeros(1,T); % 观测站1和2融合后对目标1的估计偏差
Div_Fusion{2}=zeros(1,T); % 观测站1和2融合后对目标2的估计偏差
for k=1:T
    % 统计对目标1的偏差
    x2=X{1}(1,k);y2=X{1}(3,k);
    x1=Zun{1,1}(1,k);y1=Zun{1,1}(2,k);
    Div_Observation{1,1}(1,k)=getDist(x1,y1,x2,y2);
    x1=Zun{2,1}(1,k);y1=Zun{2,1}(2,k);
    Div_Observation{2,1}(1,k)=getDist(x1,y1,x2,y2);
    x1=Xmean{1}(1,k);y1=Xmean{1}(3,k);
    Div_Fusion{1}(1,k)=getDist(x1,y1,x2,y2);
    % 统计对目标2的偏差
    x2=X{2}(1,k);y2=X{2}(3,k);
    x1=Zun{1,2}(1,k);y1=Zun{1,2}(2,k);
    Div_Observation{1,2}(1,k)=getDist(x1,y1,x2,y2);
    x1=Zun{2,2}(1,k);y1=Zun{2,2}(2,k);
    Div_Observation{2,2}(1,k)=getDist(x1,y1,x2,y2);
    x1=Xmean{2}(1,k);y1=Xmean{2}(3,k);
    Div_Fusion{2}(1,k)=getDist(x1,y1,x2,y2);
end
% 时间T内各时刻的平均误差
Div_Observation_Mean11=mean(Div_Observation{1,1}(1,:));
Div_Observation_Mean21=mean(Div_Observation{2,1}(1,:));
Div_Fusion_Mean1=mean(Div_Fusion{1}(1,:));
Div_Observation_Mean12=mean(Div_Observation{1,2}(1,:));
Div_Observation_Mean22=mean(Div_Observation{2,2}(1,:));
Div_Fusion_Mean2=mean(Div_Fusion{2}(1,:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图
figure  % 观测站1的观测、关联、滤波结果
hold on;box on;xlabel('X/m');ylabel('Y/m');
h1=plot(X{1}(1,:),X{1}(3,:),'-k');% 目标1
h2=plot(X{2}(1,:),X{2}(3,:),'-k');% 目标2
h3=plot(Z{1,1}(1,:),Z{1,1}(2,:),'b.'); % 观测1
h4=plot(Z{1,2}(1,:),Z{1,2}(2,:),'b+'); % 观测2
h5=plot(Zun{1,1}(1,:),Zun{1,1}(2,:),'ro'); % 关联观测1
h6=plot(Zun{1,2}(1,:),Zun{1,2}(2,:),'ks'); % 关联观测2
h7=plot(Xkf{1,1}(1,:),Xkf{1,1}(3,:),'-k.'); % 目标1滤波结果
h8=plot(Xkf{1,2}(1,:),Xkf{1,2}(3,:),'-b.'); % 目标2滤波结果
legend('目标1真实轨迹','目标2真实轨迹','观测数据1','观测数据2', ...
    '关联得到的目标1','关联得到的目标2','目标1滤波轨迹','目标2滤波轨迹')
title('观测站1对两个目标的观测、关联、滤波轨迹')
figure  % 观测站2的观测、关联、滤波结果
hold on;box on;xlabel('X/m');ylabel('Y/m');
h1=plot(X{1}(1,:),X{1}(3,:),'-k');% 目标1
h2=plot(X{2}(1,:),X{2}(3,:),'-k');% 目标2
h3=plot(Z{2,1}(1,:),Z{2,1}(2,:),'b.'); % 观测1
h4=plot(Z{2,2}(1,:),Z{2,2}(2,:),'b+'); % 观测2
h5=plot(Zun{2,1}(1,:),Zun{2,1}(2,:),'ro'); % 关联观测1
h6=plot(Zun{2,2}(1,:),Zun{2,2}(2,:),'ks'); % 关联观测2
h7=plot(Xkf{2,1}(1,:),Xkf{2,1}(3,:),'-k.'); % 目标1滤波结果
h8=plot(Xkf{2,2}(1,:),Xkf{2,2}(3,:),'-b.'); % 目标2滤波结果
legend('目标1真实轨迹','目标2真实轨迹','观测数据1','观测数据2', ...
    '关联得到的目标1','关联得到的目标2','目标1滤波轨迹','目标2滤波轨迹')
title('观测站2对两个目标的观测、关联、滤波轨迹')
figure  % 2个观测站最终的融合结果
hold on;box on;xlabel('X/m');ylabel('Y/m');
h1=plot(X{1}(1,:),X{1}(3,:),'-k');% 目标1
h2=plot(X{2}(1,:),X{2}(3,:),'-k');% 目标2
h3=plot(Z{1,1}(1,:),Z{1,1}(2,:),'b.'); % 观测站1对目标1观测
h4=plot(Z{1,2}(1,:),Z{1,2}(2,:),'b*'); % 观测站1对目标2观测
h5=plot(Z{2,1}(1,:),Z{2,1}(2,:),'r.'); % 观测站2对目标1观测
h6=plot(Z{2,2}(1,:),Z{2,2}(2,:),'r*'); % 观测站2对目标2观测
h7=plot(Xmean{1}(1,:),Xmean{1}(3,:),'-bo');% 多观测站融合目标1
h8=plot(Xmean{2}(1,:),Xmean{2}(3,:),'-r^');% 多观测站融合目标2
legend('目标1真实轨迹','目标2真实轨迹','观测站1对目标1观测','观测站1对目标2观测', ...
    '观测站2对目标1观测','观测站2对目标2观测','多观测站融合目标1','多观测站融合目标2')
title('两个观测站对两个目标的观测、融合轨迹')
figure % 对目标1的估计偏差
subplot(121);
hold on;box on;xlabel('Time/s');ylabel('Value of deviation/m');
plot(1:T,Div_Observation{1,1}(1,:),'-kd','MarkerFace','g');
plot(1:T,Div_Observation{2,1}(1,:),'-ks','MarkerFace','b');
plot(1:T,Div_Fusion{1}(1,:),'-ko','MarkerFace','r');
legend('第1站观测偏差','第2站观测偏差','融合后偏差')
title('对目标1的观测偏差')
subplot(122);
hold on;box on;xlabel('Time/s');ylabel('Value of average deviation/m');
bar(2,Div_Observation_Mean11,'r');
bar(4,Div_Observation_Mean21,'g');
bar(6,Div_Fusion_Mean1,'b');
legend('1站偏差','2站偏差','融合偏差')
title('对目标1的平均偏差')
figure % 对目标2的估计偏差
subplot(121);
hold on;box on;xlabel('Time/s');ylabel('Value of deviation/m');
plot(1:T,Div_Observation{1,2}(1,:),'-kd','MarkerFace','g');
plot(1:T,Div_Observation{2,2}(1,:),'-ks','MarkerFace','b');
plot(1:T,Div_Fusion{2}(1,:),'-ko','MarkerFace','r');
legend('第1站观测偏差','第2站观测偏差','融合后偏差');
title('对目标1的观测偏差')
subplot(122);
hold on;box on;xlabel('Time/s');ylabel('Value of average deviation/m');
bar(2,Div_Observation_Mean12,'r');
bar(4,Div_Observation_Mean22,'g');
bar(6,Div_Fusion_Mean2,'b');
legend('1站偏差','2站偏差','融合偏差')
title('对目标2的平均偏差')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%