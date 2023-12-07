%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：
% 单站多目标跟踪的建模程序，并用近邻法分类
% 主要模拟多目标的运动和观测过程，涉及融合算法---近邻法
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 随机采样子函数
function outIndex = randomR(inIndex,q)
if nargin < 2
    error('Not enough input arguments.'); 
end
outIndex=zeros(size(inIndex));
[num,col]=size(q);
u=rand(num,1);
u=sort(u);
l=cumsum(q);
i=1;
for j=1:num
    while (i<=num)&(u(i)<=l(j))
        outIndex(i)=j;
        i=i+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
