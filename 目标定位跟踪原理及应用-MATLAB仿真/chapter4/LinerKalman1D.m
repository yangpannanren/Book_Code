function LinerKalman1D  % 一维kalman滤波应用仿真
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 系统信息
F=1;  % 状态转移矩阵
G=1;  % 噪声驱动矩阵
H=1;  % 观测矩阵
Q=0.0001;  % 过程噪声方差
R=0.0025;  % 观测噪声方差
T=100;     % 仿真总步数
W=sqrt(Q)*randn(1,T); % 各时刻的过程噪声
V=sqrt(R)*randn(1,T); % 各时刻的观测噪声
I=eye(1);             % 单位1矩阵
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 开始仿真目标状态和测量过程
X=zeros(1,T);X(1,1)=8.00;       % 状态初始化，也叫目标真实值
Z=zeros(1,T);Z(1,1)=8.01;       % 观测初始化
Xkf=zeros(1,T);Xkf(1,1)=Z(1,1); % Kalman滤波得到的状态初始化
P=zeros(1,T);P(1,1)=0.0001;                       % 协方差初始化
for k=2:T
    % 被测量目标一侧信息
    % X是架空线的真实高度值，它由真实值和风吹扰动导致的干扰组成
    % X是计算机模拟仿真，是真实状态的模拟，测距仪是永远测不到的
    X(1,k)=F*X(1,k-1)+G*W(1,k); % 状态方程
    
    % 观测站一侧的信息
    % 测距仪只能通过传感器测量，测量信息是Z，根据测量信息开始滤波
    Z(1,k)=H*X(1,k)+V(1,k);     % 观测方程
    Xpre=H*Xkf(1,k-1);          % 第一步：状态预测
    Ppre=F*P(k-1)*F'+Q;         % 第二步：协方差预测
    K=Ppre*inv(H*Ppre*H'+R);    % 第三步：计算Kalman增益
    e=Z(k)-H*Xpre;              % 计算新息
    Xkf(1,k)=Xpre+K*e;          % 第四步：状态更新 
    P(1,k)=(I-K*H)*Ppre;        % 第五步：协方差更新
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 误差分析
MeasuredDeviation=abs(Z-X);
FilterResultDeviation=abs(Xkf-X);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图
figure % 轨迹图
hold on;box on;axis([0 T 7.5 8.5]) % 画图框架初始化
xlabel('time/10ms');ylabel('messure value'); % x、y轴名称
plot(1:T,X(1,1:T),'-k');  % 真实值
plot(1:T,Z(1,1:T),'-ko','MarkerFace','g'); % 测量值
plot(1:T,Xkf(1:T),'-r.'); % 滤波值
legend('true value','measured value','filtered value');
figure % 误差分析图 
hold on;box on;%axis([0 T 7.5 8.5]) % 画图框架初始化
xlabel('time/10ms');ylabel('value of the deviation'); % x、y轴名称
plot(MeasuredDeviation,'-r.','MarkerFace','g'); % 测量误差
plot(FilterResultDeviation,'-ko','MarkerFace','g'); % 滤波结果误差
legend('measured deviation','filtered deviation');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

