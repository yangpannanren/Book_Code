%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 状态方程函数
function [y] = ffun(x,t)
% 输入少于2个参数，给出错误提示
if nargin < 2
    error('Not enough input arguments.');
end
% 状态方程
beta = 0.5;
y = 1 + sin(4e-2*pi*t) + beta*x;