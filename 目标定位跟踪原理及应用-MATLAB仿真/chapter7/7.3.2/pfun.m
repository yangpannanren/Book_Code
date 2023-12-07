% 子函数功能：根据带噪声的观测信息直接计算目标的位置
function P=pfun(X,x0,y0)
if length(X)>2
    error('Not enough input arguments.'); 
end
x=x0+X(1)*cos(X(2)); 
y=y0+X(1)*sin(X(2)); 
P=[x,y]';
