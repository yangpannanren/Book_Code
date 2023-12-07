%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����ܣ�˫վ�۲�Ŀ�궨λ����
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DoubleStationEstimate
% ��һ������λ��ʼ��
Length=100;  % ���ؿռ䣬��λ����
Width=100;   % ���ؿռ䣬��λ����
Node_number=2; % �����۲�վ
Q=5e-4; % �Ƕȹ۲ⷽ��
% �����۲�վ֮��ľ���
dd=20;
Node(1).x=0;Node(1).y=0;
Node(2).x=dd;Node(2).y=0;
% Ŀ�����ʵλ�ã������������
Target.x=Width*rand;
Target.y=Length*rand;
% �ڶ��������۲�վ��Ŀ��̽��Ƕ�
Z=[];
for i=1:Node_number
    % ��ȡ�۲�Ƕ�
    Z(i)=atan2(Target.y-Node(i).y,Target.x-Node(i).x);
    % ����������������ʵ�����
    Z(i)=Z(i)+sqrt(Q)*randn;
end
% �����������ݹ۲�Ƕȣ�����С���˷�����Ŀ�����λ��
H=[tan(Z(1)),-1;tan(Z(2)),-1];
b=[0,dd*tan(Z(2))]';
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
