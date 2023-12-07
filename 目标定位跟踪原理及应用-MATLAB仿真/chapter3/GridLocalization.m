%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序功能：网格定位算法程序
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GridLocalization
Length=100;  % 场地空间，单位：米
Width=100;   % 场地空间，单位：米
Xnum=5;      % 观测站在水平方向的个数
Ynum=5;      % 观测站在垂直方向的个数
divX=Length/Xnum/2;divY=Width/Ynum/2; %  为了正中间查看观测站分布调节量
d=50;        % 目标离观测站20米以内都能探测到，反之则不能
% 目标随机出现在场地中
Target.x=Width*(Xnum-1)/Xnum*rand;
Target.y=Length*(Ynum-1)/Ynum*rand;
DIST=[]; % 放置观测站与目标之间距离的集合
for j=1:Ynum % 观测站的网格部署
for i=1:Xnum
        Station((j-1)*Xnum+i).x=(i-1)*Length/Xnum;
        Station((j-1)*Xnum+i).y=(j-1)*Width/Ynum;
        dd=getdist(Station((j-1)*Xnum+i),Target);
        DIST=[DIST dd];
    end
end
% 找出探测到目标信号最强的3个观测站，也就是离目标最近的观测站
[set,index]=sort(DIST);  % set为排列好的从小到大的数值集合，index为索引集合
NI=index(1:3); % 最近的3个，即index1-3个元素
Est_Target.x=0;Est_Target.y=0;
if set(NI(3))<d % 检查3个中最大那个数是否在观测站可探测距离范围之内
    for i=1:3
        Est_Target.x=Est_Target.x+Station(NI(i)).x/3;
        Est_Target.y=Est_Target.y+Station(NI(i)).y/3;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure % 画图
hold on;box on;axis([0-divX,Length-divX,0-divY,Width-divX])
xx=[Station(NI(1)).x,Station(NI(2)).x,Station(NI(3)).x];
yy=[Station(NI(1)).y,Station(NI(2)).y,Station(NI(3)).y];
fill(xx,yy,'y');
for j=1:Ynum
    for i=1:Xnum
        h1=plot(Station((j-1)*Xnum+i).x,Station((j-1)*Xnum+i).y,'-ko','MarkerFace','g');
        text(Station((j-1)*Xnum+i).x+1,Station((j-1)*Xnum+i).y,num2str((j-1)*Xnum+i));
    end
end
Error_Est=getdist(Est_Target,Target)
h2=plot(Target.x,Target.y,'k^','MarkerFace','b','MarkerSize',10);
h3=plot(Est_Target.x,Est_Target.y,'ks','MarkerFace','r','MarkerSize',10);
legend([h1,h2,h3],'Observation Station','Target Postion','Estimate Postion');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子函数，计算两点间的距离
function dist=getdist(A,B)
dist=sqrt( (A.x-B.x)^2+(A.y-B.y)^2 );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

