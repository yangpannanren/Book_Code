%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  函数功能：粒子滤波用于电源寿命预测
function main
% 初始化
% 运行程序时需要将 Battery Capacity.mat 文件复制到程序所在文件夹
load Battery_Capacity
N=length(A12Cycle); %cycle 的总数
M=200; %粒子总数
Future_Cycle=100; %未来趋势
if N>260
    N=260; %清除大于260的数字
end
cita=1e-4;
wa=0.000001;wb=0.01;wc=0.1;wd=0.0001;
Q=cita*diag([wa,wb,wc,wd]); %过程噪声协方差Q
% 驱动矩阵
F=eye(4);
% 观测噪声协方差
R=0.001;
% a,b,c,d赋初值
a=-0.0000083499;b=0.055237;c=0.90097;d=-0.00088543;
X0=[a,b,c,d]';
% 滤波器状态初始化
Xpf=zeros(4,N);
Xpf(:,1)=X0;
% 粒子集初始化
Xm=zeros(4,M,N);
for i=1:M
    Xm(:,i,1)=X0+sqrtm(Q)*randn(4,1);
end
% 观测量
Z(1,1:N)=A12Capacity(1:N,:)';
% 滤波器预测观测zm与x对应
Zm=zeros(1,M,N);
% 滤波器滤波后的观测zp£与Xp£对应
Zpf=zeros(1,N);
% 权值初始化
W=zeros(N,M);
% 粒子滤波算法
for k=2:N
    % 采样
    for i=1:M
        Xm(:,i,k)=F*Xm(:,i,k-1)+sqrtm(Q)*randn(4,1);
    end
    % 重要性权值计算
    for i=1:M
        % 观测预测
        Zm(1,i,k)=hfun(Xm(:,i,k),k);
        % 重要性权值
        W(k,i)=exp(-(Z(1,k)-Zm(1,i,k))^2/2/R)+1e-99;
    end
    % 归一化权值
    W(k,:)=W(k,:)./sum(W(k,:));
    % 重新采样
    outIndex = residualR(1:M,W(k,:)'); %可以选用其他的重采样算法，见第五章
    % 得到新的样本集
    Xm(:,:,k)=Xm(:,outIndex,k);
    % 滤波器滤波后的状态更新为：
    Xpf(:,k)=[mean(Xm(1,:,k));mean(Xm(2,:,k));mean(Xm(3,:,k));mean(Xm(4,:,k))];
    % 用更新后的状态计算Q(k)
    Zpf(1,k)=hfun(Xpf(:,k),k);
end
% 预测未来电容的趋势
% 这里只选择Xpf(:start)点的估计值，按道理是要对前期滤波得到的值做个整体处理的
% 由此导致预测不准确，后续的工作请好好处理Xp(:,1:start)，这个矩阵的数据，平滑
% 处理a，b,c,d然后代入方程预测未来，方能的到更好地效果
start=N-Future_Cycle;
for k=start:N
    Zf(1,k-start+1)=hfun(Xpf(:,start),k);
    Xf(1,k-start+1)=k;
end
Xreal=[a*ones(1,M);b*ones(1,M);c*ones(1,M);d*ones(1,M)];

figure
subplot(2,2,1);
hold on;box on;
plot(Xpf(1,:),'-r.');plot(Xreal(1,:),'-b.')
xlabel('cycle');ylabel('value');
legend('粒子滤波后的a','平均值a')
subplot(2,2,2);
hold on;box on;
plot(Xpf(2,:),'-r.');plot(Xreal(2,:),'-b.')
xlabel('cycle');ylabel('value');
legend('粒子滤波后的b','平均值b')
subplot(2,2,3);
hold on;box on;
plot(Xpf(3,:),'-r.');plot(Xreal(3,:),'-b.')
xlabel('cycle');ylabel('value');
legend('粒子滤波后的c','平均值c')
subplot(2,2,4);
hold on;box on;
plot(Xpf(4,:),'-r.');plot(Xreal(4,:),'-b.')
xlabel('cycle');ylabel('value');
legend('粒子滤波后的d','平均值d')
sgtitle('滤波估计的4个状态参数');
figure
hold on;box on;
h1=plot(Z,'-b.');
h2=plot(Zpf,'-r.');
h3=plot(Xf,Zf,'-g.');
xlabel('cycle');ylabel('capacity');
bar(start,1,'y','DisplayName','none');
legend([h1,h2,h3],'实验测量数据','滤波估计数据','自然预测数据');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%