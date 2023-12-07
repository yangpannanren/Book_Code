%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵������վ��Ŀ����ٵĽ�ģ����
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ��
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MTT_Model_Of_MutiStation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ʼ������
% ���滷�����ã�����Ŀ����Length*Width�ķ�Χ���˶�
Length=500; % ���صĳ�
Width=500;  % ���صĿ�
T=100;                 % ����ʱ�䳤��
TargetNum=2;           % Ŀ�����
StationNum=4;          % �۲�վ����
dt=1;                  % ����ʱ����
F=[1,dt,0,0;0,1,0,0;0,0,1,dt;0,0,0,1];  % ����CVģ�͵�״̬ת�ƾ���
G=[0.5*dt^2,0;dt,0;0,0.5*dt^2;0,dt];    % ����������������
% �������Ŀ��Ĺ����������ǲ�һ����
for i=1:TargetNum
    Q{i}=diag([0.02+1e-3*randn,0.001+1e-4*randn]); % ������������
end
% ��������۲�վ�Ĵ��������Ȳ�һ������۲����������ò�ֵͬ
for j=1:StationNum
    % ע�⣺����Ĺ۲���������ϴ󣬽Ƕȵķ���Ϊ1��Ϊ��
    Rr=(10+0.1*randn)^2;
    Rcita=(pi/180+1e-3*randn)^2;
    R{j}=diag([Rr,Rcita]);  % �۲���������
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �۲�վλ�ó�ʼ��������۲�վ��λ���������
for i=1:StationNum
    % ��i���۲�վxλ��
    Station{i}.x=Length*rand;
    % ��i���۲�վyλ��
    Station{i}.y=Width*rand;
    % ��Ϊ�̶����������ڼ������ڴ˹̻��������ʵʱ��
    Station{i}.D=Station{i}.x^2+Station{i}.y^2;
end
% Ŀ��״̬��ʼ��
for i=1:TargetNum
    X{i}=zeros(4,T);
end
% Ŀ��ĳ�ʼ״̬��ֵ
for i=1:TargetNum
    X{i}(:,1)=[3,300/T,200*(i-1),300/T+0.1*randn]';
end
% �۲��ʼ��
for i=1:TargetNum
    for j=1:StationNum
        % ��j���۲�վ�Ե�i��Ŀ��۲�
        Z{j,i}=zeros(2,T);
        Xn{j,i}=zeros(4,T);
    end
end
% �۲�վ��Ŀ���ʼ״̬���й۲�
for i=1:TargetNum
    for j=1:StationNum
        % ��j���۲�վ�Ե�i��Ŀ��۲�
        Z{j,i}(:,1)=hfun(X{i}(:,1),Station{j});
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ģ��Ŀ���˶����۲�վ��Ŀ��۲�
for t=2:T
    for i=1:TargetNum
        % Ŀ���˶�����i��Ŀ���״̬����
        X{i}(:,t)=F*X{i}(:,t-1)+G*sqrt(Q{i})*randn(2,1);
        for j=1:StationNum
            % tʱ��,��j���۲�վ�Ե�i��Ŀ��۲�
            Z{j,i}(:,t)=hfun(X{i}(:,t),Station{j})+sqrtm(R{i})*randn(2,1);
        end
    end
end
% ֱ�����ú������Ĺ۲����ݼ���Ŀ��λ��
for t=1:T
    for i=1:TargetNum
        for j=1:StationNum
            Xn{j,i}(:,t)=pfun(Z{j,i}(:,t),Station{j});
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ͼ
figure; hold on,box on;
for j=1:StationNum  % ���۲�վ
    plot(Station{j}.x,Station{j}.y,'ko','MarkerFace','r')
    text(Station{j}.x,Station{j}.y+5,['Station ',num2str(j)])
end
for i=1:TargetNum % ���켣
    plot(X{i}(1,:),X{i}(3,:),'-r.')  % ���Ŀ�����ʵ�켣
    for j=1:StationNum
        % �����۲�վ�Զ��Ŀ��۲�켣
        if i<2
            plot(Xn{j,i}(1,:),Xn{j,i}(3,:),'b.')  % �Թ켣��겻ͬ��ɫ
        else
            plot(Xn{j,i}(1,:),Xn{j,i}(3,:),'g.')  % �Թ켣��겻ͬ��ɫ
        end
    end
end
axis([0 500 0 500])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �۲��Ӻ��� hfun
function value=hfun(X,Station)
r=0;                            % ����ֵ֮һ
cita=0;                          % ����ֵ֮һ
r=sqrt((X(1)-Station.x)^2+(X(3)-Station.y)^2);   % �۲�վ��Ŀ��֮��ľ���
cita=atan2(X(3)-Station.y,X(1)-Station.x);       % ���ع۲�ƫ���
value=[r,cita]';                    % ����ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ŀ��λ�ü����Ӻ��� pfun
function Xn=pfun(Z,Station)
x=Z(1)*cos(Z(2))+Station.x;
y=Z(1)*sin(Z(2))+Station.y;
vx=0;vy=0;
Xn=[x,vx,y,vy]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


