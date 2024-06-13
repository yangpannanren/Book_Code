%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：目标跟踪程序，实现运动弹头对运动物体的三维跟踪，主函数
% 状态方程： x(t)=Ax(t-1)+Bu(t-1)+w(t）
% 参考资料：《寻的导弹新型导引》第5.5和5.6节中仿真参数设置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delta_t=0.01; % 测量周期,采样周期
longa=10000;  % 机动时间常数的倒数，即机动频率
tf=3.7;
T=tf/delta_t;  % 时间长度3.7秒钟，一共采样T=370次
% 状态转移矩阵fai
F=[eye(3),delta_t*eye(3),(exp(-1*longa*delta_t)+...
    longa*delta_t-1)/longa^2*eye(3);
    zeros(3),eye(3),(1-exp(-1*longa*delta_t))/longa*eye(3);
    zeros(3),zeros(3),exp(-1*longa*delta_t)*eye(3)];
% 控制量驱动矩阵gama
G=[-1*0.5*delta_t^2*eye(3);-1*delta_t*eye(3);zeros(3)];
N=3;  % 导航比（制导律）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% u=10*ones(3,T);
for i=1:50    % 做50次蒙特卡罗仿真
    x=zeros(9,T);
    x(:,1)=[3500,1500,1000,-1100,-150,-50,0,0,0]'; % 初始状态X（0）
    ex=zeros(9,T);
    ex(:,1)=[3000,1200,960,-800,-100,-100,0,0,0]';% 滤波器状态Xekf（0）
    cigema=sqrt(0.1);
    w=[zeros(6,T);cigema*randn(3,T)]; % 过程噪声
    Q=[zeros(6),zeros(6,3);zeros(3,6),cigema^2*eye(3)];
    z=zeros(2,T);       % 观测值
    z(:,1)=[atan( x(2,1)/sqrt(x(1,1)^2+x(3,1)^2) ), atan(-1*x(3,1)/x(1,1))]';
    v=zeros(2,T);      % 观测噪声
    for k=2:T-3
        tgo=tf-k*0.01+0.0000000000000001;
        c1=N/tgo^2;   % 制导律的系数
        c2=N/tgo;     % 制导律的系数
        c3=N*(exp(-longa*tgo)+longa*tgo-1)/(longa*tgo)^2;  % 制导律的系数
        % X,Y,Z三个方向的导弹加速度
        u(1,k-1)=[c1,c2,c3]*[x(1,k-1),x(4,k-1),x(7,k-1)]';
        u(2,k-1)=[c1,c2,c3]*[x(2,k-1),x(5,k-1),x(8,k-1)]';
        u(3,k-1)=[c1,c2,c3]*[x(3,k-1),x(6,k-1),x(9,k-1)]';
        x(:,k)=F*x(:,k-1)+G*u(:,k-1)+w(:,k-1);  % 目标状态方程
        d=sqrt(x(1,k)^2+x(2,k)^2+x(3,k)^2);
        D=[d,0;0,d];  % 参考书中公式
        R=inv(D)*0.1*eye(2)*inv(D)';% 观测噪声方差
        v(:,k)=sqrtm(R)*randn(2,1); % 观测噪声模拟
        % 目标观测方程
        z(:,k)=[atan( x(2,k)/sqrt(x(1,k)^2+x(3,k)^2) ), ...
            atan(-1*x(3,k)/x(1,k))]'+v(:,k);
    end
    % 下面根据观测值开始滤波
    P0=[10^4*eye(6),zeros(6,3);zeros(3,6),10^2*eye(3)]; % 协方差初始化
    eP0=P0;
    for k=2:T-3
        dd=sqrt(ex(1,k-1)^2+ex(2,k-1)^2+ex(3,k-1)^2);
        DD=[dd,0;0,dd];
        RR=0.1*eye(2)/(DD*DD');
        tgo=tf-k*0.01+0.0000000000000001;
        c1=N/tgo^2;
        c2=N/tgo;
        c3=N*(exp(-longa*tgo)+longa*tgo-1)/(longa*tgo)^2;
        u(1,k-1)=[c1,c2,c3]*[ex(1,k-1),ex(4,k-1),ex(7,k-1)]';
        u(2,k-1)=[c1,c2,c3]*[ex(2,k-1),ex(5,k-1),ex(8,k-1)]';
        u(3,k-1)=[c1,c2,c3]*[ex(3,k-1),ex(6,k-1),ex(9,k-1)]';
        % 调用扩展卡尔曼算法子函数
        [ex(:,k),eP0]=ekf(F,G,Q,RR,eP0,u(:,k-1),z(:,k),ex(:,k-1));
    end
    for t=1:T-3 % 求每个时间点误差的平方
        Ep_ekfx(i,t)=sqrt((ex(1,t)-x(1,t))^2);
        Ep_ekfy(i,t)=sqrt((ex(2,t)-x(2,t))^2);
        Ep_ekfz(i,t)=sqrt((ex(3,t)-x(3,t))^2);
        Ep_ekf(i,t)=sqrt( (ex(1,t)-x(1,t))^2+(ex(2,t)-x(2,t))^2+(ex(3,t)-x(3,t))^2 );
        Ev_ekf(i,t)=sqrt( (ex(4,t)-x(4,t))^2+(ex(5,t)-x(5,t))^2+(ex(6,t)-x(6,t))^2 );
        Ea_ekf(i,t)=sqrt( (ex(7,t)-x(7,t))^2+(ex(8,t)-x(8,t))^2+(ex(9,t)-x(9,t))^2 );
    end

    for t=1:T-3 % 求误差的均值，即RMS
        error_x(t)=mean(Ep_ekfx(:,t));
        error_y(t)=mean(Ep_ekfy(:,t));
        error_z(t)=mean(Ep_ekfz(:,t));
        error_r(t)=mean(Ep_ekf(:,t));
        error_v(t)=mean(Ev_ekf(:,t));
        error_a(t)=mean(Ea_ekf(:,t));
    end
end

t=0.01:0.01:3.67;
figure
hold on;box on;grid on;
plot3(x(1,:),x(2,:),x(3,:),'-k.')
plot3(ex(1,:),ex(2,:),ex(3,:),'-r.','MarkerFace','r')
legend('real','ekf');
view(3)
xlabel('x/m');ylabel('y/m');zlabel('z/m');
title('跟踪轨迹运行结果')
figure
hold on;box on;grid on;
plot(t,error_r,'b');
xlabel('飞行时间/s');
ylabel('弹目相对距离估计误差/m');
title('位置偏差')
figure
hold on;box on;grid on;
plot(t,error_v,'b');
xlabel('飞行时间/s');
ylabel('速度估计误差m/s');
title('速度偏差')
figure
hold on;box on;grid on;
plot(t,error_a,'b');
xlabel('飞行时间/s');
ylabel('加速度估计误差m/s^2');
title('加速度偏差')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 函数说明： 扩展卡尔曼滤波算法，子函数
% 函数参数： ex为扩展卡尔曼估计得到的状态
function [ex,P0]=ekf(F,G,Q,R,P0,u,z,ex)
% 状态预测
Xn=F*ex+G*u;
% 观测预测
Zn=[atan( Xn(2)/sqrt(Xn(1)^2+Xn(3)^2) ),atan(-1*Xn(3)/Xn(1))]';
% 协方差阵预测
P=F*P0*F'+Q;
% 计算线性化的H矩阵
dh1_dx=-1*Xn(1)*Xn(2)/(Xn(1)^2+Xn(2)^2+Xn(3)^2)/sqrt(Xn(1)^2+Xn(3)^2);
dh1_dy=sqrt(Xn(1)^2+Xn(3)^2)/(Xn(1)^2+Xn(2)^2+Xn(3)^2);
dh1_dz=-1*Xn(2)*Xn(3)/(Xn(1)^2+Xn(2)^2+Xn(3)^2)/sqrt(Xn(1)^2+Xn(3)^2);
dh2_dx=Xn(3)/(Xn(1)^2+Xn(3)^2);
dh2_dy=0;
dh2_dz=-1*Xn(1)/(Xn(1)^2+Xn(3)^2);
H=[dh1_dx,dh1_dy,dh1_dz,0,0,0,0,0,0;dh2_dx,dh2_dy,dh2_dz,0,0,0,0,0,0];
% kalman增益
K=P*H'/(H*P*H'+R);
% 状态更新
ex=Xn+K*(z-Zn);
% 协方差阵更新
P0=(eye(9)-K*H)*P;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%