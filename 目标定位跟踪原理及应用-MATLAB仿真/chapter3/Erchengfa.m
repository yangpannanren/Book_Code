function Erchengfa
%定位初始化
Length=100;                          %场地空间，单位：米
Width=100;                           %场地空间，单位：米
Node_number=5;                       %观测站的个数
for i= 1:Node_number                 %观测站的位置初始化，这里位置是随机给定的
    Node(i).x= Width * rand;
    Node(i).y= Length * rand;
    Node(i).D= Node(i).x^2+Node(i).y^2; % 固定参数便于位置估计
end
%目标的真实位置，这里也随机给定
Target.x=Width * rand;
Target.y=Length * rand;
%观测站探测目标
X=[];
Z=[];                                 %测量距离
for i=1:Node_number
    [d1,d2]=DIST(Node(i),Target);     %观测站离目标的真实距离
    d1=d1+sqrt(5)*randn;              %假设测量距离受到均值为5的高斯白噪声的污染
    X=[X;Node(i).x,Node(i).y];
    Z=[Z,d1];
end
H=[];b=[];
for i=2:Node_number
    H=[H;2*(X(i,1)-X(1,1)),2*(X(i,2)-X(1,2))];
    b=[b;Z(1)^2-Z(i)^2+Node(i).D-Node(1).D];
end
Estimate=inv(H'*H) *H'*b;             %目标的估计位置
Est_Target.x = Estimate(1);Est_Target.y = Estimate(2);

%画图
figure
hold on;box on;axis([0 100 0 100]);     % 输出图形的框架
for i=1: Node_number
    h1= plot(Node(i).x, Node(i).y,'ko','MarkerFace','g','MarkerSize',10);
    text(Node(i).x+2,Node(i).y,[ 'Node ', num2str(i)]);
end
h2= plot(Target.x,Target.y,'k^','MarkerFace','b','MarkerSize', 10) ;
h3= plot(Est_Target.x,Est_Target.y,'ks','MarkerFace','r','MarkerSize',10);
line([Target.x,Est_Target.x],[Target.y,Est_Target.y] ,'Color' ,'k');
legend([h1,h2,h3 ],'Observation Station', 'Target Postion','Estimate Postion');
[Error_Dist,d2]= DIST( Est_Target,Target);
xlabel(['error=',num2str( Error_Dist),'m']);

%计算两点间距离
function [dist,dist2]=DIST(A,B)
dist2=(A.x-B.x)^2+(A.y-B.y)^2;
dist=sqrt(dist2);
