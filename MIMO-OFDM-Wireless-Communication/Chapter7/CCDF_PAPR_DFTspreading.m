function [CCDF,PAPRs]=CCDF_PAPR_DFTspreading(fdma_type,Ndb,b,N,dBcs,Nblk,psf,Nos)
% fdma_type: 'ofdma'/'ifdma'(interleaved)/'lfdma'(localized)
% Ndb   : Data block size
% b     : Number of bits per symbol
% N     : FFT size
% dBcs  : dB vector
% Nblk  : Number of OFDM blocks for iteration
% psf   : Pulse shaping filter coefficient vector
% Nos   : Oversampling factor

M=2^b;
Es=1;
A=sqrt(3/2/(M-1)*Es); % Normalization factor for QAM
S=N/Ndb; % Spreading factor
for iter=1:Nblk
    mod_sym = A*qammod(randi([0,M-1],1,Ndb),M);
    switch upper(fdma_type(1:2))
        case 'IF'
            fft_sym = zero_insertion(fft(mod_sym,Ndb),N/Ndb); % IFDMA
        case 'LF'
            fft_sym = [fft(mod_sym,Ndb) zeros(1,N-Ndb)]; % LFDMA
        case 'OF'
            fft_sym = zero_insertion(mod_sym,S); % Oversampling, No DFT spreading
        otherwise
            fft_sym = mod_sym; % No oversampling, No DFT spraeding
    end
    ifft_sym = ifft(fft_sym,N);       % IFFT
    if nargin>7
        ifft_sym = zero_insertion(ifft_sym,Nos);
    end
    if nargin>6
        ifft_sym = conv(ifft_sym,psf);
    end
    sym_pow = ifft_sym.*conj(ifft_sym); % measure symbol power
    PAPRs(iter) = max(sym_pow)/mean(sym_pow); % measure PAPR
end
% CCDF of OFDMA signals using DFT spread spectrum technology
PAPRdBs = 10*log10(PAPRs); % measure PAPR
N_bins = hist(PAPRdBs,dBcs);
count = 0;
for i=length(dBcs):-1:1
    count = count+N_bins(i);
    CCDF(i) = count/Nblk;
end


function y=zero_insertion(x,M,N)

[Nrow,Ncol]=size(x);
if nargin<3
    N=Ncol*M;
end
y=zeros(Nrow,N);
y(:,1:M:N) = x;