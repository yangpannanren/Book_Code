%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 函数功能：      参数拟合a,b,c,d
% 非线性函数方程： Q(k)=a*exp(b*k)+c*exp(d*k)
% 其中Q(k),k通过Battery_Capacity文件给定
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [a,b,c,d]=para_fit(n)
% n是控制读取 Battery Capacity文件数据前n个数据
load Battery_Capacity

cftool(A3Cycle,A3Capacity)
cftool(A8Cycle,A8Capacity)
cftool(A5Cycle,A5Capacity)
cftool(A12Cycle,A12Capacity)