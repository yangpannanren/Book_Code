%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵�������ӞV����һ�Sϵ�y�е�Ӧ��
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Particle_For_UnlineOneDiv
randn('seed',1)
% ��ʼ����ز���
N =50;                 % ��������
T=1;                   % ��������
Q=10;                  % ������������
R=1;                   % ������������
v=sqrt(R)*randn(N,1);  % ��������
w=sqrt(Q)*randn(N,1);  % ��������
numSamples=100;        % ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x0=0.1;                % ��ʼ״̬
%������ʵ״̬�͹۲�ֵ
X=zeros(N,1);          % ��ʵ״̬
Z=zeros(N,1);          % ����
X(1,1)=x0;             % ��ʵ״̬��ʼ��
Z(1,1)=(X(1,1)^2)./20 + v(1,1); % �۲�ֵ��ʼ��
for k=2:N
    X(k,1)=0.5*X(k-1,1) + 2.5*X(k-1,1)/(1+X(k-1,1)^(2))...
    + 8*cos(1.2*k)+ w(k-1,1);           % ״̬����
    Z(k,1)=(X(k,1).^(2))./20 + v(k,1);  % �۲ⷽ��
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����˲�
Xpf=zeros(numSamples,N);        % �����˲�����״̬
Xparticles=zeros(numSamples,N); % ���Ӽ���
Zpre_pf=zeros(numSamples,N);    % �����˲��۲�Ԥ��ֵ
weight=zeros(numSamples,N);     % Ȩ�س�ʼ��
% ��ʼ����:
Xpf(:,1)=x0+sqrt(Q)*randn(numSamples,1);
Zpre_pf(:,1)=Xpf(:,1).^2/20;
% ������Ԥ�����:
for k=2:N
    % ��һ�������Ӽ��ϲ�������
    for i=1:numSamples
        QQ=Q;    % ��kalman�˲���ͬ�������Q��Ҫ���������������һ��
        net=sqrt(QQ)*randn; % �����QQ���Կ����ǡ������İ뾶����ֵ�Ͽ��Ե���
        Xparticles(i,k)=0.5.*Xpf(i,k-1) + 2.5.*Xpf(i,k-1)./(1+Xpf(i,k-1).^2)...
        + 8*cos(1.2*k) + net;  
    end
    % �ڶ����������Ӽ����е�ÿ�����ӣ���������Ҫ��Ȩֵ
    for i=1:numSamples
        Zpre_pf(i,k)=Xparticles(i,k)^2/20;
        weight(i,k)=exp(-.5*R^(-1)*(Z(k,1)- Zpre_pf(i,k))^2);%ʡ���˳�����
    end
    weight(:,k)=weight(:,k)./sum(weight(:,k));%��һ��Ȩֵ
    % ������������Ȩֵ��С�����Ӽ����ز�����Ȩֵ���Ϻ����Ӽ�����һһ��Ӧ��
    outIndex = randomR(weight(:,k)'); % ��ο�6.4�ڣ��ú�����ʵ�ֹ���
    % ���Ĳ��������ز����õ���������ȥ��ѡ��Ӧ�����ӣ��ع��ļ��ϱ����˲����״̬����
    % �����״̬�������ֵ���������յ�Ŀ��״̬�����������ֵ����
    Xpf(:,k)= Xparticles(outIndex,k);
end
% ��������ֵ���ơ���������Ƽ����Ʒ���:
Xmean_pf=mean(Xpf); % �����ֵ���ƣ�������ĵ��Ĳ���Ҳ�������˲����Ƶ�����״̬
bins=20;
Xmap_pf=zeros(N,1);
for k=1:N
    [p,pos]=hist(Xpf(:,k,1),bins);
    map=find(p==max(p));
    Xmap_pf(k,1)=pos(map(1));% ���������
end
for k=1:N
    Xstd_pf(1,k)=std(Xpf(:,k)-X(k,1));%��������׼�����
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ͼ
figure(1);clf;  % ���������Ͳ�������--ͼ
subplot(221);
plot(v);   % ��������
xlabel('Time');ylabel('Measurement Noise','fontsize',15);
subplot(222);
plot(w);   % ��������
xlabel('Time');ylabel('Process Noise','fontsize',15);
subplot(223);
plot(X);   % ��ʵ״̬
xlabel('Time','fontsize',15);ylabel('State X','fontsize',15);
subplot(224);
plot(Z);   % ����������ֵ���۲�ֵ
xlabel('Time','fontsize',15);ylabel('Observation Z','fontsize',15);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);clf; % ״̬����ͼ���켣ͼ��
k=1:T:N;
plot(k,X,'b',k,Xmean_pf,'r',k,Xmap_pf,'g'); % ע��Xmean_pf���������˲����
legend('True value','Posterior mean estimate','MAP estimate');
xlabel('Time','fontsize',15);ylabel('State estimate','fontsize',15);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3);
subplot(121); 
plot(Xmean_pf,X,'+'); % �����˲�����ֵ����ʵ״ֵ̬���1��1��ϵ�����ԳƷֲ�
xlabel('Posterior mean estimate','fontsize',15);
ylabel('True state','fontsize',15)
hold on;
c=-25:1:25;
plot(c,c,'r'); % ����ɫ�ĶԳ���y=x
axis([-25 25 -25 25]);
hold off;
subplot(122);  % ���������ֵ����ʵ״ֵ̬���1��1��ϵ�����ԳƷֲ�
plot(Xmap_pf,X,'+')
ylabel('True state','fontsize',15)
xlabel('MAP estimate','fontsize',15)
hold on;
c=-25:1:25;
plot(c,c,'r'); % ����ɫ�ĶԳ���y=x
axis([-25 25 -25 25]);
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ֱ��ͼ����ͼ����Ϊ�˿������Ӽ��ĺ����ܶ�
domain=zeros(numSamples,1);
range=zeros(numSamples,1);
bins=10;
support=[-20:1:20];
figure(4);hold on;% ֱ��ͼ
xlabel('Sample space','fontsize',15);ylabel('Time','fontsize',15);
zlabel('Posterior density','fontsize',15);
vect=[0 1];
caxis(vect);
for k=1:N
    % ֱ��ͼ��ӳ�˲�������Ӽ��ϵķֲ����
    [range,domain]=hist(Xpf(:,k),support);
    % ����waterfall��������ֱ��ͼ�ֲ������ݻ�����
    waterfall(domain,k,range);
