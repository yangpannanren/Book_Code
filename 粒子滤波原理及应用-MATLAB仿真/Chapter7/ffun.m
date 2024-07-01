%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明： 求目标位置函数
% 输入参数： 观测站一次观测值x,观测站的位置（x0,y0)
% 输出参数： 目标的位置信息
function [y]=ffun(x,x0,y0)
if nargin < 3
    error('Not enough input arguments.');
end
[row,col]=size(x);
if row~=2|col~=1
    error('Input arguments error!');
end
y=zeros(2,1);
y(1)=x(1)*cos(x(2))+x0;
y(2)=x(1)*sin(x(2))+y0;