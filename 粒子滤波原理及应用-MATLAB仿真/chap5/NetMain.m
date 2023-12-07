%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��Ȩ������
%     ���������ϸ����ע����ο�
%     ��Сƽ�����ң�������.�����˲�ԭ��Ӧ��[M].���ӹ�ҵ�����磬2017.4
%     ������ԭ�����+����+����+����ע��
%     ����˳����д��������ʾ�޸�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���Ӽ��ϰ뾶����
function NetMain

x0=5;
y0=5;
r1=2;
r2=4;
Net=4;  
error('����Ĳ���N��ο����е�ֵ���ã�Ȼ��ɾ�����д���')
N=0;  
for i=1:N
    X(i)=x0+sqrt(Net)*randn;
    Y(i)=y0+sqrt(Net)*randn;
end
 
figure
hold on;box on;
 
plot(X,Y,'k+');
 
plot(x0,y0,'ko','MarkerFaceColor','g')
 
sita=0:pi/20:2*pi;
plot(x0+r1*cos(sita),y0+r1*sin(sita),'Color','r','LineWidth',5);  
plot(x0+r2*cos(sita),y0+r2*sin(sita),'Color','b','LineWidth',5); 
axis([0,10,0,10]);
 
figure
support=-10:1:20
[range,domain]=hist(X,support);  
subplot(121)
plot(domain,range,'r-');
xlabel('X������')
ylabel('�ܶ�')
subplot(122)
[range,domain]=hist(Y,support);   
plot(domain,range,'b-');
xlabel('Y������')
ylabel('�ܶ�')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
