 clear all;
counts = [99 1]; 
len = 1000;	
seq = randsrc(1,len,[1 2; .99 .01]);          % 随机序列
code = arithenco(seq,counts);              %编码
dseq = arithdeco(code,counts,length(seq)); % 解码
isequal(seq,dseq) % 检查dseq是否与原序列seq一致
