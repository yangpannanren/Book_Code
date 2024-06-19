function [X_bits]=QAM16_slicer_soft(X)

QAM_table=[-3-3j, -3-j, -3+3j, -3+j, -1-3j, -1-j, -1+3j, -1+j, 3-3j, ...
    3-j, 3+3j, 3+j, 1-3j, 1-j, 1+3j, 1+j]/sqrt(10);
X_temp=dec2bin(find(QAM_table==X)-1,4);
for i=1:length(X_temp)
    X_bits(i) = bin2dec(X_temp(i));
end