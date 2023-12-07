%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序功能：质心定位算法程序
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CentroidLocalization % 质心定位算法
% 定位初始化
Length=100;   % 场地空间，单位：米
Width=100;   % 场地空间，单位：米
d=50;        % 目标离观测站50米以内都能探测到，反之则不能
N=6;         % 观测站的个数
for i=1:N      % 观测站的位置初始化，这里位置是随机给定的
    Node(i).x=Width*rand;
    Node(i).y=Length*rand;
end
% 目标的出现在监测场地的真实位置，这里也随机给定
Target.x=Width*rand;
Target.y=Length*rand;
X=[]; % 初始化，找出能探测到目标的观测站的位置集合
for i=1:N      % 观测站的位置初始化，这里位置是随机给定的
    Node(i).x=Width*rand;
    Node(i).y=Length*rand;
end
% 目标的出现在监测场地的真实位置，这里也随机给定
Target.x=Width*rand;
Target.y=Length*rand;
X=[]; % 初始化，找出能探测到目标的观测站的位置集合
for i=1:N
    if getDist(Node(i),Target)<=d  % 调用计算距离子函数
        X=[X;Node(i).x,Node(i).y]; % 保存探测到目标的观测站位置
    end
end
M=size(X,1);   % 探测到目标的观测站个数
if M>0
    Est_Target.x=sum(X(:,1))/M;  % 质心算法估计位置x
    Est_Target.y=sum(X(:,2))/M;  % 质心算法估计位置y
    Error_Dist=getDist(Est_Target,Target)  % 目标真实位置与估计位置的偏差距离
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure  % 画图
hold on;box on;axis([0 100 0 100]); % 输出图形的框架
for i=1:N  % 画观测站
    h1=plot(Node(i).x,Node(i).y,'ko','MarkerFace','g','MarkerSize',10);
    text(Node(i).x+2,Node(i).y,['Node ',num2str(i)]);
end
% 画目标的真实位置和估计位置
h2=plot(Target.x,Target.y,'k^','MarkerFace','b','MarkerSize',10);
h3=plot(Est_Target.x,Est_Target.y,'ks','MarkerFace','r','MarkerSize',10);
% 将估计位置与真实位置用线连起来
line([Target.x,Est_Target.x],[Target.y,Est_Target.y],'Color','k');
% 画出目标方圆d的范围
circle(Target.x,Target.y,d);
% 标明h1,h2,h3都是什么
legend([h1,h2,h3],'Observation Station','Target Postion','Estimate Postion');
xlabel(['error=',num2str(Error_Dist),'m']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 计算两点距离子函数
function dist=getDist(A,B)
dist=sqrt( (A.x-B.x)^2+(A.y-B.y)^2 );
% 画圆子函数
function circle(x0,y0,r)
sita=0:pi/20:2*pi;
plot(x0+r*cos(sita),y0+r*sin(sita)); % 中心在(x0,y0），半径为r
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
