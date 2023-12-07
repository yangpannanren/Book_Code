%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序功能：RSSI定位算法程序
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RssiEstimate
% 第一步：定位初始化
Length=100;  % 场地空间，单位：米
Width=100;   % 场地空间，单位：米
Node_number=3;  % 观测站的个数，最少必须要3个
for i=1:Node_number % 观测站的位置初始化，这里位置是随机给定的
    Node(i).x=Width*rand; 
    Node(i).y=Length*rand;
    Node(i).D=Node(i).x^2+Node(i).y^2;  % 固定参数便于位置估计
end
% 目标的真实位置，这里也随机给定
Target.x=Width*rand;
Target.y=Length*rand;
% 第二步：各观测站对目标探测10次，最后以平均值作为最终RSSI值
Z=[];   %  各观测站采集10次RSSI
for i=1:Node_number
    for t=1:10 % 10次采样
        [d]=DIST(Node(i),Target);  % 观测站离目标的真实距离
        % 距离为d时，得到的RSSI测量值
        Z(i,t)=GetRssiValue(d)
    end
end
%  求10次观测的平均值
ZZ=[];
for i=1:Node_number
    ZZ(i)=sum(Z(i,:))/10;
end
% 第三步：根据采样的RSSI值，求观测距离
Zd=[]; % 根据RSSI计算得到的距离
for i=1:Node_number
    Zd(i)=GetDistByRssi(ZZ(i));
end
% 第四步：根据观测距离，用最小二乘法计算目标估计位置
H=[];
b=[];
for i=2:Node_number
    %  参照公式三边测距法公式
    H=[H;2*(Node(i).x-Node(1).x),2*(Node(i).y-Node(1).y)];  
    b=[b;Zd(1)^2-Zd(i)^2+Node(i).D-Node(1).D];  
end
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
% 子函数，观测距离为d时，采样得到RSSI
function value=GetRssiValue(d)
% 当距离为d时，仿真系统给出一个与实际距离相对应的仿真值
A=-42;  % 注意A和n在不同硬件系统取值是不一样的
n=2;
value=A-10*n*log10(d);
% 实际测量值是受到噪声的污染的，这里假定噪声方差Q非常大
% 因为RSSI的干扰是非常大
Q=5;
value=value+sqrt(Q)*randn; % 实际观测量是带有噪声的，仿真就是在模仿真实情况
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子函数，根据RSSI计算得到距离d
function value=GetDistByRssi(rssi)
A=-42;  % 注意A和n在不同硬件系统取值是不一样的
n=2;
value=10^((A-rssi)/10/n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
