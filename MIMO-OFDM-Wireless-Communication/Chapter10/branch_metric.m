function metric = branch_metric(sig,q_test,ch_coefs)
[n,m]=size(ch_coefs);
[q_dim,~]=size(q_test);
sig=repmat(sig,q_dim,1);
outsum=0;
for j=1:m %External summation
    insum=0;
    for i= 1:n %Internal summation
        insum1=ch_coefs(i,j).*q_test(:,i);
        insum=insum+insum1;
    end
    outsum1=abs(sig(:,j)-insum).^2;
    outsum=outsum+outsum1;
end
metric=outsum;