function [x_soft] = soft_output2x2(x)

sq10=sqrt(10);
sq10_2=2/sq10;
x=x(:).';
xr=real(x);
xi=imag(x);
X=sq10*[-xi; sq10_2-abs(xi); xr; sq10_2-abs(xr)];
x_soft = X(:).';