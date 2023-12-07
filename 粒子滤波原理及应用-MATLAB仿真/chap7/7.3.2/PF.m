%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��Ȩ������
%     ���������ϸ����ע����ο�
%     ��Сƽ�����ң�������.�����˲�ԭ��Ӧ��[M].���ӹ�ҵ�����磬2017.4
%     ������ԭ�����+����+����+����ע��
%     ����˳����д��������ʾ�޸�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ����˵���� �����˲��ӳ���
function [Xout,Tpf]=PF(Z,Station,canshu)
T=canshu.T;
M=canshu.M;
Q=canshu.Q;
R=canshu.R;
F=canshu.F;
state0=canshu.state0;
N=200;       
zPred=zeros(1,N);
Weight=zeros(1,N);
xparticlePred=zeros(4,N);
Xout=zeros(4,M);
Xout(:,1)=state0;
Tpf=zeros(1,M);
xparticle=zeros(4,N);
for j=1:N     
    xparticle(:,j)=state0;
end
Xpf=zeros(4,N);
Xpf(:,1)=state0;
for t=2:M
    tic;
    XX=0;   
 
    for k=1:N
        xparticlePred(:,k)=feval('sfun',xparticle(:,k),T,F)+10*sqrtm(Q)*randn(4,1);
    end
 
    for k=1:N
        zPred(1,k)=feval('hfun',xparticlePred(:,k),Station);
        z1=Z(1,t)-zPred(1,k);
        Weight(1,k)=inv(sqrt(2*pi*det(R)))*exp(-.5*(z1)'*inv(R)*(z1))+ 1e-99;%Ȩֵ����
    end
 
    Weight(1,:)=Weight(1,:)./sum(Weight(1,:));
 
    outIndex = randomR(1:N,Weight(1,:)');        
    xparticle= xparticlePred(:,outIndex);  
    target=[mean(xparticle(1,:)),mean(xparticle(2,:)),...
        mean(xparticle(3,:)),mean(xparticle(4,:))]';
    Xout(:,t)=target;
    Tpf(1,t)=toc;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%