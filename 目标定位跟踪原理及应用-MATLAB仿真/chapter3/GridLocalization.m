%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����ܣ�����λ�㷨����
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GridLocalization
Length=100;  % ���ؿռ䣬��λ����
Width=100;   % ���ؿռ䣬��λ����
Xnum=5;      % �۲�վ��ˮƽ����ĸ���
Ynum=5;      % �۲�վ�ڴ�ֱ����ĸ���
divX=Length/Xnum/2;divY=Width/Ynum/2; %  Ϊ�����м�鿴�۲�վ�ֲ�������
d=50;        % Ŀ����۲�վ20�����ڶ���̽�⵽����֮����
% Ŀ����������ڳ�����
Target.x=Width*(Xnum-1)/Xnum*rand;
Target.y=Length*(Ynum-1)/Ynum*rand;
DIST=[]; % ���ù۲�վ��Ŀ��֮�����ļ���
for j=1:Ynum % �۲�վ��������
for i=1:Xnum
        Station((j-1)*Xnum+i).x=(i-1)*Length/Xnum;
        Station((j-1)*Xnum+i).y=(j-1)*Width/Ynum;
        dd=getdist(Station((j-1)*Xnum+i),Target);
        DIST=[DIST dd];
    end
end
% �ҳ�̽�⵽Ŀ���ź���ǿ��3���۲�վ��Ҳ������Ŀ������Ĺ۲�վ
[set,index]=sort(DIST);  % setΪ���кõĴ�С�������ֵ���ϣ�indexΪ��������
NI=index(1:3); % �����3������index1-3��Ԫ��
Est_Target.x=0;Est_Target.y=0;
if set(NI(3))<d % ���3��������Ǹ����Ƿ��ڹ۲�վ��̽����뷶Χ֮��
    for i=1:3
        Est_Target.x=Est_Target.x+Station(NI(i)).x/3;
        Est_Target.y=Est_Target.y+Station(NI(i)).y/3;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure % ��ͼ
hold on;box on;axis([0-divX,Length-divX,0-divY,Width-divX])
xx=[Station(NI(1)).x,Station(NI(2)).x,Station(NI(3)).x];
yy=[Station(NI(1)).y,Station(NI(2)).y,Station(NI(3)).y];
fill(xx,yy,'y');
for j=1:Ynum
    for i=1:Xnum
        h1=plot(Station((j-1)*Xnum+i).x,Station((j-1)*Xnum+i).y,'-ko','MarkerFace','g');
        text(Station((j-1)*Xnum+i).x+1,Station((j-1)*Xnum+i).y,num2str((j-1)*Xnum+i));
    end
end
Error_Est=getdist(Est_Target,Target)
h2=plot(Target.x,Target.y,'k^','MarkerFace','b','MarkerSize',10);
h3=plot(Est_Target.x,Est_Target.y,'ks','MarkerFace','r','MarkerSize',10);
legend([h1,h2,h3],'Observation Station','Target Postion','Estimate Postion');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �Ӻ��������������ľ���
function dist=getdist(A,B)
dist=sqrt( (A.x-B.x)^2+(A.y-B.y)^2 );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

