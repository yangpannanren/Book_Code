% �Ӻ������ܣ����ݴ������Ĺ۲���Ϣֱ�Ӽ���Ŀ���λ��
function P=pfun(X,x0,y0)
if length(X)>2
    error('Not enough input arguments.'); 
end
x=x0+X(1)*cos(X(2)); 
y=y0+X(1)*sin(X(2)); 
P=[x,y]';
