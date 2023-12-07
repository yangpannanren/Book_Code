%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：残差重采样测试程序
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ResidualResamplingTest
rand('seed',1)
N=20;
W=rand(1,N);                     % 任意给定一组随机数样本
W=W./sum(W)      % 归一化
outIndex = residualR(W) % 调用残差重采样方法
% 经过随机采样后得到的样本V，读者要细细比较它与W样本的区别
V=W(1,outIndex)
% 画图直观显示区别
figure
subplot(2,1,1);
plot(W','--ro','MarkerFace','g');
xlabel('index');ylabel('Value of W');
subplot(2,1,2);
plot(V','--ro','MarkerFace','g');
xlabel('index');ylabel('Value of V');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outIndex = residualR(q)
N= length(q);
N_babies= zeros(1,N);
q_res = N.*q;
N_babies = fix(q_res);
N_res=N-sum(N_babies);
if (N_res~=0)
    q_res=(q_res-N_babies)/N_res;
    cumDist= cumsum(q_res);
    u = fliplr(cumprod(rand(1,N_res).^(1./(N_res:-1:1))));
    j=1;
    for i=1:N_res
        while (u(1,i)>cumDist(1,j))
            j=j+1;
        end
        N_babies(1,j)=N_babies(1,j)+1;
    end;
end;
index=1;
for i=1:N
    if (N_babies(1,i)>0)
        for j=index:index+N_babies(1,i)-1
            outIndex(j) = i;
        end;
    end;
    index= index+N_babies(1,i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
