%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 函数功能：EKF和UKF算法用于电池寿命预测
% ukf_battery函数有bug。。。。。。。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ukf_ekf_compair_battery
load Battery_Capacity
N = length(A12Cycle); %cycle的总数，即电池测量数据的样本数目
% 我们选用A12Cycle这组数据中的前N个，用于对参数a、b、c、d的参数识别
% 然后选用N之后的100个样本数据用于预测测试，可修改
if N>265
    N=265;
end
Future_Cycle=100; %预测未来趋势，选用的样本数
%过程噪声协方差Q
cita=1e-4;
wa=0.000001;wb=0.01;wc=0.1;wd=0.0001;
Q=cita*diag([wa,wb,wc,wd]);
%观测噪声协方差
R=0.001;
%驱动矩阵
F=eye(4);
%观测矩阵H需要动态求解
% a、b、c、d赋初值
a=-0.0000083499;b=0.055237;c=0.90097;d=-0.00088543;
X0=[a,b,c,d]';
Pekf=eye(4); %协方差初始化
Pukf=eye(4); %协方差初始化
% 滤波器状态初始化
Xekf=zeros(4,N);
Xekf(:,1)=X0;
Xukf=zeros(4,N);
Xukf(:,1)=X0;
% 观测量
Z(1:N)=A12Capacity(1:N,:)';
Zekf=zeros(1,N);
Zekf(1)=Z(1);
Zukf=zeros(1,N);
Zukf(1)=Z(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 扩展Kalman滤波算法
for k=2:N
    % 调用EKF算法
    [Xekf(:,k),Pekf]=ekf_battery(Xekf(:,k-1),Z(k),k,Q,R,Pekf);
    % 根据滤波后的状态，计算观测
    Zekf(:,k)=hfun(Xekf(:,k),k);
    % 调用UKF算法
    [Xukf(:,k),Pukf]=ukf_battery(Xukf(:,k-1),Z(k),k,Q,R,Pukf);
    % 根据滤波后的状态，计算观测
    Zukf(:,k)=hfun(Xukf(:,k),k);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 预测未来电容的趋势
% 这里只选择Xekf(:,start)点的估计值，理论上还是要对前期滤波得到的这个值做个整体的处理
% 由此导致预测不准，后续的工作可以好好处理Xekf(:,start)，这个矩阵的数据，
% 平滑处理a、b、c、d，然后带入方程预测电池寿命的趋势
start=N-Future_Cycle;
for k=start:N
    ZQ_predict(1,k-start+1)=hfun(Xekf(:,start),k);
    XQ_predict(1,k-start+1)=k;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图
figure
hold on;box on;
plot(Z,'-b.') %实验数据，实际测量数据
plot(Zekf,'-r.') %滤波器滤波后的数据
plot(Zukf,'-g.') %滤波器滤波后的数据
% plot(XQ_predict,ZQ_predict,'-g.'); %预测的电容
bar(start,1,'y');
legend('测量数据','EKF滤波','UKF滤波');