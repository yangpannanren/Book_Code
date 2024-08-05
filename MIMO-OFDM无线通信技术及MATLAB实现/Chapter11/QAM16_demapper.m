function [s] =QAM16_demapper(qam16,N)

if nargin<2
    N = length(qam16);
end
QAM_table = [-3+3i, -1+3i, 3+3i, 1+3i,...
    -3+1i, -1+1i, 3+1i, 1+1i,...
    -3-3i, -1-3i, 3-3i, 1-3i,...
    -3-1i, -1-1i, 3-1i, 1-1i]/sqrt(10);
temp = [];
for n=0:N-1
    temp=[temp dec2bin(find(QAM_table==qam16(n+1))-1,4)];
end
for n=1:length(temp)
    s(n)=bin2dec(temp(n));
end