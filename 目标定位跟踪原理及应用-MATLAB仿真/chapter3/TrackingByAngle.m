%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序功能：纯方位角目标跟踪程序
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TrackingByAngle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 定位初始化
Length=100;  % 场地空间，单位：米
Width=100;   % 场地空间，单位：米
Node_number=5;      % 观测站的个数，也可以设置成3个，4个，但是最少必须要3个
for i=1:Node_number % 观测站的位置初始化，这里位置是随机给定的
    Node(i).x=Width*rand; 
    Node(i).y=Length*rand;
end
T=1;                      %雷达扫描周期,  
N=60/T;                   %总的采样次数,也称步长
delta_w=1e-4;              % 如果增大这个参数，目标真实轨迹就是曲线了
Q=delta_w*diag([0.5,1]) ;     % 过程噪声方差
R=0.1*pi/180;             % 观测噪声方差
G=[T^2/2,0;T,0;0,T^2/2;0,T];          % 过程噪声驱动矩阵
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];  % 状态转移矩阵
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X=zeros(4,N);           % 目标真实状态初始化
X(:,1)=[20,1.4,0,1.5];      % 目标初始位置、速度
Z=zeros(Node_number,N); % 各观测站的传感器对位置的观测
Xn=zeros(2,N);          % 估计出的位置
for t=2:N               % 目标运动
    X(:,t)=F*X(:,t-1)+G*sqrtm(Q)*randn(2,1);    %目标真实轨迹
end
for t=1:N
    for i=1:Node_number
        cita=hfun(X(:,t),Node(i));      % 观测角度
        Z(i,t)=cita+sqrtm(R)*randn;     % 模拟观测的角度受到噪声的污染
    end
% 对当前时刻目标位置的二乘法的估算
    A=[];b=[];
    for i=1:Node_number
        A(i,:)=[tan(Z(i,t)),-1];
        b(i,1)=[Node(i).x*tan(Z(i,t))-Node(i).y];
        end  
    inv(A'*A)*A'*b
    Xn(:,t)=inv(A'*A)*A'*b; % 得到目标当前时刻的位置
end
for t=1:N   % 偏差分析
    error(t)=sqrt( (X(1,t)-Xn(1,t))^2+(X(3,t)-Xn(2,t))^2 );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%画图
figure
hold on;box on;xlabel('x/m');ylabel('y/m'); % 输出图形的框架
for i=1:Node_number
    h1=plot(Node(i).x,Node(i).y,'ko','MarkerFace','g');
    text(Node(i).x+2,Node(i).y,['Node ',num2str(i)]);
end
h2=plot(X(1,:),X(3,:),'-r');
h3=plot(Xn(1,:),Xn(2,:),'-k.');
legend([h1,h2,h3],'Observation Station','True Trace','MLE Ttace');
figure
hold on;box on;xlabel('time/s');ylabel('value of the deviation'); 
plot(error,'-ko','MarkerFace','g');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子函数
function angle=hfun(A,B) % 角度观测方程
angle=atan( (A(3)-B.y)/(A(1)-B.x) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

