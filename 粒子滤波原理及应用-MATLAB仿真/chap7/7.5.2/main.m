%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��Ȩ������
%     ���������ϸ����ע����ο�
%     ��Сƽ�����ң�������.�����˲�ԭ��Ӧ��[M].���ӹ�ҵ�����磬2017.4
%     ������ԭ�����+����+����+����ע��
%     ����˳����д��������ʾ�޸�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main
clear;
T=1;   
error('����Ĳ���M��ο����е�ֵ���ã�Ȼ��ɾ�����д���')
M=0;   
delta_w=1e-3;  
Q=delta_w*diag([0.5,1,0.5,1]) ;  
R=2;                 
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];
Node_number=6;  
Length=100;   
Width=100;     
for i=1:Node_number
    Node(i).x=Width*rand;   
    Node(i).y=Length*rand;
end
for i=1:Node_number   
    NodePostion(:,i)=[Node(i).x,Node(i).y]';
end
X=zeros(4,M);            
Z=zeros(Node_number,M);   
w=randn(4,M);
v=randn(Node_number,M);
X(:,1)=[1,Length/M,20,60/M]';  
state0=X(:,1);                 
 
for t=2:M  
 
    X(:,t)=F*X(:,t-1)+sqrtm(Q)*w(:,t); 
end
 
for t=1:M
    for i=1:Node_number
        x0=NodePostion(1,i);
        y0=NodePostion(2,i);
 
        Z(i,t)=feval('hfun',X(:,t),x0,y0)+sqrtm(R)*v(i,t);
    end
end
 
canshu.T=T;
canshu.M=M;
canshu.Q=Q;
canshu.R=R;
canshu.F=F;
canshu.state0=state0;
canshu.Node_number=Node_number;
 
[Xpf,Tpf]=PF(Z,NodePostion,canshu);
 
for t=1:M
    PFrms(1,t)=distance(X(:,t),Xpf(:,t));
end
 
figure
hold on
box on
for i=1:Node_number
 
    h1=plot(NodePostion(1,i),NodePostion(2,i),'ro','MarkerFaceColor','b');
    text(NodePostion(1,i)+0.5,NodePostion(2,i),['Node',num2str(i)])
end
 
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
hold off
 
figure
hold on
box on
plot(Tpf(1,:),'-k.','MarkerEdgeColor','m');  
xlabel('step');
ylabel('time/s');
legend('ÿ������������PF����ʱ��');
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
