%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵�������ڹ۲���룬�����˲���ɶ�Ŀ��״̬����
function [sys,x0,str,ts]=ParticleFilter(t,x,u,flag)
global Zdist;  % �۲���Ϣ
global Xpf;    % �����˲�����״̬
global Xpfset;  % ���Ӽ���
randn('seed',20);
N=200; % ������Ŀ
% �����˲��������İ뾶���������Ӽ��ϵķ�ɢ�ȣ��൱�ڹ�������Q
NETQ=diag([0.0001,0.0009]); 
% NETR�൱�ڲ�������R
NETR=0.01;
switch flag
    case 0  % ϵͳ���г�ʼ��������mdlInitializeSizes����
        [sys,x0,str,ts]=mdlInitializeSizes(N);
    case 2  % ������ɢ״̬����������mdlUpdate����
        sys=mdlUpdate(t,x,u,N,NETQ,NETR);
    case 3  % ����S���������������mdlOutputs
        sys=mdlOutputs(t,x,u);
    case {1,4}
        sys=[];
    case 9   % �������������״ֵ̬
        save('Xpf','Xpf');
        save('Zdist','Zdist');
    otherwise   % ����δ֪��������û������Զ���
        error(['Unhandled flag = ',num2str(flag)]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1��ϵͳ��ʼ���Ӻ���
function [sys,x0,str,ts]=mdlInitializeSizes(N)
sizes = simsizes;
sizes.NumContStates  = 0;   % ��������
sizes.NumDiscStates  = 4;   % ��ɢ״̬4ά
sizes.NumOutputs     = 4;   % ���4ά��ӦΪ״̬����x-y�����λ�ú��ٶ�
sizes.NumInputs      = 1;   % ����ά������Ϊ����ģ����2ά��
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % ������Ҫ�Ĳ���ʱ��
sys = simsizes(sizes);
x0  = [10,10,12,10]';             % ��ʼ����
str = [];               % str��������Ϊ��
ts  = [-1 0];  % ��ʾ��ģ�����ʱ��̳���ǰ��ģ�����ʱ������
% ���Ӽ��ϳ�ʼ��
global Xpfset;
Xpfset=zeros(4,N);
for i=1:N
    Xpfset(:,i)=x0+0.1*randn(4,1);
end
global Zdist;  % �۲���Ϣ
Zdist=[];
global Xpf;    % �����˲�����״̬
Xpf=[x0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2��������ɢ״̬�����ĸ���
function sys=mdlUpdate(t,x,u,N,NETQ,NETR)
global Zdist;  % �۲���Ϣ
global Xpf;
global Xpfset;  % ���Ӽ���
Zdist=[Zdist,u]; % ����۲���Ϣ
%����������������������������������������������������������������������������
% ���濪ʼ�������˲���״̬����
G=[0.5,0;1,0;0,0.5;0,1];
F=[1,1,0,0;0,1,0,0;0,0,1,1;0,0,0,1];
x0=0;y0=0; % �״�վ��λ��
% ��һ�������Ӽ��ϲ���
for i=1:N
    Xpfset(:,i)=F*Xpfset(:,i)+G*sqrt(NETQ)*randn(2,1);
end
% Ȩֵ����
for i=1:N
    zPred(1,i)=hfun(Xpfset(:,i),x0,y0);
    weight(1,i)=exp( -0.5*NETR^(-1)*( zPred(1,i)-u )^2 )+1e-99;
end
% ��һ��Ȩֵ
weight=weight./sum(weight);
% �ز���
outIndex=randomR(1:N,weight');
% �µ����Ӽ���
Xpfset=Xpfset(:,outIndex);
% ״̬����
Xnew=[mean(Xpfset(1,:)),mean(Xpfset(2,:)),...
    mean(Xpfset(3,:)),mean(Xpfset(4,:))]';
% �������µ�״̬���������
Xpf=[Xpf,Xnew];
sys=Xnew;  % ����ľ��뷵��ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3����ȡϵͳ������ź�
function sys=mdlOutputs(t,x,u)
sys = x;  % ����õ�ģ�������������sys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d=hfun(X,x0,y0)
d=sqrt( (X(1)-x0)^2+(X(3)-y0)^2 );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outIndex = randomR(inIndex,q)
outIndex=zeros(size(inIndex));
[num,col]=size(q);
u=rand(num,1);
u=sort(u);
l=cumsum(q);
i=1;
for j=1:num
    while (i<=num)&(u(i)<=l(j))
        outIndex(i)=j;
        i=i+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
