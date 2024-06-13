function WeightCentroidLocation % 加权质心算法
% 定位初始化
Length=100;  % 场地空间，单位：米
Width=100;   % 场地空间，单位：米
d=50;        % 目标离观测站50米以内都能探测到，反之则不能
Node_number=6;  % 观测站的个数
SNR=50;         %  信噪比，单位dB
for i=1:Node_number % 观测站的位置初始化，这里位置是随机给定的
    Node(i).x=Width*rand; 
    Node(i).y=Length*rand;
end
% 目标的真实位置，这里也随机给定
Target.x=Width*rand;
Target.y=Length*rand;
% 观测站探测目标
X=[]; W=[];  % 权值
for i=1:Node_number
    dd=getdist(Node(i),Target);
    Q=dd/(10^(SNR/20)); %根据信噪比公式，求噪声方差
    if dd<=d
        X=[X;Node(i).x,Node(i).y];
        W=[W,1/((dd+sqrt(Q)*randn)^2)];% 根据书中式（3-4）计算权值，信号衰减公式
    end
end
% 权值归一化
W=W./sum(W)
N=size(X,1);   % 探测到目标的观测站个数
sumx=0;sumy=0;
for i=1:N
    sumx=sumx+X(i,1)*W(i); 
    sumy=sumy+X(i,2)*W(i);
end
Est_Target.x=sumx;  % 目标估计位置x
Est_Target.y=sumy;  % 目标估计位置y
Error_Dist=getdist(Est_Target,Target)  % 目标真实位置与估计位置的偏差距离
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure % 画图
hold on;box on;axis([0 100 0 100]); % 输出图形的框架
for i=1:Node_number
    h1=plot(Node(i).x,Node(i).y,'ko','MarkerFace','g','MarkerSize',10);
    text(Node(i).x+2,Node(i).y,['Node ',num2str(i)]);
end
h2=plot(Target.x,Target.y,'k^','MarkerFace','b','MarkerSize',10);
h3=plot(Est_Target.x,Est_Target.y,'ks','MarkerFace','r','MarkerSize',10);
line([Target.x,Est_Target.x],[Target.y,Est_Target.y],'Color','k');
circle(Target.x,Target.y,d);
legend([h1,h2,h3],'Observation Station','Target Postion','Estimate Postion');
xlabel(['error=',num2str(Error_Dist),'m']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子函数，计算两点间的距离
function dist=getdist(A,B)
dist=sqrt( (A.x-B.x)^2+(A.y-B.y)^2 );
% 子函数， 以目标为中心画圆
function circle(x0,y0,r)
sita=0:pi/20:2*pi;
plot(x0+r*cos(sita),y0+r*sin(sita)); % 中心在(x0,y0），半径为r
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%