%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 观测方程函数
function [y] = hfun(x,t)
 % 输入少于2个参数，给出错误提示
if nargin < 2
    error('Not enough input arguments.');
end
% 观测方程
if t<=30
    y = (x.^(2))/5;
else
    y = -2 + x/2;
end