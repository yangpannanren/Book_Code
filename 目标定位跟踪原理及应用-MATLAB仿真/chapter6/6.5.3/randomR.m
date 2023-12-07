%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明：随机采样子程序
% 说明：
% 请参照黄小平等编著的《目标定位跟踪原理及仿真-MATLAB仿真》，电子工业出版社
% 静心研读纸质版的书籍，有助于您理解算法原理
% 作者：放牛娃
% 联系：hxping@mail.ustc.edu.cn
% 时间：2019年1月12日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outIndex = randomR(inIndex,q)
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
