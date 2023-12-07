%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵���������˲����ڸ�˹ģ���������˲�
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main
% ��ʼ������
randn('seed',4);
rand('seed',7);
T=1;   % ��������
M=30;  % ��������
delta_w=1e-4; % ���������������������Խ��Ŀ�����еĻ�����Խ�󣬹켣Խ������ң�
Q=delta_w*diag([0.5,1,0.5,1]) ; % ��������������
R=0.25;                            % �۲���������
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];
Length=100;    % Ŀ���˶��ĳ��ؿռ�
Width=100;
% �۲�վ��λ���漴����
Station.x=Width*rand;
Station.y=Length*rand;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ŀ����˶��켣
X=zeros(4,M); % Ŀ��״̬
Z=zeros(1,M); % �۲�����
w=randn(4,M); % ��������
v=randn(1,M); % �۲�����
X(:,1)=[1,Length/M,20,60/M]'; % ��ʼ��Ŀ��״̬�����߿������ó�����ֵ
state0=X(:,1)+w(:,1);         % ���Ƶĳ�ʼ��
for t=2:M
    X(:,t)=F*X(:,t-1)+sqrtm(Q)*w(:,t);%Ŀ����ʵ�켣
end
%  ģ��Ŀ���˶����̣��۲�վ��Ŀ��۲��ȡ��������
for t=1:M
    Z(1,t)=feval('hfun',X(:,t),Station)+sqrtm(R)*v(1,t);
end
% ���ں������ã����������
canshu.T=T;canshu.M=M;canshu.Q=Q;canshu.R=R;canshu.F=F;canshu.state0=state0;
%  �˲�
[Xpf,Tpf]=PF(Z,Station,canshu);
%  RMS�Ƚ�ͼ
for t=1:M
    PFrms(1,t)=distance(X(:,t),Xpf(:,t));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ��ͼ
figure;hold on;box on  % �켣ͼ
h1=plot(Station.x,Station.y,'ro','MarkerFaceColor','b'); % �۲�վλ��
h2=plot(X(1,:),X(3,:),'--m.','MarkerEdgeColor','m'); % Ŀ����ʵ�켣
% �˲��㷨�켣
h3=plot(Xpf(1,:),Xpf(3,:),'-k*','MarkerEdgeColor','b');
xlabel('X/m');ylabel('Y/m');
legend([h1,h2,h3],'�۲�վλ��','Ŀ����ʵ�켣','PF�㷨�켣');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RMS ͼ  �������ͼ
figure;hold on;box on
plot(PFrms(1,:),'-k.','MarkerEdgeColor','m');
xlabel('time/s');ylabel('error/m');
legend('RMS�������');
title(['RMSE,q=',num2str(delta_w)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ʵʱ�ԱȽ�ͼ
figure;hold on;box on
plot(Tpf(1,:),'-k.','MarkerEdgeColor','m');
xlabel('step');ylabel('time/s');
legend('ÿ������������PF����ʱ��');
title('Comparison of Realtime')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

