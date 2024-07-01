%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 系统重采样子函数
% 输入参数:weight为原始数据对应的权重大小
% 输出参数:outIndex是根据weight筛选和复制的结果
function outIndex = systematicR(inIndex,wn)
if nargin < 2
    error('Not enough input arguments.');
end
wn=wn';
[~,N] = size(wn);
N_children=zeros(1,N);
label=1:1:N;
s=1/N;
li=0;
T=s*rand(1);
j=1;
Q=0;
u=rand(1,N);
while (T<1)
    if (Q>T)
        T=T+s;
        N_children(1,li)=N_children(1,li)+1;
    else
        i=fix((N-j+1)*u(1,j))+j;
        auxw=wn(1,i);
        li=label(1,i);
        Q=Q+auxw;
        wn(1,i)=wn(1,j);
        label(1,i)=label(1,j);
        j=j+1;
    end
end
index=1;
for i=1:N
    if (N_children(1,i)>0)
        for j=index:index+N_children(1,i)-1
            outIndex(j) = inIndex(i);
        end
    end
    index= index+N_children(1,i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%