%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����ܣ����Ķ�λ�㷨����
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CentroidLocalization % ���Ķ�λ�㷨
% ��λ��ʼ��
Length=100;   % ���ؿռ䣬��λ����
Width=100;   % ���ؿռ䣬��λ����
d=50;        % Ŀ����۲�վ50�����ڶ���̽�⵽����֮����
N=6;         % �۲�վ�ĸ���
for i=1:N      % �۲�վ��λ�ó�ʼ��������λ�������������
    Node(i).x=Width*rand;
    Node(i).y=Length*rand;
end
% Ŀ��ĳ����ڼ�ⳡ�ص���ʵλ�ã�����Ҳ�������
Target.x=Width*rand;
Target.y=Length*rand;
X=[]; % ��ʼ�����ҳ���̽�⵽Ŀ��Ĺ۲�վ��λ�ü���
for i=1:N      % �۲�վ��λ�ó�ʼ��������λ�������������
    Node(i).x=Width*rand;
    Node(i).y=Length*rand;
end
% Ŀ��ĳ����ڼ�ⳡ�ص���ʵλ�ã�����Ҳ�������
Target.x=Width*rand;
Target.y=Length*rand;
X=[]; % ��ʼ�����ҳ���̽�⵽Ŀ��Ĺ۲�վ��λ�ü���
for i=1:N
    if getDist(Node(i),Target)<=d  % ���ü�������Ӻ���
        X=[X;Node(i).x,Node(i).y]; % ����̽�⵽Ŀ��Ĺ۲�վλ��
    end
end
M=size(X,1);   % ̽�⵽Ŀ��Ĺ۲�վ����
if M>0
    Est_Target.x=sum(X(:,1))/M;  % �����㷨����λ��x
    Est_Target.y=sum(X(:,2))/M;  % �����㷨����λ��y
    Error_Dist=getDist(Est_Target,Target)  % Ŀ����ʵλ�������λ�õ�ƫ�����
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure  % ��ͼ
hold on;box on;axis([0 100 0 100]); % ���ͼ�εĿ��
for i=1:N  % ���۲�վ
    h1=plot(Node(i).x,Node(i).y,'ko','MarkerFace','g','MarkerSize',10);
    text(Node(i).x+2,Node(i).y,['Node ',num2str(i)]);
end
% ��Ŀ�����ʵλ�ú͹���λ��
h2=plot(Target.x,Target.y,'k^','MarkerFace','b','MarkerSize',10);
h3=plot(Est_Target.x,Est_Target.y,'ks','MarkerFace','r','MarkerSize',10);
% ������λ������ʵλ������������
line([Target.x,Est_Target.x],[Target.y,Est_Target.y],'Color','k');
% ����Ŀ�귽Բd�ķ�Χ
circle(Target.x,Target.y,d);
% ����h1,h2,h3����ʲô
legend([h1,h2,h3],'Observation Station','Target Postion','Estimate Postion');
xlabel(['error=',num2str(Error_Dist),'m']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������������Ӻ���
function dist=getDist(A,B)
dist=sqrt( (A.x-B.x)^2+(A.y-B.y)^2 );
% ��Բ�Ӻ���
function circle(x0,y0,r)
sita=0:pi/20:2*pi;
plot(x0+r*cos(sita),y0+r*sin(sita)); % ������(x0,y0�����뾶Ϊr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
