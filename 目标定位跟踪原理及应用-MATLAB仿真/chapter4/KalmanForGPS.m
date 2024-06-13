function KalmanForGPS % Kalman滤波在船舶GPS导航定位系统中的应用
dt=1;%雷达扫描周期,
T=80/dt; %总的采样次数
F=[1,dt,0,0;0,1,0,0;0,0,1,dt;0,0,0,1];  % 状态转移矩阵
H=[1,0,0,0;0,0,1,0];   % 观测矩阵
delta_w=1e-2;  %如果增大这个参数，目标真实轨迹就是曲线了
Q=delta_w*diag([0.5,1,0.5,1]) ; % 过程噪声方差
R=10*eye(2);                   % 观测噪声方差
W=sqrtm(Q)*randn(4,T);          % 过程噪声
V=sqrtm(R)*randn(2,T);          % 观测噪声
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X=zeros(4,T);   % 目标真实位置、速度
X(:,1)=[-100,2,200,20];% 目标初始位置、速度
Z=zeros(2,T);   % 传感器对位置的观测
Z(:,1)=[X(1,1),X(3,1)];  % 观测初始化
Xkf=zeros(4,T); % kalman滤波状态初始化
Xkf(:,1)=X(:,1);
P=eye(4); % 协方差阵初始化
for k=2:T
    % 船体自身运动
    X(:,k)=F*X(:,k-1)+W(:,k);%目标真实轨迹

    % 获取卫星数据，观测信息开始滤波
    Z(:,k)=H*X(:,k)+V(:,k); %自导航，观测信息
    Xpre=F*Xkf(:,k-1); % 第一步：状态预测
    Ppre=F*P*F'+Q;     % 第二步：协方差预测
    K=Ppre*H'*inv(H*Ppre*H'+R);% 第三步：求增益
    Xkf(:,k)=Xpre+K*(Z(:,k)-H*Xpre);% 第四步：状态更新
    P=(eye(4)-K*H)*Ppre;% 第五步：协方差更新
end
% 误差分析
for i=1:T
    Err_Observation(i)=RMS(X(:,i),Z(:,i)); % 滤波前的误差
    Err_KalmanFilter(i)=RMS(X(:,i),Xkf(:,i)); % 滤波后的误差
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图
figure % 轨迹图
hold on;box on;xlabel('X/m');ylabel('Y/m');
plot(X(1,:),X(3,:),'-k'); % 真实轨迹
plot(Z(1,:),Z(2,:),'-b.'); % 观测轨迹
plot(Xkf(1,:),Xkf(3,:),'-r+'); % kalman滤波轨迹
legend('真实轨迹','观测轨迹','滤波轨迹')
figure % 误差图
hold on; box on;xlabel('Time/s');ylabel('value of the deviation/m');
plot(Err_Observation,'-ko','MarkerFace','g')
plot(Err_KalmanFilter,'-ks','MarkerFace','r')
legend('观测偏差','滤波后偏差')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子函数：计算偏差
function dist=RMS(X1,X2)
if length(X2)<=2
    dist=sqrt( (X1(1)-X2(1))^2 + (X1(3)-X2(2))^2 );
else
    dist=sqrt( (X1(1)-X2(1))^2 + (X1(3)-X2(3))^2 );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%