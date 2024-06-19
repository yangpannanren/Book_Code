function qam16=QAM16_mod(bitseq,N)

bitseq = bitseq(:).';
QAM_table =[-3+3i, -1+3i, 3+3i, 1+3i, -3+1i, -1+1i, 3+1i, 1+1i,-3-3i, -1-3i, 3-3i, 1-3i, -3-1i, -1-1i, 3-1i, 1-1i]/sqrt(10);
if nargin<2
    N=floor(length(bitseq)/4);
end
for n=1:N
    qam16(n) = QAM_table(bitseq(4*n-[3 2 1])*[8;4;2]+bitseq(4*n)+1);
end