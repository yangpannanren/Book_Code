% compare_DFT_spreading.m
% compare PAPR of OFDMA/LFDMA/IFDMA
% Plot Fig. 7.31
clear; close all; clc;
N=256; Nd=64; % FFT size and Data block size (# of subcarriers per user)
gss='*^<sd>v.'; % Graphic symbols
bs=[2 4 6];
N_b=length(bs);
dBs = 0:0.2:12;
dBcs = dBs+(dBs(2)-dBs(1))/2;
Nblk = 5000; % Number of OFDM blocks for iteration
rng(0);
for i=1:N_b
    b=bs(i);
    M=2^b;
    CCDF_OFDMa = CCDF_PAPR_DFTspreading('OF',N,b,N,dBcs,Nblk); % CCDF of OFDMA
    CCDF_LFDMa = CCDF_PAPR_DFTspreading('LF',Nd,b,N,dBcs,Nblk); % CCDF of LFDMA
    CCDF_IFDMa = CCDF_PAPR_DFTspreading('IF',Nd,b,N,dBcs,Nblk); % CCDF of IFDMA
    figure
    semilogy(dBs,CCDF_OFDMa,'-o', dBs,CCDF_LFDMa,'-<', dBs,CCDF_IFDMa,'-*')
    legend('OFDMA','LFDMA','IFDMA')
    axis([dBs([1 end]) 1e-3 1]); grid on;
    title([num2str(M) '-QAM CCDF ',num2str(N),'-point ',num2str(Nblk) '-blocks']);
    xlabel(['PAPR_0[dB] for ',num2str(M),'-QAM']); ylabel('Pr(PAPR>PAPR_0)');
end