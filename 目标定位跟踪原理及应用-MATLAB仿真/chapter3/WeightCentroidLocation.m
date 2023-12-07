%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����ܣ���Ȩ���Ķ�λ�㷨����
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WeightCentroidLocation % ��Ȩ�����㷨
% ��λ��ʼ��
Length=100;  % ���ؿռ䣬��λ����
Width=100;   % ���ؿռ䣬��λ����
d=50;        % Ŀ����۲�վ50�����ڶ���̽�⵽����֮����
Node_number=6;  % �۲�վ�ĸ���
SNR=50;         %  ����ȣ���λdB
for i=1:Node_number % �۲�վ��λ�ó�ʼ��������λ�������������
    Node(i).x=Width*rand; 
    Node(i).y=Length*rand;
end
% Ŀ�����ʵλ�ã�����Ҳ�������
Target.x=Width*rand;
Target.y=Length*rand;
% �۲�վ̽��Ŀ��
X=[]; W=[];  % Ȩֵ
for i=1:Node_number
    dd=getdist(Node(i),Target);
    Q=dd/(10^(20/SNR)); %��������ȹ�ʽ������������
    if dd<=d
        X=[X;Node(i).x,Node(i).y];
        W=[W,1/((dd+sqrt(Q)*randn)^2)];% ��������ʽ��3-4������Ȩֵ���ź�˥����ʽ
    end
end
% Ȩֵ��һ��
W=W./sum(W)
N=size(X,1);   % ̽�⵽Ŀ��Ĺ۲�վ����
sumx=0;sumy=0;
for i=1:N
    sumx=sumx+X(i,1)*W(i); 
    sumy=sumy+X(i,2)*W(i);
end
Est_Target.x=sumx;  % Ŀ�����λ��x
Est_Target.y=sumy;  % Ŀ�����λ��y
Error_Dist=getdist(Est_Target,Target)  % Ŀ����ʵλ�������λ�õ�ƫ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure % ��ͼ
hold on;box on;axis([0 100 0 100]); % ���ͼ�εĿ��
for i=1:Node_number
    h1=plot(Node(i).x,Node(i).y,'ko','MarkerFace','g','MarkerSize',10);
    text(Node(i).x+2,Node(i).y,['Node ',num2str(i)]);
end
h2=plot(Target.x,Target.y,'k^','MarkerFace','b','MarkerSize',10);
h3=plot(Est_Target.x,Est_Target.y,'ks','MarkerFace','r','MarkerSize',10);
line([Target.x,Est_Target.x],[Target.y,Est_Target.y],'Color','k');
circle(Target.x,Target.y,d);
legend([h1,h2,h3],'Observation Station','Target Postion','Estimate Postion');
xlabel(['error=',num2str(Error_Dist),'m']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �Ӻ��������������ľ���
function dist=getdist(A,B)
dist=sqrt( (A.x-B.x)^2+(A.y-B.y)^2 );
% �Ӻ����� ��Ŀ��Ϊ���Ļ�Բ
function circle(x0,y0,r)
sita=0:pi/20:2*pi;
plot(x0+r*cos(sita),y0+r*sin(sita)); % ������(x0,y0�����뾶Ϊr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
