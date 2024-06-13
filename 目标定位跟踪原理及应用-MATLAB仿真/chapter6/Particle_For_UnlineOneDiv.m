%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：粒子濾波在一維系統中的应用
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Particle_For_UnlineOneDiv
rng(1);
% 初始化相关参数
N =50;                 % 采样点数
T=1;                   % 采样周期
Q=10;                  % 过程噪声方差
R=1;                   % 测量噪声方差
v=sqrt(R)*randn(N,1);  % 测量噪声
w=sqrt(Q)*randn(N,1);  % 过程噪声
numSamples=100;        % 粒子数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x0=0.1;                % 初始状态
%产生真实状态和观测值
X=zeros(N,1);          % 真实状态
Z=zeros(N,1);          % 量测
X(1,1)=x0;             % 真实状态初始化
Z(1,1)=(X(1,1)^2)./20 + v(1,1); % 观测值初始化
for k=2:N
    X(k,1)=0.5*X(k-1,1) + 2.5*X(k-1,1)/(1+X(k-1,1)^(2))...
        + 8*cos(1.2*k)+ w(k-1,1);           % 状态方程
    Z(k,1)=(X(k,1).^(2))./20 + v(k,1);  % 观测方程
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 粒子滤波
Xpf=zeros(numSamples,N);        % 粒子滤波估计状态
Xparticles=zeros(numSamples,N); % 粒子集合
Zpre_pf=zeros(numSamples,N);    % 粒子滤波观测预测值
weight=zeros(numSamples,N);     % 权重初始化
% 初始采样:
Xpf(:,1)=x0+sqrt(Q)*randn(numSamples,1);
Zpre_pf(:,1)=Xpf(:,1).^2/20;
% 更新与预测过程:
for k=2:N
    % 第一步：粒子集合采样过程
    for i=1:numSamples
        QQ=Q;    % 跟kalman滤波不同，这里的Q不要求与过程噪声方差一致
        net=sqrt(QQ)*randn; % 这里的QQ可以看成是“网”的半径，数值上可以调节
        Xparticles(i,k)=0.5.*Xpf(i,k-1) + 2.5.*Xpf(i,k-1)./(1+Xpf(i,k-1).^2)...
            + 8*cos(1.2*k) + net;
    end
    % 第二步：对粒子集合中的每个粒子，计算其重要性权值
    for i=1:numSamples
        Zpre_pf(i,k)=Xparticles(i,k)^2/20;
        weight(i,k)=exp(-.5*R^(-1)*(Z(k,1)- Zpre_pf(i,k))^2);%省略了常数项
    end
    weight(:,k)=weight(:,k)./sum(weight(:,k));%归一化权值
    % 第三步：根据权值大小对粒子集合重采样，权值集合和粒子集合是一一对应的
    outIndex = randomR(weight(:,k)'); % 请参考6.4节，该函数的实现过程
    % 第四步：根据重采样得到的索引，去挑选对应的粒子，重构的集合便是滤波后的状态集合
    % 对这个状态集合求均值，就是最终的目标状态，见下文求均值部分
    Xpf(:,k)= Xparticles(outIndex,k);
end
% 计算后验均值估计、最大后验估计及估计方差:
Xmean_pf=mean(Xpf); % 后验均值估计，即上面的第四步，也即粒子滤波估计的最终状态
bins=20;
Xmap_pf=zeros(N,1);
for k=1:N
    [p,pos]=hist(Xpf(:,k,1),bins);
    map=find(p==max(p));
    Xmap_pf(k,1)=pos(map(1));% 最大后验估计
end
for k=1:N
    Xstd_pf(1,k)=std(Xpf(:,k)-X(k,1));%后验误差标准差估计
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图
figure % 过程噪声和测量噪声--图
subplot(221);
plot(v);   % 测量噪声
xlabel('Time');ylabel('Measurement Noise');
subplot(222);
plot(w);   % 过程噪声
xlabel('Time');ylabel('Process Noise');
subplot(223);
plot(X);   % 真实状态
xlabel('Time');ylabel('State X');
subplot(224);
plot(Z);   % 传感器测量值，观测值
xlabel('Time');ylabel('Observation Z');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure % 状态估计图（轨迹图）
k=1:T:N;
plot(k,X,'b',k,Xmean_pf,'r',k,Xmap_pf,'g'); % 注：Xmean_pf就是粒子滤波结果
legend('True value','Posterior mean estimate','MAP estimate');
xlabel('Time');ylabel('State estimate');
title('状态估计图(轨迹图)');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(121);
plot(Xmean_pf,X,'+'); % 粒子滤波估计值与真实状态值如成1：1关系，则会对称分布
xlabel('Posterior mean estimate');
ylabel('True state')
hold on;
c=-25:1:25;
plot(c,c,'r'); % 画红色的对称线y=x
axis([-25 25 -25 25]);
hold off;
subplot(122);  % 最大后验估计值与真实状态值如成1：1关系，则会对称分布
plot(Xmap_pf,X,'+')
ylabel('True state')
xlabel('MAP estimate')
hold on;
c=-25:1:25;
plot(c,c,'r'); % 画红色的对称线y=x
axis([-25 25 -25 25]);
hold off;
sgtitle('估计值与真实值的关系');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画直方图，此图形是为了看在粒子集的后验密度
domain=zeros(numSamples,1);
range=zeros(numSamples,1);
bins=10;
support=-20:1:20;
figure % 直方图
hold on;
xlabel('Sample space');ylabel('Time');
zlabel('Posterior density');
vect=[0 1];
clim(vect);
for k=1:N
    % 直方图反映滤波后的粒子集合的分布情况
    [range,domain]=hist(Xpf(:,k),support);
    % 调用waterfall函数，将直方图分布的数据画出来
    waterfall(domain,k,range);
end
view(3)
title('各时刻粒子密度分布')
axis([-20 20 0 N 0 100]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on; box on;
xlabel('Sample space');ylabel('Posterior density');% 后验密度，可理解为分布
k=30;   % k=# 表示要查看第几个时刻的粒子分布(密度)与真实状态值的重叠关系
[range,domain]=hist(Xpf(:,k),support);
plot(domain,range);
XXX=[X(k,1),X(k,1)];
YYY=[0,max(range)+10];
line(XXX,YYY,'Color','r');
title(['k=',num2str(k),'时刻粒子密度分布'])
axis([min(domain) max(domain) 0 max(range)+10]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure %  估计方差图
k=1:T:N;
plot(k,Xstd_pf,'-');s
xlabel('时间(t/s)');ylabel('状态估计误差标准差');
title('噪声对滤波估计误差的影响')
axis([0,N,0,10]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 随机重采样子函数
function outIndex = randomR(W)
% 参数说明：W是输入的需要被随机采样的数组，是1×N数组
% outIndex是输入数组W的重采样后的索引，即 V=W(outIndex)
% V就是根据索引，从W数组元素抽取元素组成的集合，是重采样的结果
N=length(W);          % 得到输入W的维数
outIndex=zeros(1,N); %  初始化
% 产生随机分布伪随机数
u=rand(1,N);  % 对照书中6.4.1节随机重采样，算法步骤（1）
u=sort(u);    % 对照书中6.4.1节随机重采样，算法步骤（2）
CS=cumsum(W); % 对W求累加和
i=1;
for j=1:N
    while ( i<=N ) & ( u(i)<=CS(j) )
        outIndex(i)=j; % 将W数组索引放在outIndex中
        i=i+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%