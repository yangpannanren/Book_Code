%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  程序说明：对比UKF与EKF在非线性系统中应用的算法性能
%  详细原理介绍及中文注释请参考：
%  黄小平，王岩 著，《卡尔曼滤波原理及应用-MATLAB仿真》第2版，电子工业出版社
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ukf_ekf_compair_example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=50; %仿真时间或称数据点个数、步长
L=1;
Q=10;
R=1;
W=sqrtm(Q)*randn(L,N); %过程噪声
V=sqrt(R)*randn(1,N); %观测噪声
X=zeros(L,N);
X(:,1)=(0.1)'; %系统状态初始化
Z=zeros(1,N);
Z(1)=X(:,1)^2/20+V(1); %观测初始化
Xukf=zeros(L,N);
Xukf(:,1)=X(:,1)+sqrtm(Q)*randn(L,1);
Pukf=eye(L); %ukf滤波器初始化
Xekf=zeros(L,N);
Xekf(:,1)=X(:,1)+sqrtm(Q)*randn(L,1);
Pekf=eye(L); %xkf滤波器初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=2:N
    % 状态方差：一阶非线性系统
    X(:,k)=0.5*X(:,k-1)+2.5*X(:,k-1)/(1+X(:,k-1)^2)+8*cos(1.2*k)+W(k);
    % 观测方程：也为非线性
    Z(k)=X(:,k)^2/20+V(k);
    % 调用EKF、UKF算法
    [Xekf(:,k),Pekf]=ekf(Xekf(:,k-1),Pekf,Z(k),Q,R,k);
    [Xukf(:,k),Pukf]=ukf(Xukf(:,k-1),Pukf,Z(k),Q,R,k);
end
% 误差分析
err_ekf=zeros(1,N);
err_ukf=zeros(1,N);
for k=1:N
    % 计算EKF和UKF算法对真实状态之间的偏差
    err_ekf(k)=abs(Xekf(1,k)-X(1,k));
    err_ukf(k)=abs(Xukf(1,k)-X(1,k));
end
% 计算偏差的平均值
err_ave_ekf=sum(err_ekf)/N
err_ave_ukf=sum(err_ukf)/N
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图，对比两种算法与真实状态之间的曲线图
figure
hold on;box on;
plot(X,'-r*');
plot(Xekf,'-ko');
plot(Xukf,'-b+');
legend('真实状态','EKF估计','UKF估计')
xlabel('时间k/s')
ylabel('状态值')
title('EKF和UKF两种状态估计结果对比')
% 画图，对比两种算法与真实状态之间的偏差
figure
hold on;box on;
plot(err_ekf,'-ro');
plot(err_ukf,'-b+');
xlabel('时间k/s')
ylabel('偏差绝对值')
legend('EKF估计','UKF估计')
title('EKF和UKF各个时刻的估计偏差对比')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子程序：EKF算法
function [Xout,Pout]=ekf(Xin,P,Zin,Q,R,k)
% 状态的一步预测
Xpre=0.5*Xin+2.5*Xin/(1+Xin^2)+8*cos(1.2*k);
% 状态转移矩阵的一阶线性化
F=0.5+(2.5*(1+Xpre^2)-2.5*Xpre*2*Xpre)/(1+Xpre^2)^2;
% 状态预测
Ppre=F*P*F'+Q;
% 观测预测
Zpre=Xpre^2/20;
% 观测矩阵的一阶线性化
H=Xpre/10;
% 计算Kalman增益
K=Ppre*H'/(H*Ppre*H'+R);
% 状态更新
Xout=Xpre+K*(Zin-Zpre);
% 方差更新
Pout=(eye(1)-K*H)*Ppre;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子程序：UKF算法
function [Xout,Pout]=ukf(X,P0,Z,Q,R,k)
L=1; %状态维数
alpha=1;    %UT变换相关参数
kalpha=0;   %UT变换相关参数
belta=2;    %UT变换相关参数
ramda=3-L;  %UT变换相关参数
for j=1:2*L+1 %权值
    Wm(j)=1/(2*(L+ramda));
    Wc(j)=1/(2*(L+ramda));
end
Wm(1)=ramda/(L+ramda);
Wc(1)=ramda/(L+ramda)+1-alpha^2+belta;
xestimate= X;
P=P0;
cho=(chol(P*(L+ramda)))';
for j=1:L %sigma点的计算
    xgamaP1(:,j)=xestimate+cho(:,j);
    xgamaP2(:,j)=xestimate-cho(:,j);
end
Xsigma=[xestimate,xgamaP1,xgamaP2];
for j=1:2*L+1 %预测
    Xsigmapre(:,j)=0.5*Xsigma(:,j)+2.5*Xsigma(:,j)/(1+Xsigma(:,j)^2)+8*cos(1.2*k);
end
Xpred=0;
for j=1:2*L+1
    Xpred=Xpred+Wm(j)*Xsigmapre(:,j);
end
Ppred=0;
for j=1:2*L+1 %协方差预测
    Ppred=Ppred+Wc(j)*(Xsigmapre(:,j)-Xpred)*(Xsigmapre(:,j)-Xpred)';
end
Ppred=Ppred+Q;
chor=(chol((L+ramda)*Ppred))';
for j=1:L
    XaugsigmaP1(:,j)=Xpred+chor(:,j);
    XaugsigmaP2(:,j)=Xpred-chor(:,j);
end
Xaugsigma=[Xpred XaugsigmaP1 XaugsigmaP2];
for j=1:2*L+1
    Zsigmapre(1,j)=Xaugsigma(:,j)^2/20;
end
Zpred=0;
for j=1:2*L+1 %两个重要的协方差预测
    Zpred=Zpred+Wm(j)*Zsigmapre(1,j);
end
Pzz=0;
for j=1:2*L+1
    Pzz=Pzz+Wc(j)*(Zsigmapre(1,j)-Zpred)*(Zsigmapre(1,j)-Zpred)';
end
Pzz=Pzz+R;
Pxz=0;
for j=1:2*L+1
    Pxz=Pxz+Wc(j)*(Xaugsigma(:,j)-Xpred)*(Zsigmapre(1,j)-Zpred)';
end
% 计算Kalman增益
K=Pxz*inv(Pzz);
% 状态更新
xestimate=Xpred+K*(Z-Zpred);
% 协方差更新
P=Ppred-K*Pzz*K';
% 输入，返回值设置
Pout=P;
Xout=xestimate;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%