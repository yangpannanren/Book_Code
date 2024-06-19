function CCDF=CCDF_PTS(N,Nos,Nsb,b,dBs,Nblk)
% CCDF of PTS (Partial Transmit Sequence) technique.
% N    : Number of Subcarriers
% Nos  : Oversampling factor
% Nsb  : Number of subblocks
% b    : Number of bits per QAM symbol
% dBs  : dB vector
% Nblk : Number of OFDM blocks for iteration

NNos=N*Nos;                       % FFT size
M=2^b;
Es=1;
A=sqrt(3/2/(M-1)*Es); % Normalization factor for M-QAM
for nblk=1:Nblk
    w = ones(1,Nsb);       % Phase (weight) factor
    mod_sym = A*qammod(randi([0,M-1],1,N),M); % 2^b-QAM
    [Nr,Nc] = size(mod_sym);
    zero_pad_sym = zeros(Nr,Nc*Nos);
    for k=1:Nr                       % zero padding for oversampling
        zero_pad_sym(k,1:Nos:Nc*Nos) = mod_sym(k,:);
    end
    sub_block=zeros(Nsb,NNos);
    for k=1:Nsb  % Eq.(7.27) Disjoint Subblock Mapping
        kk = (k-1)*NNos/Nsb+1:k*NNos/Nsb;
        sub_block(k,kk) = zero_pad_sym(1,kk);
    end
    ifft_sym=ifft(sub_block.',NNos).';  % IFFT
    % --  Phase Factor Optimization  -- %
    for m=1:Nsb
        x = w(1:Nsb)*ifft_sym; % Eq.(7.27)
        sym_pow = abs(x).^2;
        PAPR = max(sym_pow)/mean(sym_pow);
        if m==1
            PAPR_min = PAPR;
        else
            if PAPR_min<PAPR
                w(m)=1;
            else
                PAPR_min = PAPR;
            end
        end
        w(m+1)=-1;
    end
    x_tilde = w(1:Nsb)*ifft_sym; % Eq.(7.29) : The lowest PAPR symbol
    sym_pow = abs(x_tilde).^2; % Symbol power
    PAPRs(nblk) = max(sym_pow)/mean(sym_pow);
end
PAPRdBs=10*log10(PAPRs); % measure PAPR
dBcs = dBs + (dBs(2)-dBs(1))/2;   % dB midpoint vector
count=0;
N_bins=hist(PAPRdBs,dBcs);
for i=length(dBs):-1:1
    count=count+N_bins(i);
    CCDF(i)=count/Nblk;
end