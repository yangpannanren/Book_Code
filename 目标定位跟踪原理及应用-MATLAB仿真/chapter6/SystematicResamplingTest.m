%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：系统重采样测试程序
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃 
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SystematicResamplingTest
rand('seed',1)
N=10;
W=rand(1,N);                     % 任意给定一组随机数样本
W=W./sum(W)      % 归一化
outIndex = systematicR(W) % 调用系统重采样方法
% 经过随机采样后得到的样本V，读者要细细比较它与W样本的区别
V=W(outIndex)
% 画图直观显示区别
figure
subplot(2,1,1);
plot(W','--ro','MarkerFace','g');
xlabel('index');ylabel('Value of W');
subplot(2,1,2);
plot(V','--ro','MarkerFace','g');
xlabel('index');ylabel('Value of V');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outIndex = systematicR(wn);
N=length(wn);  % 得到输入的维数
N_babies=zeros(1,N);
label=1:N;
s=1/N;auxw=0;auxl=0;li=0; % 初始化
T=s*rand(1);
j=1;Q=0;i=0;  % 初始化过程变量
u=rand(1,N);  % 产生一组随机数
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
