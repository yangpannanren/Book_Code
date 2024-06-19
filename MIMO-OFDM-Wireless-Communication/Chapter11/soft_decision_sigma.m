function [x4_soft] = soft_decision_sigma(x,h)

x=x(:).';
xr=real(x);
xi=imag(x);
X=[xr; 2-abs(xr);
    xi; 2-abs(xi)];
H=repmat(abs(h(:)).',4,1);
XH = X.*H;
x4_soft = XH(:).';