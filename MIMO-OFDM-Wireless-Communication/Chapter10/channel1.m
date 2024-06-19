function varargout = channel1(sig,SNRdB,NR)
ch_conf=[2 NR];
[N_frame,~,N_packets]=size(sig);
spowr = sum(abs(sig(:,1,1)))/N_frame;
sigma = sqrt(0.5*spowr*(10^(-SNRdB/10)));
sq2 = sqrt(2);
ch_coefs=(randn(ch_conf(1),ch_conf(2),N_packets) +...
    1i*randn(ch_conf(1),ch_conf(2),N_packets))/sq2 ;
ch_noise= sigma*(randn(N_frame,ch_conf(2),N_packets) +...
    j*randn(N_frame,ch_conf(2),N_packets));
for k = 1:N_packets
    sig_add(:,:,k) = sig(:,:,k)*ch_coefs(:,:,k);
end
sig_corr = (sig_add + ch_noise);
varargout = {sig_corr,ch_coefs};