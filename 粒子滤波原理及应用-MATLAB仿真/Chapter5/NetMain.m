%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 粒子集合半径问题
function NetMain
% 以平面中某个点，例如(5，5)为中心，画一个大圆和一个小圆
x0=5;
y0=5;
r1=2;
r2=4;
Net=4; %粒子集合的采样半径
N=50; %粒子数
for i=1:N
    X(i)=x0+sqrt(Net)*randn;
    Y(i)=y0+sqrt(Net)*randn;
end
% 画图
figure
hold on;box on;
% 画采样点
plot(X,Y,'k+');
% 画圆心
plot(x0,y0,'ko','MarkerFaceColor','g')
% 画大小两个圆
sita=0:pi/20:2*pi;
plot(x0+r1*cos(sita),y0+r1*sin(sita),'Color','r','LineWidth',5);
plot(x0+r2*cos(sita),y0+r2*sin(sita),'Color','b','LineWidth',5);
axis([0,10,0,10]);
title(['粒子网半径Net=',num2str(Net)]);
% 画直方图
figure
support=-10:1:20;
[range,domain]=hist(X,support); %X轴粒子分布情况
subplot(121)
plot(domain,range,'r-');
xlabel('X样本域')
ylabel('密度')
subplot(122)
[range,domain]=hist(Y,support); %Y轴粒子分布情况
plot(domain,range,'b-');
xlabel('Y样本域')
ylabel('密度')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%