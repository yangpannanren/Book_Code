%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵����
% ��վ��Ŀ����ٵĽ�ģ���򣬲��ý��ڷ�����
% ��Ҫģ���Ŀ����˶��͹۲���̣��漰�ں��㷨---���ڷ�
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ��
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xpf,xparticle,Tpf]=PF(Z,S,canshu,xparticle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Q=canshu.Q;R=canshu.R;F=canshu.F;G=canshu.G;N=canshu.N; % ������
zPred=zeros(2,N);
Weight=zeros(1,N);
xparticlePred=zeros(4,N);
Tpf=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
x0=S.x;
y0=S.y;
% ����
for k=1:N
    xparticlePred(:,k)=F*xparticle(:,k)+5*G*sqrtm(Q)*G'*randn(4,1);
end
% ��Ҫ��Ȩֵ����
for k=1:N
    zPred(:,k)=feval('hfun',xparticlePred(:,k),x0,y0);
    z1=Z-zPred(:,k);
    Weight(1,k)=inv(sqrt(2*pi*det(R)))*exp(-.5*(z1)'*inv(R)*(z1))+ 1e-99;%Ȩֵ����
end
% ��һ��Ȩ��
Weight(1,:)=Weight(1,:)./sum(Weight(1,:));
%���²���
outIndex = randomR(1:N,Weight(1,:)');          % random resampling.
xparticle= xparticlePred(:,outIndex); % ��ȡ�²���ֵ
target=[mean(xparticle(1,:)),mean(xparticle(2,:)),...
    mean(xparticle(3,:)),mean(xparticle(4,:))]';
Xpf=target;
Tpf=toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
