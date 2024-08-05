function CCDF=CCDF_OFDMA(N,Nos,b,dBs,Nblk)
% CCDF of OFDM signal with no PAPR reduction technique.
% N    : Number of total subcarriers (256 by default)
% Nos  : Oversampling factor (4 by default)
% b    : Number of bits per QAM symbol
% dBs  : dB vector
% Nblk : Number of OFDM blocks for nblkation

NNos = N*Nos;
M=2^b;
Es=1;
A=sqrt(3/2/(M-1)*Es); % Normalization factor for M-QAM
for nblk=1:Nblk
    mod_sym = A*qammod(randi([0,M-1],1,N),M);
    [Nr,Nc]=size(mod_sym);
    zero_pad_sym=zeros(Nr,Nc*Nos);
    for k=1:Nr          % zero padding for oversampling
        zero_pad_sym(k,1:Nos:Nc*Nos)=mod_sym(k,:);
    end
    ifft_sym=ifft(zero_pad_sym,NNos);
    sym_pow=abs(ifft_sym).^2;
    mean_pow(nblk)=mean(sym_pow);
    max_pow(nblk)=max(sym_pow);
end
PAPR=max_pow./mean_pow;
PAPRdB=10*log10(PAPR); % measure PAPR
dBcs = dBs + (dBs(2)-dBs(1))/2;   % dB midpoint vector
count = 0;
N_bins = hist(PAPRdB,dBcs);
for i=length(dBs):-1:1
    count = count+N_bins(i);
    CCDF(i) = count/Nblk;
end