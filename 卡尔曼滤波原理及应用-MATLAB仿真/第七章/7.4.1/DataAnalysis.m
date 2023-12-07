%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵�������ݷ�������
%  ��ϸԭ����ܼ�����ע����ο���
%  ���������˲�ԭ��Ӧ��-MATLAB���桷�����ӹ�ҵ�����磬��Сƽ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DataAnalysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load Xstate;
load Zdist;
load Xekf;
load Xukf;
T1=length(Xstate(1,:));
T2=length(Zdist(1,:));
T=min(T1,T2);
for k=1:T
    Dev_EKF(1,k)=sqrt( (Xekf(1,k)-Xstate(1,k))^2+(Xekf(2,k)-Xstate(2,k))^2 );
    Dev_UKF(1,k)=sqrt( (Xukf(1,k)-Xstate(1,k))^2+(Xukf(2,k)-Xstate(2,k))^2 );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on;box on;
plot(Xstate(1,:),Xstate(2,:),'-b.');
plot(Xekf(1,:),Xekf(2,:),'-r+');
plot(Xukf(1,:),Xukf(2,:),'-rx');
legend('true','ekf','ukf');
xlabel('X/m');ylabel('Y/m');

figure
hold on;box on;
plot(Dev_EKF,'-ks','MarkerFace','g');
plot(Dev_UKF,'-ko','MarkerFace','r');
xlabel('Time/s');ylabel('Value of the Deviation/m');
legend('ekf','ukf');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%