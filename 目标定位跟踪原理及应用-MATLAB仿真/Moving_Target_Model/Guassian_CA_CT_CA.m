clc;clear;close all;
% 第一阶段初始参数
x0 = 1000;
y0 = 1000;
t1 = 100;
t2 = 200;
t3 = 300;
vx = 14/sqrt(2);
vy = 14/sqrt(2);
dt = 1;
cv_F = [1, dt, 0, 0;
        0, 1, 0, 0;
        0, 0, 1, dt;
        0, 0, 0, 1];
H = [1 0 0 0;0 0 1 0]; 
w = -pi/180;
ct_F= [1 sin(w*dt)/w 0 -(1-cos(w*dt))/w
       0 cos(w*dt)   0 -sin(w*dt)
       0 (1-cos(w*dt))/w 1 sin(w*dt)/w
       0  sin(w*dt) 0 cos(w*dt) ]; 

% 卡尔曼滤波初始参数
Q = 1e-2*diag([1 1 1 1]);%过程噪声方差
R = 100*eye(2);          %观测噪声方差
W = sqrtm(Q)*randn(4,t3);%过程噪声
V = sqrtm(R)*randn(2,t3);%测量噪声
x_true = zeros(4,t3);x_true(:,1) = [x0,vx,y0,vy];
X = zeros(4,t3);X(:,1) = [x0,vx,y0,vy];  %目标初始位置和速度
Z = zeros(2,t3);Z(:,1) = [x0,y0];  %观测初始化
Xkf = zeros(4,t3);Xkf(:,1) = X(:,1);       %KF得到的状态初始化
Xukf = zeros(4,t3);Xukf(:,1) = X(:,1);     %无迹卡尔曼滤波得到的状态初始化
% GKF
GXkf = zeros(4,t3);GXkf(:,1) = X(:,1);     %GKF得到的状态初始化

P0 = eye(4);                               %初始协方差
P1 = eye(4);                               %初始协方差

% 对数据高斯滤波,设置高斯模板大小和标准差
l = 4;
L = [l l l l];
sigma = [sqrt(0.5) 1 sqrt(0.5) 1];
N_mod = 21;

%% 第一阶段匀速直线(CV)
for k = 2:t1
    x_true(:,k) = cv_F*x_true(:,k-1);
    % KF
    %X(:,k) = cv_F*X(:,k-1)+W(:,k);            %目标真实轨迹
    X(:,k) = cv_F*X(:,k-1);            %目标真实轨迹
    Z(:,k) = H*X(:,k)+V(:,k);       %观测方程
    Xpre = cv_F*Xkf(:,k-1);                  %第一步:状态预测
    Ppre = cv_F*P0*cv_F'+Q;                     %第二步:协方差预测
    K = Ppre*H'*inv(H*Ppre*H'+R);   %第三步:计算Kalman增益
    Xkf(:,k) = Xpre+K*(Z(:,k)-H*Xpre); %第四步:状态更新
    %GKF
    GXkf(:,k) = Xkf(:,k);  
    if mod(k,N_mod) == 0
        for i = 1:4
            GXkf(i,(k/N_mod-1)*N_mod+1:k) = Gaussianfilter( L(i), sigma(i), GXkf(i,(k/N_mod-1)*N_mod+1:k) );
        end
    end
    P0 = (eye(4)-K*H)*Ppre;                %第五步:协方差更新
    % UKF
    [Xukf(:, k), Pukf] = UKF(Xukf(:, k - 1), P1, Z(:,k), Q, R, cv_F, H);
    P1 = Pukf;
end

%% 第二阶段匀速转弯(CT)
for k = t1+1:t2
    x_true(:,k) = ct_F*x_true(:,k-1);
    % KF
    %X(:,k) = ct_F*X(:,k-1)+W(:,k);            %目标真实轨迹
    X(:,k) = ct_F*X(:,k-1);            %目标真实轨迹
    Z(:,k) = H*X(:,k)+V(:,k);       %观测方程
    Xpre = ct_F*Xkf(:,k-1);                  %第一步:状态预测
    Ppre = ct_F*P0*ct_F'+Q;                     %第二步:协方差预测
    K = Ppre*H'*inv(H*Ppre*H'+R);   %第三步:计算Kalman增益
    Xkf(:,k) = Xpre+K*(Z(:,k)-H*Xpre); %第四步:状态更新
    GXkf(:,k) = Xkf(:,k);  
    if mod(k,N_mod) == 0
        for i = 1:4
            GXkf(i,(k/N_mod-1)*N_mod+1:k) = Gaussianfilter( L(i), sigma(i), GXkf(i,(k/N_mod-1)*N_mod+1:k) );
        end
    end
    P0 = (eye(4)-K*H)*Ppre;                %第五步:协方差更新
    % UKF
    [Xukf(:, k), Pukf] = UKF(Xukf(:, k - 1), P1, Z(:,k), Q, R, ct_F, H);
    P1 = Pukf;
end

%% 第三阶段匀速直线(CV)
for k = t2+1:t3
    x_true(:,k) = cv_F*x_true(:,k-1);
    % KF
    %X(:,k) = cv_F*X(:,k-1)+W(:,k);            %目标真实轨迹
    X(:,k) = cv_F*X(:,k-1);            %目标真实轨迹
    Z(:,k) = H*X(:,k)+V(:,k);       %观测方程
    Xpre = cv_F*Xkf(:,k-1);                  %第一步:状态预测
    Ppre = cv_F*P0*cv_F'+Q;                     %第二步:协方差预测
    K = Ppre*H'*inv(H*Ppre*H'+R);   %第三步:计算Kalman增益
    Xkf(:,k) = Xpre+K*(Z(:,k)-H*Xpre); %第四步:状态更新
    GXkf(:,k) = Xkf(:,k);  
    if mod(k,N_mod) == 0
        for i = 1:4
            GXkf(i,(k/N_mod-1)*N_mod+1:k) = Gaussianfilter( L(i), sigma(i), GXkf(i,(k/N_mod-1)*N_mod+1:k) );
        end
    end
    P0 = (eye(4)-K*H)*Ppre;                %第五步:协方差更新
    % UKF
    [Xukf(:, k), Pukf] = UKF(Xukf(:, k - 1), P1, Z(:,k), Q, R, cv_F, H);
    P1 = Pukf;
