%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����ܣ�RSSI��λ�㷨����
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RssiEstimate
% ��һ������λ��ʼ��
Length=100;  % ���ؿռ䣬��λ����
Width=100;   % ���ؿռ䣬��λ����
Node_number=3;  % �۲�վ�ĸ��������ٱ���Ҫ3��
for i=1:Node_number % �۲�վ��λ�ó�ʼ��������λ�������������
    Node(i).x=Width*rand; 
    Node(i).y=Length*rand;
    Node(i).D=Node(i).x^2+Node(i).y^2;  % �̶���������λ�ù���
end
% Ŀ�����ʵλ�ã�����Ҳ�������
Target.x=Width*rand;
Target.y=Length*rand;
% �ڶ��������۲�վ��Ŀ��̽��10�Σ������ƽ��ֵ��Ϊ����RSSIֵ
Z=[];   %  ���۲�վ�ɼ�10��RSSI
for i=1:Node_number
    for t=1:10 % 10�β���
        [d]=DIST(Node(i),Target);  % �۲�վ��Ŀ�����ʵ����
        % ����Ϊdʱ���õ���RSSI����ֵ
        Z(i,t)=GetRssiValue(d)
    end
end
%  ��10�ι۲��ƽ��ֵ
ZZ=[];
for i=1:Node_number
    ZZ(i)=sum(Z(i,:))/10;
end
% �����������ݲ�����RSSIֵ����۲����
Zd=[]; % ����RSSI����õ��ľ���
for i=1:Node_number
    Zd(i)=GetDistByRssi(ZZ(i));
end
% ���Ĳ������ݹ۲���룬����С���˷�����Ŀ�����λ��
H=[];
b=[];
for i=2:Node_number
    %  ���չ�ʽ���߲�෨��ʽ
    H=[H;2*(Node(i).x-Node(1).x),2*(Node(i).y-Node(1).y)];  
    b=[b;Zd(1)^2-Zd(i)^2+Node(i).D-Node(1).D];  
end
Estimate=inv(H'*H)*H'*b;  % Ŀ��Ĺ���λ��
Est_Target.x=Estimate(1);Est_Target.y=Estimate(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ͼ
figure
hold on;box on;axis([0 120 0 120]); % ���ͼ�εĿ��
for i=1:Node_number
    h1=plot(Node(i).x,Node(i).y,'ko','MarkerFace','g','MarkerSize',10);
    text(Node(i).x+2,Node(i).y,['Node ',num2str(i)]);
end
h2=plot(Target.x,Target.y,'k^','MarkerFace','b','MarkerSize',10);
h3=plot(Est_Target.x,Est_Target.y,'ks','MarkerFace','r','MarkerSize',10);
line([Target.x,Est_Target.x],[Target.y,Est_Target.y],'Color','k');
legend([h1,h2,h3],'Observation Station','Target Postion','Estimate Postion');
[Error_Dist]=DIST(Est_Target,Target);
xlabel(['error=',num2str(Error_Dist),'m']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �Ӻ��������������ľ���
function [dist]=DIST(A,B)
dist=sqrt((A.x-B.x)^2+(A.y-B.y)^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �Ӻ������۲����Ϊdʱ�������õ�RSSI
function value=GetRssiValue(d)
% ������Ϊdʱ������ϵͳ����һ����ʵ�ʾ������Ӧ�ķ���ֵ
A=-42;  % ע��A��n�ڲ�ͬӲ��ϵͳȡֵ�ǲ�һ����
n=2;
value=A-10*n*log10(d);
% ʵ�ʲ���ֵ���ܵ���������Ⱦ�ģ�����ٶ���������Q�ǳ���
% ��ΪRSSI�ĸ����Ƿǳ���
Q=5;
value=value+sqrt(Q)*randn; % ʵ�ʹ۲����Ǵ��������ģ����������ģ����ʵ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �Ӻ���������RSSI����õ�����d
function value=GetDistByRssi(rssi)
A=-42;  % ע��A��n�ڲ�ͬӲ��ϵͳȡֵ�ǲ�һ����
n=2;
value=10^((A-rssi)/10/n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
