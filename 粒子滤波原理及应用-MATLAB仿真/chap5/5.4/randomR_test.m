%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��Ȩ������
%     ���������ϸ����ע����ο�
%     ��Сƽ�����ң�������.�����˲�ԭ��Ӧ��[M].���ӹ�ҵ�����磬2017.4
%     ������ԭ�����+����+����+����ע��
%     ����˳����д��������ʾ�޸�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������Գ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function randomR_test
error('����Ĳ���N��ο����е�ֵ���ã�Ȼ��ɾ�����д���')
N=0;                          
A=[2,8,2,7,3,5,5,1,4,6];            
IndexA=1:N                
W=A./sum(A)                   

 
OutIndex = randomR(W)
 
NewA=A(OutIndex)

 
W=NewA./sum(NewA)
OutIndex = randomR(W)
NewA2=NewA(OutIndex)

 
W=NewA2./sum(NewA2)
OutIndex = randomR(W)
NewA3=NewA2(OutIndex)
             
                              
figure
subplot(2,1,1);
plot(A,'--ro','MarkerFace','g');
axis([1,N,1,N])
subplot(2,1,2);
plot(NewA,'--ro','MarkerFace','g');
axis([1,N,1,N])
 
function outIndex = randomR(weight)
 
L=length(weight)
 
outIndex=zeros(1,L)
 
u=unifrnd(0,1,1,L)
u=sort(u)
 
cdf=cumsum(weight)

 
i=1;
for j=1:L
 
    while (i<=L) & (u(i)<=cdf(j))
 
        outIndex(i)=j;
 
        i=i+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