end

%% 误差分析
for i = 1:t3
    Err_Observation(i) = RMS(X(:,i),Z(:,i));   %观测误差
    Err_KalmanFilter(i) = RMS(X(:,i),Xkf(:,i));%滤波后的误差
    Err_U_KalmanFilter(i) = RMS(X(:,i),Xukf(:,i));%滤波后的误差
    Err_G_KalmanFilter(i) = RMS(X(:,i),GXkf(:,i));%滤波后的误差
end
AVG_Err_Observation = mean(Err_Observation)
AVG_Err_KalmanFilter = mean(Err_KalmanFilter)
AVG_Err_U_KalmanFilter = mean(Err_U_KalmanFilter)
AVG_Err_G_KalmanFilter = mean(Err_G_KalmanFilter)
%% 画图
figure %画图输出
plot(x_true(1,:),x_true(3,:),'b');  
legend('真实值');
axis([0 4500 0 3000]);
figure %画图输出
hold on;box on;xlabel('X/m');ylabel('Y/m');
plot(X(1,:),X(3,:),'-k');                      %真实轨迹
plot(Z(1,:),Z(2,:),'r.');                     %观测轨迹
plot(Xkf(1,:),Xkf(3,:),'-g');                 %Kalman滤波轨迹
plot(Xukf(1,:),Xukf(3,:),'-g');                 %UKF轨迹
plot(GXkf(1,:),GXkf(3,:),'-r');                 %GKF轨迹
legend('真实轨迹','观测轨迹','KF轨迹','UKF轨迹','GKF轨迹','Location','northwest');
axis([0 4500 0 3000]);
figure %误差图
hold on;box on;xlabel('Time/s');ylabel('value of the deviation/m');
plot(Err_Observation,'-ko','MarkerFace','b');    %观测的误差
plot(Err_KalmanFilter,'-ks','MarkerFace','g');   %滤波后的误差
plot(Err_U_KalmanFilter,'-kd','MarkerFace','r');   %滤波后的误差
plot(Err_G_KalmanFilter,'-k^','MarkerFace','y');   %滤波后的误差
legend('观测偏差','KF偏差','UKF偏差','GKF');

%% 子函数
% 距离
function dist = RMS(A,B)
if length(B) <= 2
    dist = sqrt( (A(1)-B(1))^2+(A(3)-B(2))^2 );
else
    dist = sqrt( (A(1)-B(1))^2+(A(3)-B(3))^2 );
end
end

% 无迹卡尔曼滤波
function [xk,pk]=UKF(X0,P0,z,Q,R,F,H)
L = size(X0,1);
alpha=1;
belta=2;
ramda=3-L;
for j=1:2*L+1
    Wm(j)=1/(2*(L+ramda));
    Wc(j)=1/(2*(L+ramda));
end
Wm(1)=ramda/(L+ramda);
Wc(1)=ramda/(L+ramda)+1-alpha^2+belta;
sxk = 0;spk = 0;syk = 0;
py = 0;pxy = 0;
P=P0;
cho=(chol(P*(L+ramda)))';
%-----------构造sigma点------------
for j=1:L
    xsigma1(:,j)=X0+cho(:,j);
    xsigma2(:,j)=X0-cho(:,j);
end
xsigma=[X0,xsigma1,xsigma2];
%------------时间传播方程--------------
for j=1:2*L+1
    xsigma(:,j)=F*xsigma(:,j);
    sxk=sxk+Wm(j)*xsigma(:,j);
end
%-------------measure----------
for j=1:2*L+1
    spk=spk+Wc(j)*(xsigma(:,j)-sxk)*(xsigma(:,j)-sxk)';
end
spk=spk+Q;
%--------system-------
for j=1:2*L+1
    rk(:,j)=H*xsigma(:,j);
end
for j=1:2*L+1
    syk=syk+Wm(j)*rk(:,j);
end
%-------------测量更新方程----------------
for j=1:2*L+1
    py=py+Wc(j)*(rk(:,j)-syk)*(rk(:,j)-syk)';
end
py=py+R;
for j=1:2*L+1
    pxy=pxy+Wc(j)*(xsigma(:,j)-sxk)*(rk(:,j)-syk)';
end
K=pxy*inv(py);
xk=sxk+K*(z-syk);
pk=spk-K*py*K';
end
% 功能：对一维信号的高斯滤波，头尾r/2的信号不进行滤波
% r     :高斯模板的大小推荐奇数
% sigma :标准差
% y     :需要进行高斯滤波的序列
function y_filted = Gaussianfilter(r, sigma, y)
% 生成一维高斯滤波模板
GaussTemp = ones(1,r*2-1);
for i=1 : r*2-1
    GaussTemp(i) = exp(-(i-r)^2/(2*sigma^2))/(sigma*sqrt(2*pi));
end
% 高斯滤波
y_filted = y;
for i = r : length(y)-r+1
    y_filted(i) = y(i-r+1 : i+r-1)*GaussTemp';
end
end