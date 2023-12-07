%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：数据分析程序
function DataAnalysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load Xstate;
load Zdist;
load Xpf;
% Xstate
% Zdist
% Xpf
T1=length(Xstate(1,:));
T2=length(Zdist(1,:));
T=min(T1,T2);
for k=1:T
    Dev_PF(1,k)=sqrt( (Xpf(1,k)-Xstate(1,k))^2+(Xpf(3,k)-Xstate(3,k))^2 );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure % 轨迹图
hold on;box on;
plot(Xstate(1,:),Xstate(3,:),'-b.');
plot(Xpf(1,:),Xpf(3,:),'-r+');
legend('true','pf');
xlabel('X/m');ylabel('Y/m');

figure % 偏差图
hold on;box on;
plot(Dev_PF,'-ko','MarkerFace','g');
xlabel('Time/s');ylabel('Value of the Deviation/m');
figure % 对速度的估计
subplot(121);hold on;box on;
plot(Xstate(2,:),'-k.')
plot(Xpf(2,:),'-r+');
axis([0 T 9 11]);
subplot(122);hold on;box on;
plot(Xstate(4,:),'-k.')
plot(Xpf(4,:),'-r+');
axis([0 T 9 11]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%