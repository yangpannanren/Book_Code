function ErChengFa3d
%定位初始化
Length=100;                    %场地空间,单位:米
Width=100;                     %场地空间,单位:米
Hight=100;
Node_number=5;               %观测站的个数,也可以设置成6个或7个等,但是最少必须有4个
R=5;                            %观测站测量噪声方差
for i=1: Node_number            %观测站的位置初始化，这里位置是随机给定的
    %此处不考虑观测站在同一平面的情况,若在同-一个平面,可先估计出x,y,再算出z
    Node(i).x= Width*rand;
    Node(i).y= Length*rand;
    Node(i).z= Hight*rand;
    Node(i).D= Node(i).x^2+Node(i).y^2+Node(i).z^2; % 固定参数便于位置估计
end
%目标的真实位置,这里也随机给定
Target.x= Width*rand;
Target.y= Length*rand;
Target.z= Hight*rand; 
%观测站探测目标
X=[];                            %基站(观测站)的位置集合
Z=[];                            %测量距离
for i=1:Node_number
    [d1,d2]= DIST(Node(i),Target);%观测站离目标的真实距离
    d1=d1+sqrt(R)*randn;        %假设测量距离受到均值为5的高斯白噪声的污染
    X=[X;Node(i).x,Node(i).y,Node(i).z];
    Z=[Z,d1];
end
H=[];b=[];
for i=2:Node_number
    H=[H;2*(X(i,1)-X(1,1)),2*(X(i,2)-X(1,2)),2*(X(i,3)-X(1,3))];
    b=[b;Z(1)^2-Z(i)^2+Node(i).D-Node(1).D];
end
Estimate=inv(H'*H) *H'*b;           %目标的估计位置
Est_Target.x= Estimate(1);Est_Target.y= Estimate(2);Est_Target.z= Estimate(3); 
%开始画图
figure
hold on;box on;axis([0 Width 0 Length 0 Hight]); % 输出图形的框架
for i= 1:Node_number
    h1=plot3(Node(i).x,Node(i).y,Node(i).z,'ko','MarkerFace','g');
    text(Node(i).x+2,Node(i).y,Node(i).z,[ 'Node',num2str(i)]);
end
h2=plot3(Target.x,Target.y ,Target.z,'k^','MarkerFace','b');
h3=plot3(Est_Target.x,Est_Target.y,Est_Target.z,'ks','MarkerFace','r');
legend([h1,h2,h3],'Observation Station','Target Postion','Estimate Postion');
[Error_Dist,d2]=DIST(Est_Target,Target);
title(['error=',num2str( Error_Dist),'m']);
axis square;view(3);grid on;

%子函数,计算两点间的距离
function [dist,dist2]= DIST(A,B)
dist2=(A.x-B.x)^2+(A.y-B.y)^2+(A.z-B.z)^2;
dist=sqrt(dist2);