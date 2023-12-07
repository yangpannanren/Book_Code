%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��Ȩ������
%     ���������ϸ����ע����ο�
%     ��Сƽ�����ң�������.�����˲�ԭ��Ӧ��[M].���ӹ�ҵ�����磬2017.4
%     ������ԭ�����+����+����+����ע��
%     ����˳����д��������ʾ�޸�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ����˵���� ��վ��Ŀ����ڽǶȵĸ���ϵͳ�����������˲��㷨
%  ״̬����  X��k+1��=F*X(k)+Lw(k)
%  �۲ⷽ��  Z��k��=h��X��+v��k��
function main
 
clear;
T=1;   
error('����Ĳ���M��ο����е�ֵ���ã�Ȼ��ɾ�����д���')
M=0;  
delta_w=1e-4;  
Q=delta_w*diag([0.5,1,0.5,1]) ;  
R=pi/180*0.1;                  
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];
 
Length=100;   
Width=100;
 
Node.x=Width*rand;
Node.y=Length*rand;
 
X=zeros(4,M);  
Z=zeros(1,M);  
w=randn(4,M);  
v=randn(1,M); 
X(:,1)=[1,Length/M,20,60/M]';  
state0=X(:,1);  
for t=2:M
    X(:,t)=F*X(:,t-1)+sqrtm(Q)*w(:,t); 
end
 
for t=1:M
    x0=Node.x;
    y0=Node.y;
    Z(1,t)=feval('hfun',X(:,t),x0,y0)+sqrtm(R)*v(1,t);
end
 
 
canshu.T=T;
canshu.M=M;
canshu.Q=Q;
canshu.R=R;
canshu.F=F;
canshu.state0=state0;
 
[Xpf,Tpf]=PF(Z,Node,canshu);
 
for t=1:M
    PFrms(1,t)=distance(X(:,t),Xpf(:,t));
end
 
figure
hold on
box on
 
h1=plot(Node.x,Node.y,'ro','MarkerFaceColor','b');
 
h2=plot(X(1,:),X(3,:),'--m.','MarkerEdgeColor','m');
 
h3=plot(Xpf(1,:),Xpf(3,:),'-k*','MarkerEdgeColor','b');
xlabel('X/m');
ylabel('Y/m');
legend([h1,h2,h3],'�۲�վλ��','Ŀ����ʵ�켣','PF�㷨�켣');
hold off
 
 
figure
hold on
box on
plot(PFrms(1,:),'-k.','MarkerEdgeColor','m');
xlabel('time/s');
ylabel('error/m');
legend('RMS�������');
title(['RMSE,q=',num2str(delta_w)])
hold off
 
figure
hold on
box on
plot(Tpf(1,:),'-k.','MarkerEdgeColor','m');
xlabel('step');
ylabel('time/s');
legend('ÿ������������PF����ʱ��');
title('Comparison of Realtime')
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
