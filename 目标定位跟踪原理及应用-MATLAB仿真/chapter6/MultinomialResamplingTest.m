%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：多项式重采样测试程序
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MultinomialResamplingTest
rand('seed',1);
N=10;
W=rand(1,N);                    % 任意给定一组随机数样本
W=W./sum(W)      % 归一化
outIndex = multinomialR(W) % 调用多项式重采样方法子程序
% 经过随机采样后得到的样本V，读者要细细比较它与W样本的区别
V=W(outIndex)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 画图直观显示区别
figure
subplot(2,1,1);
plot(W','--ro','MarkerFace','b');
xlabel('index');ylabel('Value of W');
subplot(2,1,2);
plot(V','--ro','MarkerFace','b');
xlabel('index');ylabel('Value of V');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 多项式重采样子函数
function outIndex = multinomialR(q);
% 输入参数q是一个1×N的权值数组
% 输出参数outIndex是q中被复制元素的索引集合
N=length(q);    % 得到权值数组q的维数
N_babies= zeros(1,N);
CS= cumsum(q);     % 对权值数组求累加和
% fliplr是翻转函数，cumprod是累积连乘函数，可以在help下查看相关内容
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

