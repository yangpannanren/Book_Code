%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 基本粒子滤波的一维系统仿真实例
% 状态方程：x(k)=0.5x(k-1)+2.5x(k-1)/(1+x(k-1)^2)+8cos(1.2k) + w(k)
% 观测方程：z(k)=x(k)^2/20 + v(k)
function Particle_For_UnlineOneDiv
rng(1);
% 初始化相关参数
T=50; %采样点数
dt=1; %采样周期
Q=10; %过程噪声方差
R=1;  %测量噪声方差
v=sqrt(R)*randn(T,1); %测量噪声
w=sqrt(Q)*randn(T,1); %过程噪声
numSamples=100;       %粒子数
ResampleStrategy=2;   %=1为随机采样，=2为系统采样。。。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x0=0.1; %初始状态
% 产生真实状态和观测值
X=zeros(T,1); %真实状态
Z=zeros(T,1); %测量
X(1,1)=x0;    %真实状态初始化
Z(1,1)=(X(1,1)^2)./20 + v(1,1); %观测值初始化
for k=2:T
    % 状态方程
    X(k,1)=0.5*X(k-1,1) + 2.5*X(k-1,1)/(1+X(k-1,1)^(2))...
        + 8*cos(1.2*k)+ w(k-1,1);
    % 观测方程
    Z(k,1)=(X(k,1).^(2))./20 + v(k,1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 粒子滤波器初始化，需要设置用于存放滤波估计状态，粒子集合，权重等数组
Xpf=zeros(numSamples,T);            %粒子滤波估计状态
Xparticles=zeros(numSamples,T);     %粒子集合
Zpre_pf=zeros(numSamples,T);        %粒子滤波观测预测值
weight=zeros(numSamples,T);         %权重初始化
% 给定状态和观测预测的初始采样:
Xpf(:,1)=x0+sqrt(Q)*randn(numSamples,1);
Zpre_pf(:,1)=Xpf(:,1).^2/20;
% 更新与预测过程:
for k=2:T
    % 第一步:粒子集合采样过程
    for i=1:numSamples
        QQ=Q; %跟kalman滤波不同，这里的Q不要求与过程噪声方差一致
        net=sqrt(QQ)*randn; %这里的QQ可以看成是“网”的半径，数值上可以调节
        Xparticles(i,k)=0.5.*Xpf(i,k-1) + 2.5.*Xpf(i,k-1)./...
            (1+Xpf(i,k-1).^2) + 8*cos(1.2*k) + net;
    end
    % 第二步:对粒子集合中的每个粒子，计算其重要性权值
    for i=1:numSamples
        Zpre_pf(i,k)=Xparticles(i,k)^2/20;
        weight(i,k)=exp(-.5*R^(-1)*(Z(k,1)- Zpre_pf(i,k))^2); %省略了常数项
    end
    weight(:,k)=weight(:,k)./sum(weight(:,k)); %归一化权值
    % 第三步:根据权值大小对粒子集合重采样，权值集合和粒子集合是一一对应的
    % 选择采样策略
    switch ResampleStrategy
        case 1
            outIndex = randomR(weight(:,k));
        case 2
            outIndex = residualR(weight(:,k)');
        case 3
            outIndex = systematicR(weight(:,k)');
        case 4
            outIndex = multinomialR(weight(:,k));
        otherwise
            error('ResampleStrategy is wrong!')
    end
    % 第四步:根据重采样得到的索引，去挑选对应的粒子，重构的集合便是滤波后
    % 的状态集合对这个状态集合求均值，就是最终的目标状态，见下文求均值部分
    Xpf(:,k)= Xparticles(outIndex,k);
end
% 计算后验均值估计、最大后验估计及估计方差:
Xmean_pf=mean(Xpf); %后验均值估计，即上面的第四步，也即粒子滤波估计的最终状态
bins=20;
Xmap_pf=zeros(T,1);
for k=1:T
    [p,pos]=hist(Xpf(:,k,1),bins);
    map=find(p==max(p));
    Xmap_pf(k,1)=pos(map(1)); %最大后验估计
end
for k=1:T
    Xstd_pf(1,k)=std(Xpf(:,k)-X(k,1)); %后验误差标准差估计
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图
figure(1);clf; %过程噪声和测量噪声--图
subplot(221);
plot(v); %测量噪声
xlabel('时间');
ylabel('测量噪声');
subplot(222);
plot(w); %过程噪声
xlabel('时间');
ylabel('过程噪声');
subplot(223);
plot(X); %真实状态
xlabel('时间');
ylabel('状态X');
subplot(224);
plot(Z); %传感器测量值，观测值
xlabel('时间');
ylabel('观测Z');
% 状态估计图（轨迹图）
figure(2);clf; 
k=1:dt:T;
plot(k,X,'b',k,Xmean_pf,'r',k,Xmap_pf,'g'); %注:Xmean_pf就是粒子滤波结果
legend('系统真实状态值','后验均值估计','最大后验概率估计');
xlabel('时间');
ylabel('状态估计');
title(sprintf('非线性条件下基于粒子滤波的仿真曲线Q=%d,R=%d',Q,R));
% 粒子滤波估计值与真实状态值
figure(3);clf;
subplot(121);
plot(Xmean_pf,X,'+'); %粒子滤波估计值与真实状态值如成1:1关系，则会对称分布
xlabel('后验均值估计');
ylabel('真值')
hold on;
c=-25:1:25;
plot(c,c,'r'); %画红色的对称线 y=x
axis([-25 25 -25 25]);
hold off;
subplot(122); %最大后验估计值与真实状态值如成1:1关系，则会对称分布
plot(Xmap_pf,X,'+')
ylabel('真值')
xlabel('MAP估计')
hold on;
c=-25:1:25;
plot(c,c,'r'); %画红色的对称线 y=x
axis([-25 25 -25 25]);
hold off;
sgtitle('估计与真值的关系');
% 画直方图，此图形是为了看粒子集的后验密度
domain=zeros(numSamples,1);
range=zeros(numSamples,1);
% bins=10;
support=-20:1:20;
% 直方图
figure(4);clf; 
hold on;
xlabel('样本空间');
ylabel('时间');
zlabel('后验密度');
vect=[0 1];
clim(vect);
for k=1:T
    % 直方图反映滤波后的粒子集合的分布情况
    [range,domain]=hist(Xpf(:,k),support);
    % 调用waterfal1函数，将直方图分布的数据画出来
    waterfall(domain,k,range);
end
axis([-20 20 0 T 0 100]);
view(3)
% 后验密度图
figure(5);clf;
hold on; box on;
xlabel('样本空间');
ylabel('后验密度'); %后验密度，可理解为分布
k=30; %k=?表示要查看第几个时刻的粒子分布(密度)与真实状态值的重叠关系
[range,domain]=hist(Xpf(:,k),support);
plot(domain,range);
% 真实状态在样本空间中的位置，画一条红色直线表示
XXX=[X(k,1),X(k,1)];
YYY=[0,max(range)+10];
line(XXX,YYY,'Color','r');
axis([min(domain) max(domain) 0 max(range)+10]);
title(sprintf('k=%d时刻粒子密度分布直方图',k))
% 估计方差图
figure(6);clf;
k=1:dt:T;
plot(k,Xstd_pf,'-');
xlabel('时间（t/s）');ylabel('状态估计误差标准差');
axis([0,T,0,10]);
title('偏差曲线')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%