%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序功能：双站观测目标定位程序
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DoubleStationEstimate
% 第一步：定位初始化
Length=100;  % 场地空间，单位：米
Width=100;   % 场地空间，单位：米
Node_number=2; % 两个观测站
Q=5e-4; % 角度观测方差
% 两个观测站之间的距离
dd=20;
Node(1).x=0;Node(1).y=0;
Node(2).x=dd;Node(2).y=0;
% 目标的真实位置，这里随机给定
Target.x=Width*rand;
Target.y=Length*rand;
% 第二步：各观测站对目标探测角度
Z=[];
for i=1:Node_number
    % 获取观测角度
    Z(i)=atan2(Target.y-Node(i).y,Target.x-Node(i).x);
    % 叠加上噪声，才是实际情况
    Z(i)=Z(i)+sqrt(Q)*randn;
end
% 第三步：根据观测角度，用最小二乘法计算目标估计位置
H=[tan(Z(1)),-1;tan(Z(2)),-1];
b=[0,dd*tan(Z(2))]';
Estimate=inv(H'*H)*H'*b;  % 目标的估计位置
Est_Target.x=Estimate(1);Est_Target.y=Estimate(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图
figure
hold on;box on;axis([0 120 0 120]); % 输出图形的框架
for i=1:Node_number
    h1=plot(Node(i).x,Node(i).y,'ko','MarkerFace','g','MarkerSize',10);
    text(Node(i).x+2,Node(i).y,['Node ',num2str(i)]);
end
h2=plot(Target.x,Target.y,'k^','MarkerFace','b','MarkerSize',10);
h3=plot(Est_Target.x,Est_Target.y,'ks','MarkerFace','r','MarkerSize',10);
line([Target.x,Est_Target.x],[Target.y,Est_Target.y],'Color','k');
legend([h1,h2,h3],'Observation Station','Target Postion','Estimate Postion');
[Error_Dist]=DIST(Est_Target,Target);
xlabel(['error=',num2str(Error_Dist),'m']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子函数，计算两点间的距离
function [dist]=DIST(A,B)
dist=sqrt((A.x-B.x)^2+(A.y-B.y)^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
