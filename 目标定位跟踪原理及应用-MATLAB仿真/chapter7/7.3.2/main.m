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
function main
% ��ʼ������
T=20;                 % ����ʱ�䳤��
TargetNum=3;           % Ŀ�����
dt=1;                  % ����ʱ����
S.x=100*rand;          % �۲�վˮƽλ��
S.y=100*rand;          % �۲�վ����λ��
F=[1,dt,0,0;0,1,0,0;0,0,1,dt;0,0,0,1];  % ����CVģ�͵�״̬ת�ƾ���
G=[0.5*dt^2,0;dt,0;0,0.5*dt^2;0,dt];    % ����������������
H=[1,0,0,0;0,0,1,0];                    % �۲����
Q=diag([0.01,0.01]); % ������������
cigma_cita=pi/180*0.1; % �Ƕ�Э����
cigma_r=10;             % ����Э����
R=diag([cigma_r,cigma_cita]);  % �۲���������
% ״̬�͹۲�ĳ�ʼ��
for i=1:TargetNum
    % y��λ�ú�y������ٶ��������
    % ע�⣬��80����Ϊ����ֵ�����Ե����켣֮��ļ��
    % �������ó�20��40��60��80�����ԶԱȷ���Ч��
    X{i}(:,1)=[3,100/T,80*(i-1),100/T+0.1*randn]';
    state0{i}=X{i}(:,1)+G*sqrt(Q)*G'*randn(4,1);
    % �۲��ʼ��
    Z{i}(:,1)=hfun(X{i}(:,1),S.x,S.y)+sqrt(R)*randn(2,1);
    % ���ݹ۲����λ��
    Xn{i}(:,1)=pfun(Z{i}(:,1),S.x,S.y);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ģ��Ŀ���˶����۲�վ��Ŀ��۲�
for t=2:T
    for j=1:TargetNum
        % ��j��Ŀ���״̬����
        X{j}(:,t)=F*X{j}(:,t-1)+G*sqrt(Q)*randn(2,1);
        % �����۲�վ�Ե�j��Ŀ��۲⣬�۲ⷽ��
        Z{j}(:,t)=hfun(X{j}(:,t),S.x,S.y)+sqrt(R)*randn(2,1);
        % ���ݹ۲����λ��
        Xn{j}(:,t)=pfun(Z{j}(:,t),S.x,S.y);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ͼ
figure
hold on,box on;
for j=1:TargetNum
    h1=plot(X{j}(1,:),X{j}(3,:),'-r.');  % ���Ŀ�����ʵ�켣
    h2=plot(Xn{j}(1,:),Xn{j}(2,:),'b*');  % �����۲�վ�Զ��Ŀ��۲�켣
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �ٶ���������Ŀ��Ĺ۲⣬���ǲ�֪���۲������������ĸ�Ŀ���
% �����Z{j}(:,t),��tʱ�̵����ݣ���û�п�ʼ���࣬�����Ҫ��ʼ�������
for j=1:TargetNum
    % ��ʼ����֪����������
    X_class{j}(:,1)=Xn{j}(:,1) ;
    Z_class{j}(:,1)=Z{j}(:,1) ;
end
% �����˲���ʼ��
N=300; % ������
for i=1:TargetNum
    xparticle{i}=zeros(4,N);
    Xpf{i}=zeros(4,T); % ״̬���Ƶĳ�ʼ��
    Xpf{i}(:,1)=state0{i};
    for j=1:N      % ���Ӽ���ʼ��
        xparticle{i}(:,j)=state0{i};
    end
end
% �����������
canshu.Q=Q;
canshu.R=R;
canshu.F=F;
canshu.G=G;
canshu.N=N; % ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=2:T
    % ����ʱ�����У������δ֪��������������������з���
    Xun=[]; % �������tʱ�����вɼ�����δ֪����
    Zun=[]; % �������tʱ�����вɼ�����δ֪�۲�����
    for j=1:TargetNum
        Xun=[Xun,Xn{j}(:,t)];
        Zun=[Zun,Z{j}(:,t)];
    end
    % tʱ��δ֪�����������������
    [X_class,Z_class]=NNClass(Xun,X_class,Zun,Z_class);
    % ����õ��������ͽ��˲����˲�����
    % ���������˲��㷨
    for i=1:TargetNum
        % �ҵ��۲����ݼ��е�ǰʱ�̵Ĺ۲�����
        last=length(Z_class{i}(1,:));
        Z_last=Z_class{i}(:,last);
        [Xout,xparticle_return,Tpf]=PF(Z_last,S,canshu,xparticle{i});
        xparticle{i}=xparticle_return;
        Xpf{i}(:,t)=Xout;
    end
end
for j=1:TargetNum
    % �����Ĺ켣
    h3=plot(X_class{j}(1,:),X_class{j}(2,:),'-go');
    h4=plot(Xpf{j}(1,:),Xpf{j}(3,:),'-b.');
end
legend([h1,h2,h3,h4],'��ʵ�켣','�۲�����','���ڷ��ںϹ켣','�����˲�����')
xlabel('X/m');ylabel('Y/m');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������
for i=1:TargetNum
    for t=1:T
        XX=X{i}(:,t);
        YY=Xn{i}(:,t);
        Deviation_Xn_X{i}(t)=getDist(XX,YY); % ����ƫ��
        Deviation_Xpf_X{i}(t)=getDist(X{i}(:,t),Xpf{i}(:,t)); % �˲����ƫ��
    end
    % ƽ��ƫ��
    Ave_Deviation(i,1)=mean(Deviation_Xn_X{i});
    Ave_Deviation(i,2)=mean(Deviation_Xpf_X{i});
end
figure  % �����������ƫ��ͼ
for i=1:TargetNum
    subplot(3,1,i)
    hold on;box on;
    plot(Deviation_Xn_X{i},'-ko')
    plot(Deviation_Xpf_X{i},'-r.')
    xlabel('Time/s');ylabel('Value of Deviation/m');
end
figure % ����ƽ�����
hold on;box on;
bar(Ave_Deviation,'group')
legend('�۲�ƽ��ƫ��','�˲�ƽ��ƫ��')
xlabel('Target ID');ylabel('Value of Average Deviation/m');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
