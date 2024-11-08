%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：硬币投掷实验，计算机模拟
% Fig.4-2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function coin_tossing_simulation
% 正面朝上的概率
p=0.5;
% 试验次数
N=1000;
% sum用于统计正面朝上的次数
sum=0;
% 现在开始模拟投掷过程
for k=1:N
    % 第k次试验，binornd()函数产生一个随机数
    sum=sum+binornd(1,p);
    % 计算第k次实验时，它的频率做如下统计
    P(k)=sum/k;
end
% 画图显示各次实验的结果
figure
hold on;box on;
plot(1:N,P);
xlabel('k');ylabel('出现正面的概率');
title('投掷硬币实验结果')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%