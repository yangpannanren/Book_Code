%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵�����޼�Kalman�˲���6άĿ�����ϵͳ�е�Ӧ��
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ukf_for_track_6_div_system
n=6;    % ״̬λ��
t=0.5;  % ����ʱ��
Q=[1 0 0 0 0 0;
    0 1 0 0 0 0;
    0 0 0.01 0 0 0;
    0 0 0 0.01 0 0;
    0 0 0 0 0.0001 0;
    0 0 0 0 0 0.0001];%��������Э������
R = [100 0;
    0 0.001^2];%��������Э������
% ״̬����
f=@(x)[x(1)+t*x(3)+0.5*t^2*x(5);x(2)+t*x(4)+0.5*t^2*x(6);...
    x(3)+t*x(5);x(4)+t*x(6);x(5);x(6)];
%x1ΪX��λ�ã�x2ΪY��λ�ã�x3��x4�ֱ���X��
%Y����ٶȣ�x5��x6ΪX��Y������ļ��ٶ�
% �۲ⷽ��
h=@(x)[sqrt(x(1)^2+x(2)^2);atan(x(2)/x(1))];
s=[1000;5000;10;50;2;-4];
x0=s+sqrtm(Q)*randn(n,1); % ��ʼ��״̬
P0 =[100 0 0 0 0 0;
    0 100 0 0 0 0;
    0 0 1 0 0 0;
    0 0 0 1 0 0;
    0 0 0 0 0.1 0;
0 0 0 0 0 0.1]; % ��ʼ��Э����
N=50; % �ܷ���ʱ�䲽��������ʱ��
Xukf = zeros(n,N); % UKF�˲�״̬��ʼ��
X = zeros(n,N); % ��ʵ״̬
Z = zeros(2,N); % ����ֵ
for i=1:N
    X(:,i)= f(s)+sqrtm(Q)*randn(6,1);  % ģ�⣬����Ŀ���˶���ʵ�켣
    s = X(:,i);
end
ux=x0;  % uxΪ�м����
for k=1:N
    Z(:,k)= h(X(:,k)) + sqrtm(R)*randn(2,1);     % ����ֵ    % ����۲�
    [Xukf(:,k), P0] = ukf(f,ux,P0,h,Z(:,k),Q,R);    % ����ukf�˲��㷨
    ux=Xukf(:,k);
end
% ����������
% ����ֻ����λ�����ٶȡ����ٶ��������ڴ��ԣ����߿����Լ�����
for k=1:N
    RMS(k)=sqrt( (X(1,k)-Xukf(1,k))^2+(X(2,k)-Xukf(2,k))^2 );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ͼ���켣ͼ
figure
t=1:N;
hold on;box on;
plot( X(1,t),X(2,t), 'k-')
plot(Z(1,t).*cos(Z(2,t)),Z(1,t).*sin(Z(2,t)),'-b.')
plot(Xukf(1,t),Xukf(2,t),'-r.')
legend('ʵ��ֵ','����ֵ','ukf����ֵ');
xlabel('x����λ��/��')
ylabel('y����λ��/��')
% ������ͼ
figure
box on;
plot(RMS,'-ko','MarkerFace','r')
xlabel('t/��')
ylabel('ƫ��/��')
%title('����λ��ƫ��')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% UKF�Ӻ���
function [X,P]=ukf(ffun,X,P,hfun,Z,Q,R)
% ������ϵͳ��UKF�㷨
L=numel(X);                                 % ״̬ά��
m=numel(Z);                                 % �۲�ά��
alpha=1e-2;                        % Ĭ��ϵ�����ο�UT�任����ͬ
ki=0;                                       % Ĭ��ϵ��
beta=2;                                     % Ĭ��ϵ��
lambda=alpha^2*(L+ki)-L;                    % Ĭ��ϵ��
c=L+lambda;                                 % Ĭ��ϵ��
Wm=[lambda/c 0.5/c+zeros(1,2*L)];           % Ȩֵ
Wc=Wm;
Wc(1)=Wc(1)+(1-alpha^2+beta);               % Ȩֵ
c=sqrt(c);
% ��һ�������һ��Sigma�㼯
% Sigma�㼯����״̬X�����ĵ㼯��X��6*13����ÿ��Ϊ1����
Xsigmaset=sigmas(X,P,c); 
% �ڶ��������Ĳ�����Sigma�㼯����һ��Ԥ�⣬�õ���ֵX1means�ͷ���P1����sigma�㼯X1
% ��״̬UT�任
[X1means,X1,P1,X2]=ut(ffun,Xsigmaset,Wm,Wc,L,Q);   
% ���塢�������õ��۲�Ԥ�⣬Z1ΪX1���ϵ�Ԥ�⣬ZpreΪZ1�ľ�ֵ��
% PzzΪЭ���
[Zpre,Z1,Pzz,Z2]=ut(hfun,X1,Wm,Wc,m,R);     % �Թ۲�UT�任
Pxz=X2*diag(Wc)*Z2';                        % Э����Pxz
% ���߲�������kalman����
K=Pxz*inv(Pzz);
% �ڰ˲���״̬�ͷ������
X=X1means+K*(Z-Zpre);                              % ״̬����
P=P1-K*Pxz';                                % Э�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UT�任�Ӻ���
% ���룺funΪ���������XsigmaΪ��������Wm��WcΪȨֵ��
% nΪ״̬ά��(n=6)��COVΪ����
% �����XmeansΪ��ֵ��
function [Xmeans,Xsigma_pre,P,Xdiv]=ut(fun,Xsigma,Wm,Wc,n,COV)
LL=size(Xsigma,2);% �õ�Xsigma��������
Xmeans=zeros(n,1);%��ֵ
Xsigma_pre=zeros(n,LL);
for k=1:LL
    Xsigma_pre(:,k)=fun(Xsigma(:,k));% һ��Ԥ��
    Xmeans=Xmeans+Wm(k)*Xsigma_pre(:,k);
end
% Xmeans(:,ones(1,LL))��Xmeans��չ��n*LL����ÿһ�ж����
Xdiv=Xsigma_pre-Xmeans(:,ones(1,LL));% Ԥ���ȥ��ֵ
P=Xdiv*diag(Wc)*Xdiv'+COV; % Э����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����Sigma�㼯����
function Xset=sigmas(X,P,c)
A = c*chol(P)';% Cholesky�ֽ�
Y = X(:,ones(1,numel(X)));
Xset = [X Y+A Y-A];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
