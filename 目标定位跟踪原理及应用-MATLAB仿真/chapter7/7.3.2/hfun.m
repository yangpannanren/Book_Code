% �۲⺯���Ӻ���
function Z=hfun(X,x0,y0)
if length(X)<4
    error('Not enough input arguments.'); 
end
% �۲�ĽǶ���Ϣ
cita=atan2(X(3)-y0,X(1)-x0); 
% �۲�ľ�����Ϣ
r=sqrt( (X(3)-y0)^2+(X(1)-x0)^2 );
Z=[r,cita]';
