function TrackingByDist % 基于距离的跟踪（连续定位）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 系统模型的基本信息，包括场地大小，观测站位置，模型驱动参数等
Length=100;               % 场地空间，单位：米
Width=100;                % 场地空间，单位：米
Node_number=5;   % 观测站的个数，也可以设置成3个，4个，但是最少必须要3个
for i=1:Node_number       % 观测站的位置初始化，这里位置是随机给定的
    Node(i).x=Width*rand; 
    Node(i).y=Length*rand;
    Node(i).D=Node(i).x^2+Node(i).y^2;% 为了快速计算，后面会频繁用到这个数
end
T=1;                %雷达采样时间,单位：秒
N=60/T;             %总的采样次数
delta_w=1e-3;        %如果增大这个参数，目标真实轨迹就是曲线了
Q=delta_w*diag([0.5,1]) ;         % 过程噪声均值
R=1;                          %观测噪声方差
G=[T^2/2,0;T,0;0,T^2/2;0,T];      % 过程噪声驱动矩阵
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];  % 状态转移矩阵
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 开始模拟目标运动，观测在目标运动中同时采样，测量距离
X(:,1)=[0,1.5,20,1.4];       % 目标初始位置、速度,状态参数格式[x,vx,y,vy]'
Z=zeros(Node_number,N);  % 各观测站的传感器对位置的观测
Xn=zeros(2,N);           % 最小二乘估计出的位置
for t=2:N  % 状态方程的建模：目标运动，时间从1T->NT
    X(:,t)=F*X(:,t-1)+G*sqrtm(Q)*randn(2,1);    %目标真实轨迹
end
for t=1:N  % 观测方程的建模：多观测站观测目标，时间从1T->NT
    for i=1:Node_number % 多个观测站对t时刻目标距离测量
        [d1,d2]=DIST(X(:,t),Node(i));    % d1是真实距离，d2是真实距离的平方
        Z(i,t)=d1+sqrtm(R)*randn;       % 模拟观测的距离受到噪声的污染
    end
    % 对当前时刻目标位置的二乘法估算
    A=[];b=[];
    for i=2:Node_number
        A(i-1,:)=2*[Node(i).x-Node(1).x,Node(i).y-Node(1).y];
        b(i-1,1)=Z(1,t)^2-Z(i,t)^2+Node(i).D-Node(1).D;
    end  
    Xn(:,t)=inv(A'*A)*A'*b; % 得到目标当前时刻的位置
end
for t=1:N  % 计算位置偏差，即用最小二乘位置与计算机模拟的目标真实位置做差
    error(t)=sqrt( (X(1,t)-Xn(1,t))^2+(X(3,t)-Xn(2,t))^2 );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure % 轨迹图
hold on;box on;xlabel('x/m');ylabel('y/m');    % 输出图形的框架
for i=1:Node_number
    h1=plot(Node(i).x,Node(i).y,'ko','MarkerFace','g','MarkerSize',10);
    text(Node(i).x+2,Node(i).y,['Node ',num2str(i)]);
end
h2=plot(X(1,:),X(3,:),'-r'); % 目标的真实位置
h3=plot(Xn(1,:),Xn(2,:),'-k.'); % 目标的估计位置
legend([h1,h2,h3],'observation station','ture trajectory','estimate trajectory')
figure % 偏差图
hold on;box on;xlabel('time/s');ylabel('value of the deviation'); 
plot(error,'-ko','MarkerFace','g');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子函数，计算两点间的距离/距离平法
function [dist,dist2]=DIST(A,B)
dist2=(A(1)-B.x)^2+(A(3)-B.y)^2; % 距离的二次方
dist=sqrt(dist2);  % 距离
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%