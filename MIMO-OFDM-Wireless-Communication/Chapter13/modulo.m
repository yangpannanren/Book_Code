function [y]=modulo(x,A)

temp_real=floor((real(x)+A)/(2*A));
temp_imag=floor((imag(x)+A)/(2*A));
y=x-temp_real*(2*A)-1i*temp_imag*(2*A);