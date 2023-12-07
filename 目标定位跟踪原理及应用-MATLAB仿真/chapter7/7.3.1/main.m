%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵����2���۲�վ��2��Ŀ��۲���ٳ���
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ��
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main
TargetNum=2; StationNum=2; % ��ʼ��
T=30;  % �ܷ���ʱ��
dt=1;  % ��������
F=[1,dt,0,0;0,1,0,0;0,0,1,dt;0,0,0,1]; % ״̬ת�ƾ���
G=[0.5*dt^2,0;dt,0;0,0.5*dt^2;0,dt];   % ����������������
H=[1,0,0,0;0,0,1,0];   % �۲����
Q1=diag([0.0001,0.0001]); % Ŀ��1�Ĺ�����������
Q2=diag([0.0009,0.0009]); % Ŀ��2�Ĺ�����������
R1=diag([0.25,0.25]);  % �۲�վ1�Ĳ�����������
R2=diag([0.81,0.81]);  % �۲�վ2�Ĳ�����������
randn('seed',1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ģ��Ŀ���˶����̣��۲�վ̽�����
V{1,1}=sqrt(R1)*randn(2,T);  % �۲�վ1�Ĳ�������
V{1,2}=sqrt(R1)*randn(2,T);  % �۲�վ1�Ĳ�������
V{2,1}=sqrt(R2)*randn(2,T);  % �۲�վ2�Ĳ�������
V{2,2}=sqrt(R2)*randn(2,T);  % �۲�վ2�Ĳ�������
W{1}=sqrt(Q1)*randn(2,T);    % Ŀ��1��������
W{2}=sqrt(Q2)*randn(2,T);    % Ŀ��2��������
X{1}=zeros(4,T);             % Ŀ��1״̬��ʼ��
X{1}(:,1)=[0,1.0,0,1.2];     % ��ʼʱ�̵�״̬
X{2}=zeros(4,T);             % Ŀ��1״̬��ʼ��
X{2}(:,1)=[0,1.2,30,-1.0];   % ��ʼʱ�̵�״̬
Xkf{1,1}(:,1)=X{1}(:,1)+G*W{1}(:,1); % �˲�����ʼ
Xkf{1,2}(:,1)=X{2}(:,1)+G*W{2}(:,1);
Xkf{2,1}(:,1)=X{1}(:,1)+G*W{1}(:,1); % �˲�����ʼ
Xkf{2,2}(:,1)=X{2}(:,1)+G*W{2}(:,1);
P{1,1}=eye(4);   % Kalman�˲���Э�����ʼ��
P{1,2}=eye(4);
P{2,1}=eye(4);
P{2,2}=eye(4);
Xmean{1}=zeros(4,T); % ��۲�վ�����ں����չ��Ƶ�Ŀ��1״̬
Xmean{1}(:,1)=(Xkf{1,1}(:,1)+Xkf{2,1}(:,1))/2;
Xmean{2}=zeros(4,T);% ��۲�վ�����ں����չ��Ƶ�Ŀ��1״̬
Xmean{2}(:,1)=(Xkf{1,2}(:,1)+Xkf{2,2}(:,1))/2;
for i=1:TargetNum            % ��ʼʱ��
    for j=1:StationNum
        Z{j,i}=zeros(2,T);   % ��j���۲�վ�Ե�i��Ŀ��۲�,��ȷ���
        Z{j,i}(:,1)=H*X{i}(:,1)+V{j,i}(:,1);
        Zun{j,i}=[]; % ��j���۲�վ�Ե�i��Ŀ��۲�,���ڷ�����������ڴ�
        Zun{j,i}(:,1)=Z{j,i}(:,1);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=2:T
    % �������еڣ�1����
    ZZ=[]; % �洢�۲����ݵ���ʱ����
    for i=1:TargetNum
        X{i}(:,k)=F*X{i}(:,k-1)+G*W{i}(:,k);% ��i��Ŀ���˶�
        for j=1:StationNum
            Z{j,i}(:,k)=H*X{i}(:,k)+V{j,i}(:,k);% ��j���۲�վ�Ե�i��Ŀ��۲�
            ZZ=[ZZ,Z{j,i}(:,k)];
        end
    end
    % ��ʱ��õ��Ĺ۲�����ZZ��δ֪Ŀ�����ģ���Ҫ���ý��ڷ����亽������
% �۲�վ1�Ĳ������ݣ�ZZ(:,1),ZZ(:,3);�۲�վ2�����ݣ�ZZ(:,2),ZZ(:,4)
    % ������Ҫ���ý��ڷ�������Ŀ��1��2����ȥ���۲�վ1��2�������н��ڷ�
    % �������еڣ�2����
    [Zun{1,1},Zun{1,2}]=NNClassfier(ZZ(:,1),ZZ(:,3),Zun{1,1},Zun{1,2});
    [Zun{2,1},Zun{2,2}]=NNClassfier(ZZ(:,2),ZZ(:,4),Zun{2,1},Zun{2,2});
    % �������Թ��������ݽ���kalman�˲����������еڣ�3����
    [Xkf{1,1}(:,k),P{1,1}]=KalmanFilter(Xkf{1,1}(:,k-1),...
        Zun{1,1}(:,k),P{1,1},F,G,H,Q1,R1); % �۲�վ1��Ŀ��1�˲�
    [Xkf{1,2}(:,k),P{1,2}]=KalmanFilter(Xkf{1,2}(:,k-1),...
        Zun{1,2}(:,k),P{1,2},F,G,H,Q2,R1); % �۲�վ1��Ŀ��2�˲�
    [Xkf{2,1}(:,k),P{2,1}]=KalmanFilter(Xkf{2,1}(:,k-1),...
        Zun{2,1}(:,k),P{2,1},F,G,H,Q1,R2); % �۲�վ2��Ŀ��1�˲�
    [Xkf{2,2}(:,k),P{2,2}]=KalmanFilter(Xkf{2,2}(:,k-1),...
        Zun{2,2}(:,k),P{2,2},F,G,H,Q2,R2); % �۲�վ2��Ŀ��2�˲�
    % ��󣬶������еڣ�4�������þ�ֵ���ں������۲�վ���˲����
    Xmean{1}(:,k)=(Xkf{1,1}(:,k)+Xkf{2,1}(:,k))/2;
    Xmean{2}(:,k)=(Xkf{1,2}(:,k)+Xkf{2,2}(:,k))/2;
end
%%%%%%%%%%%%%%%%%
% ������
Div_Observation{1,1}=zeros(1,T); % �۲�վ1��Ŀ��1�Ĳ���ƫ��
Div_Observation{1,2}=zeros(1,T); % �۲�վ1��Ŀ��2�Ĳ���ƫ��
Div_Observation{2,1}=zeros(1,T); % �۲�վ2��Ŀ��1�Ĳ���ƫ��
Div_Observation{2,2}=zeros(1,T); % �۲�վ2��Ŀ��2�Ĳ���ƫ��
Div_Fusion{1}=zeros(1,T); % �۲�վ1��2�ںϺ��Ŀ��1�Ĺ���ƫ��
Div_Fusion{2}=zeros(1,T); % �۲�վ1��2�ںϺ��Ŀ��2�Ĺ���ƫ��
for k=1:T
    % ͳ�ƶ�Ŀ��1��ƫ��
    x2=X{1}(1,k);y2=X{1}(3,k);
    x1=Zun{1,1}(1,k);y1=Zun{1,1}(2,k);
    Div_Observation{1,1}(1,k)=getDist(x1,y1,x2,y2);
    x1=Zun{2,1}(1,k);y1=Zun{2,1}(2,k);
    Div_Observation{2,1}(1,k)=getDist(x1,y1,x2,y2);
    x1=Xmean{1}(1,k);y1=Xmean{1}(3,k);
    Div_Fusion{1}(1,k)=getDist(x1,y1,x2,y2);
    % ͳ�ƶ�Ŀ��2��ƫ��
    x2=X{2}(1,k);y2=X{2}(3,k);
    x1=Zun{1,2}(1,k);y1=Zun{1,2}(2,k);
    Div_Observation{1,2}(1,k)=getDist(x1,y1,x2,y2);
    x1=Zun{2,2}(1,k);y1=Zun{2,2}(2,k);
    Div_Observation{2,2}(1,k)=getDist(x1,y1,x2,y2);
    x1=Xmean{2}(1,k);y1=Xmean{2}(3,k);
Div_Fusion{2}(1,k)=getDist(x1,y1,x2,y2);
end
% ʱ��T�ڸ�ʱ�̵�ƽ�����
Div_Observation_Mean11=mean(Div_Observation{1,1}(1,:));
Div_Observation_Mean21=mean(Div_Observation{2,1}(1,:));
Div_Fusion_Mean1=mean(Div_Fusion{1}(1,:));
Div_Observation_Mean12=mean(Div_Observation{1,2}(1,:));
Div_Observation_Mean22=mean(Div_Observation{2,2}(1,:));
Div_Fusion_Mean2=mean(Div_Fusion{2}(1,:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ͼ
figure  % �۲�վ1�Ĺ۲⡢�������˲����
hold on;box on;xlabel('X/m');ylabel('Y/m');
h1=plot(X{1}(1,:),X{1}(3,:),'-k');% Ŀ��1
h2=plot(X{2}(1,:),X{2}(3,:),'-k');% Ŀ��2
h3=plot(Z{1,1}(1,:),Z{1,1}(2,:),'b.'); % �۲�1
h4=plot(Z{1,2}(1,:),Z{1,2}(2,:),'b+'); % �۲�2
h5=plot(Zun{1,1}(1,:),Zun{1,1}(2,:),'ro'); % �����۲�1
h6=plot(Zun{1,2}(1,:),Zun{1,2}(2,:),'ks'); % �����۲�2
h7=plot(Xkf{1,1}(1,:),Xkf{1,1}(3,:),'-k.'); % Ŀ��1�˲����
h8=plot(Xkf{1,2}(1,:),Xkf{1,2}(3,:),'-b.'); % Ŀ��2�˲����
figure  % �۲�վ2�Ĺ۲⡢�������˲����
hold on;box on;xlabel('X/m');ylabel('Y/m');
h1=plot(X{1}(1,:),X{1}(3,:),'-k');% Ŀ��1
h2=plot(X{2}(1,:),X{2}(3,:),'-k');% Ŀ��2
h3=plot(Z{2,1}(1,:),Z{2,1}(2,:),'b.'); % �۲�1
h4=plot(Z{2,2}(1,:),Z{2,2}(2,:),'b+'); % �۲�2
h5=plot(Zun{2,1}(1,:),Zun{2,1}(2,:),'ro'); % �����۲�1
h6=plot(Zun{2,2}(1,:),Zun{2,2}(2,:),'ks'); % �����۲�2
h7=plot(Xkf{2,1}(1,:),Xkf{2,1}(3,:),'-k.'); % Ŀ��1�˲����
h8=plot(Xkf{2,2}(1,:),Xkf{2,2}(3,:),'-b.'); % Ŀ��2�˲����
figure  % 2���۲�վ���յ��ںϽ��
hold on;box on;xlabel('X/m');ylabel('Y/m');
h1=plot(X{1}(1,:),X{1}(3,:),'-k');% Ŀ��1
h2=plot(X{2}(1,:),X{2}(3,:),'-k');% Ŀ��2
h3=plot(Z{1,1}(1,:),Z{1,1}(2,:),'b.'); % �۲�վ1��Ŀ��1�۲�
h4=plot(Z{1,2}(1,:),Z{1,2}(2,:),'b*'); % �۲�վ1��Ŀ��2�۲�
h5=plot(Z{2,1}(1,:),Z{2,1}(2,:),'r.'); % �۲�վ2��Ŀ��1�۲�
h6=plot(Z{2,2}(1,:),Z{2,2}(2,:),'r*'); % �۲�վ2��Ŀ��2�۲�
h7=plot(Xmean{1}(1,:),Xmean{1}(3,:),'-bo');% ��۲�վ�ں�Ŀ��1
h8=plot(Xmean{2}(1,:),Xmean{2}(3,:),'-r^');% ��۲�վ�ں�Ŀ��2
figure % ��Ŀ��1�Ĺ���ƫ��
bar_width=1.5;
subplot(121);
hold on;box on;xlabel('Time/s');ylabel('Value of deviation/m');
plot(1:T,Div_Observation{1,1}(1,:),'-kd','MarkerFace','g');
plot(1:T,Div_Observation{2,1}(1,:),'-ks','MarkerFace','b');
plot(1:T,Div_Fusion{1}(1,:),'-ko','MarkerFace','r');
legend('��1վ�۲�ƫ��','��2վ�۲�ƫ��','�ںϺ��Ŀ��1ƫ��')
subplot(122);
hold on;box on;xlabel('Time/s');ylabel('Value of average deviation/m');
bar(2,Div_Observation_Mean11,'r');
bar(4,Div_Observation_Mean21,'g');
bar(6,Div_Fusion_Mean1,'b');
figure % ��Ŀ��2�Ĺ���ƫ��
subplot(121);
hold on;box on;xlabel('Time/s');ylabel('Value of deviation/m');
plot(1:T,Div_Observation{1,2}(1,:),'-kd','MarkerFace','g');
plot(1:T,Div_Observation{2,2}(1,:),'-ks','MarkerFace','b');
plot(1:T,Div_Fusion{2}(1,:),'-ko','MarkerFace','r');
legend('��1վ�۲�ƫ��','��2վ�۲�ƫ��','�ںϺ��Ŀ��2ƫ��');
subplot(122);
hold on;box on;xlabel('Time/s');ylabel('Value of average deviation/m');
bar(2,Div_Observation_Mean12,'r');
bar(4,Div_Observation_Mean22,'g');
bar(6,Div_Fusion_Mean2,'b');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
