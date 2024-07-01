%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 多项式重采样子函数
% 输入参数:weight为原始数据对应的权重大小
% 输出参数:outIndex是根据weight筛选和复制的结果
function outIndex = multinomialR(weight)
Col=length(weight);
N_babies= zeros(1,Col);
% 计算粒子权重累积函数cdf
cdf= cumsum(weight);
% 产生[0,1]上均匀分布的随机数组
u=rand(1,Col);
% 求 u^(j^-1)次方
uu=u.^(1./(Col:-1:1));
% 如果A是一个向量，cumprod(A)将返回一个包含A各元素累积连乘的结果的向量，
% 元素个数与原向量相同。
ArrayTemp=cumprod(uu);
% fliplr(X)使矩阵x沿垂直轴左右翻转
u = fliplr(ArrayTemp);
j=1;
for i=1:Col
    % 此处跟随机采样相似
    while (u(i)>cdf(j))
        j=j+1;
    end
    N_babies(j)=N_babies(j)+1;
end
index=1;
for i=1:Col
    if (N_babies(i)>0)
        for j=index:index+N_babies(i)-1
            outIndex(j) = i;
        end
    end
    index= index+N_babies(i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%