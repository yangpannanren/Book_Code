function y=zero_pasting(x)
% Paste zero in the center of half of the input sequence x
N=length(x);
M=ceil(N/4);
y=[x(1:M) zeros(1,N/2) x(N-M+1:N)];
end