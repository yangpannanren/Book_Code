% 观测函数子函数
function Z=hfun(X,x0,y0)
if length(X)<4
    error('Not enough input arguments.');
end
% 观测的角度信息
cita=atan2(X(3)-y0,X(1)-x0);
% 观测的距离信息
r=sqrt( (X(3)-y0)^2+(X(1)-x0)^2 );
Z=[r,cita]';