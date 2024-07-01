%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 多项式重采样测试程序
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function multinomialR_test
rng(1);
% N=10; %粒子
A=[2,8,2,7,3,5,5,1,4,6]; %感兴趣的读者可以用rand函数产生
% IndexA=1:N;  %A中各数值的索引，其实这个可有可无
W=A./sum(A); %根据数值大小分布权值
% 迭代次数
DiedaiNumber=6;
V=[];
% 不破坏原始数据，重新搞一组数据
AA=A;
WW=W;
for k=1:DiedaiNumber
    % 调用多项式重采样方法子程序
    outIndex = multinomialR(WW);
    % 经过随机采样后得到的样本AA，读者要细细比较它与原A样本的区别
    AA=AA(outIndex);
    % 重新计算权重
    WW=AA./sum(AA);
    % 保存到V中
    V=[V;AA];
end
% 画图直观显示区别
figure
subplot(2,1,1);
plot(A','--ro','MarkerFace','g');
xlabel('粒子');ylabel('权值');
title('粒子初始权值')
subplot(2,1,2);
plot(V(1,:)','--ro','MarkerFace','g');
xlabel('粒子');ylabel('权值');
title('多项式重采样后粒子权值')