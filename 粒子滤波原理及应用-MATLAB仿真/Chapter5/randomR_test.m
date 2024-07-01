%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 随机采样测试程序
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function randomR_test
% N=10; %粒子数
A=[2,8,2,7,3,5,5,1,4,6]; %感兴趣的读者可以用rand函数产生
% IndexA=1:N;  %A中各数值的索引，其实这个可有可无
W=A./sum(A);  %根据数值大小分布权值
% 这里只要输入A的索引和权重，就可以返回一个新的索引OutIndex
% 调用随机采样方法
OutIndex = randomR(W);
% OutIndex是一个索引向量，表征的含义是:
% 原来A中的数据权值大的被多次索引(复制)
NewA=A(OutIndex);
% 第二次迭代
W=NewA./sum(NewA);
OutIndex = randomR(W);
NewA2=NewA(OutIndex);
% 第三次迭代
W=NewA2./sum(NewA2);
OutIndex = randomR(W);
NewA3=NewA2(OutIndex);
% 画图直观显示区别
figure
subplot(2,1,1);
plot(A,'--ro','MarkerFace','g');
xlabel('粒子');ylabel('权值');
title('粒子初始权值')
subplot(2,1,2);
plot(NewA,'--ro','MarkerFace','g');
xlabel('粒子');ylabel('权值');
title('一次迭代粒子初始权值')
figure
subplot(2,1,1);
plot(NewA2,'--ro','MarkerFace','g');
xlabel('粒子');ylabel('权值');
title('两次迭代粒子初始权值')
subplot(2,1,2);
plot(NewA3,'--ro','MarkerFace','g');
xlabel('粒子');ylabel('权值');
title('三次迭代粒子初始权值')