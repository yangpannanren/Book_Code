function CentroidLocalization        %质心定位算法
%定位初始化
Length=100;                          %场地空间，单位：米
Width=100;                           %场地空间，单位：米
d=50;                                %观测站探测能力50m
N=6;                                 %观测站的个数
for i=1:N                            %观测站的位置初始化
    Node(i).x=Width*rand;
    Node(i).y=Length*rand;
end
%目标的真实位置，这里也随机给出
Target.x=Width*rand;
Target.y=Length*rand;
X=[ ];                               %用于保存探测到目标的探测站的位置
for i=1:N
    if getDist(Node(i),Target)<=d    %调用距离子函数，getDist()函数必须写在另一个m文件中，见末尾
        X=[X;Node(i).x, Node(i).y];  %保存探测到目标的探测站的位置
    end
end
M=size(X,1);                         %探测到目标的观测站个数
if M>0
    Est_Target.x=sum(X(:,1))/M;      %质心的估计位置x
    Est_Target.y=sum(X(:,2))/M;      %质心的估计位置y
    Error_Dist=getDist(Est_Target,Target)     %质心估计值与实际值的误差
end
%开始画图
figure
hold on;box on;axis([0 100 0 100]);
for i=1:N
    h1=plot(Node(i).x,Node(i).y,'ko','MarkerFace','g','MarkerSize',10);
    text(Node(i).x+2,Node(i).y,['Node ',num2str(i)]);
end
%画目标的真实位置和估计位置
h2=plot(Target.x,Target.y,'k^','MarkerFace','b','MarkerSize',10);   %画出真实位置
h3=plot(Est_Target.x,Est_Target.y,'ks','MarkerFace','r','MarkerSize',10);   %画出估计位置
%将目标的真实位置和估计位置用线连起来
line ([Target.x,Est_Target.x],[Target.y,Est_Target.y],'Color','k');
%画出目标周围，以探测能力50m为半径的圆形d范围；circle()函数写在circle.m文件中
circle(Target.x,Target.y,d);
%表明h1,h2,h3是什么
legend([h1,h2,h3],'Observation Station','Target Postion','Estimate Postion');
xlabel(['error=',num2str(Error_Dist),'m']);

%计算两点距离函数，必须写在另一个m文件中
function dist=getDist(A,B)
dist=sqrt((A.x-B.x)^2+(A.y-B.y)^2);


%画圆函数，必须写在另一个m文件中
function circle(x0,y0,r)
sita=0:pi/20:2*pi;
plot (x0+r*cos(sita),y0+r*sin(sita));