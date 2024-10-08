%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：复杂概率模拟实验
% Fig.4-6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function complex_probabilistic_simulation
P=0.5;
N=2000; %试验次数
fun(P,N);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fun(p,mm)
E=zeros(1,mm);
% 产生伯努利分布的随机数，1行mm列
randnum1 = binornd(1,p,1,mm);
randnum2 = unidrnd(6,1,mm);
% 初始化可能出现的结果，都为0
k1=0;
k2=0;
k3=0;
for i=1:mm
    if randnum1(i)==0
        k1=k1+1;                %没击中敌人火炮的射击总数
    else
        if randnum2(i)<=3
            k1=k1+1;            %没击中敌人火炮的射击总数
        elseif  randnum2(i)==6
            k3=k3+1;            %击中敌人两门火炮的射击总数
        else
            k2=k2+1;            %击中敌人一门火炮的射击总数
        end
    end
    E(i)=(k2+k3)/i;
end
% 画图显示
num=1:mm;
plot(num,E)
xlabel('k');ylabel('有效射击(毁伤一门炮或两门炮)的概率');
title('炮击模拟结果');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%