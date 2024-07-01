%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 子程序说明： 系统状态转移函数
function [y]=sfun(x,~,F)
if nargin < 2
    error('Not enough input arguments.');
end
y=F*x;