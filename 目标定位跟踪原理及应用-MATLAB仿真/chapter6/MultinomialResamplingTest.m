%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵��������ʽ�ز������Գ���
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MultinomialResamplingTest
rand('seed',1);
N=10;
W=rand(1,N);                    % �������һ�����������
W=W./sum(W)      % ��һ��
outIndex = multinomialR(W) % ���ö���ʽ�ز��������ӳ���
% �������������õ�������V������Ҫϸϸ�Ƚ�����W����������
V=W(outIndex)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ͼֱ����ʾ����
figure
subplot(2,1,1);
plot(W','--ro','MarkerFace','b');
xlabel('index');ylabel('Value of W');
subplot(2,1,2);
plot(V','--ro','MarkerFace','b');
xlabel('index');ylabel('Value of V');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����ʽ�ز����Ӻ���
function outIndex = multinomialR(q);
% �������q��һ��1��N��Ȩֵ����
% �������outIndex��q�б�����Ԫ�ص���������
N=length(q);    % �õ�Ȩֵ����q��ά��
N_babies= zeros(1,N);
CS= cumsum(q);     % ��Ȩֵ�������ۼӺ�
% fliplr�Ƿ�ת������cumprod���ۻ����˺�����������help�²鿴�������
u = fliplr(cumprod(rand(1,N).^(1./(N:-1:1)))); 
j=1;
for i=1:N
    while u(i)>CS(j)
        j=j+1;
    end
    N_babies(j)=N_babies(j)+1;
end;
index=1;
for i=1:N
    if N_babies(i)>0
        for j=index:index+N_babies(i)-1
            outIndex(j) = i;
        end;
    end;
    index= index+N_babies(i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

