% compare_DFT_spreading_w_psf.m
% To see the effect of pulse shaping using RC filter
% Fig.(7.32 & 7.33)
clear; close all; clc;
N=256; % FFT size,
Nd=64; % # of subcarriers per user (Data block size)
S = N/Nd; % Spreading factor
Nsym=6; % RC filter length
Nos=8; % Oversampling factor
rhos = 0:0.2:1; % Roll-off factors of RC filter for pulse shaping
bs=[2 4];  % Numbers of bits per QAM symbol
dBs = 0:0.2:10;
dBcs = dBs+(dBs(2)-dBs(1))/2;
Nblk = 50; % Number of OFDM blocks for iteration
% Nblk = 5000; % Number of OFDM blocks for iteration
gss='*^<sd>v.'; % Numbers of subblocks and graphic symbols
str11='IFDMA with no pulse shaping';
str12='LFDMA with no pulse shaping';
rng(0);
for i_b=1:length(bs)
    figure
    b=bs(i_b); % Number of bits per QAM symbol
    M=2^b;  % Alphabet size
    CCDF_IF0 = CCDF_PAPR_DFTspreading('IF',Nd,b,N,dBcs,Nblk);
    semilogy(dBs,CCDF_IF0,'k'), hold on
    CCDF_LF0 = CCDF_PAPR_DFTspreading('LF',Nd,b,N,dBcs,Nblk);
    semilogy(dBs,CCDF_LF0,'k-.')
    for i=1:length(rhos)
        rho = rhos(i); % Roll-off factor
        psf = rcosdesign(rho,Nsym,Nos,'normal')*Nos;  % RC filter coeff
        CCDF_IF = CCDF_PAPR_DFTspreading('IF',Nd,b,N,dBcs,Nblk,psf,Nos);
        CCDF_LF = CCDF_PAPR_DFTspreading('LF',Nd,b,N,dBcs,Nblk,psf,Nos);
        semilogy(dBs,CCDF_IF,['-' gss(i)], dBs,CCDF_LF,[':' gss(i)])
        str1(i,:)=sprintf('IFDMA with a=%3.1f',rho);
        str2(i,:)=sprintf('LFDMA with a=%3.1f',rho);
    end
    legend(str11,str12,str1(1,:),str2(1,:),str1(2,:),str2(2,:), ...
        str1(3,:),str2(3,:),str1(4,:),str2(4,:),'Location','best')
    grid on;
    title([num2str(M),'-QAM CCDF of IFDMA/LFDMA with pulse shaping depending on roll-off factor of RC filter']);
    xlabel(['PAPR_0[dB] for ' num2str(M) '-QAM']);  ylabel('Pr(PAPR>PAPR_0)');
end
figure
Nds=[4 8 32 64 128];
N_Nds=length(Nds);
b=6; rho = 0.4; Nos=2; % Number of bits per QAM symbol, Roll-off factor
psf = rcosdesign(rho,Nsym,Nos,'normal')*Nos;  % RC filter coeff
for i=1:N_Nds
    Nd=Nds(i);
    CCDF_LFDMa = CCDF_PAPR_DFTspreading('LF',Nd,b,N,dBcs,Nblk,psf,Nos); % CCDF of LFDMA
    semilogy(dBs,CCDF_LFDMa,['-' gss(i)]), hold on
    str(i,:)=sprintf('LFDMA with a=%3.1f and Nd=%3d',rho,Nd);
end
legend(str(1,:),str(2,:),str(3,:),str(4,:),str(5,:),'Location','best')
grid on;
title([num2str(M),'-QAM CCDF ',num2str(N),'-point FFT',num2str(Nblk) '-blocks']);
xlabel('PAPR_0[dB]'); ylabel('Pr(PAPR>PAPR_0)');