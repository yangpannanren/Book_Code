%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵����ϵͳ�ز������Գ���
% ˵����
% ����ջ�Сƽ�ȱ����ġ�Ŀ�궨λ����ԭ������-MATLAB���桷�����ӹ�ҵ������
% �����ж�ֽ�ʰ���鼮��������������㷨ԭ��
% ���ߣ���ţ�� 
% ��ϵ��hxping@mail.ustc.edu.cn
% ʱ�䣺2019��1��12��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SystematicResamplingTest
rand('seed',1)
N=10;
W=rand(1,N);                     % �������һ�����������
W=W./sum(W)      % ��һ��
outIndex = systematicR(W) % ����ϵͳ�ز�������
% �������������õ�������V������Ҫϸϸ�Ƚ�����W����������
V=W(outIndex)
% ��ͼֱ����ʾ����
figure
subplot(2,1,1);
plot(W','--ro','MarkerFace','g');
xlabel('index');ylabel('Value of W');
subplot(2,1,2);
plot(V','--ro','MarkerFace','g');
xlabel('index');ylabel('Value of V');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outIndex = systematicR(wn);
N=length(wn);  % �õ������ά��
N_babies=zeros(1,N);
label=1:N;
s=1/N;auxw=0;auxl=0;li=0; % ��ʼ��
T=s*rand(1);
j=1;Q=0;i=0;  % ��ʼ�����̱���
u=rand(1,N);  % ����һ�������
while (T<1)
    if (Q>T)
        T=T+s;
        N_babies(li)=N_babies(li)+1;
    else
        i=fix((N-j+1)*u(j))+j;
        auxw=wn(i);
        li=label(i);
        Q=Q+auxw;
        wn(i)=wn(j);
        label(i)=label(j);
        j=j+1;
    end
end
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