end
axis([-20 20 0 N 0 100]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(5);hold on; box on; xlabel('Sample space','fontsize',15);
ylabel('Posterior density','fontsize',15);% �����ܶȣ������Ϊ�ֲ�
k=30;   % k=����ʾҪ�鿴�ڼ���ʱ�̵����ӷֲ�(�ܶ�)����ʵ״ֵ̬���ص���ϵ
[range,domain]=hist(Xpf(:,k),support);
plot(domain,range);
XXX=[X(k,1),X(k,1)];YYY=[0,max(range)+10]
line(XXX,YYY,'Color','r');
axis([min(domain) max(domain) 0 max(range)+10]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(6); %  ���Ʒ���ͼ
k=1:T:N;
plot(k,Xstd_pf,'-');
xlabel('ʱ�䣨t/s��');ylabel('״̬��������׼��');
axis([0,N,0,10]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����ز����Ӻ���
function outIndex = randomR(W)
% ����˵����W���������Ҫ��������������飬��1��N����
% outIndex����������W���ز�������������� V=W(outIndex)
% V���Ǹ�����������W����Ԫ�س�ȡԪ����ɵļ��ϣ����ز����Ľ��
N=length(W);          % �õ�����W��ά��
outIndex=zeros(1,N); %  ��ʼ��
% ��������ֲ�α�����
u=rand(1,N);  % ��������6.4.1������ز������㷨���裨1��
u=sort(u);    % ��������6.4.1������ز������㷨���裨2��
CS=cumsum(W); % ��W���ۼӺ�
i=1; 
for j=1:N
    while ( i<=N ) & ( u(i)<=CS(j) )
        outIndex(i)=j; % ��W������������outIndex��
        i=i+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

