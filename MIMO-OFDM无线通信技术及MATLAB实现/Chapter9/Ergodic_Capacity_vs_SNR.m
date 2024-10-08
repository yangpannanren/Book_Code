% Ergodic_Capacity_vs_SNR.m
% Fig.9.6
clear; close all; clc;
SNR_dB=0:5:20;
SNR_linear=10.^(SNR_dB/10.);
N_iter=1000;
for Icase=1:5
    if Icase==1
        nT=4;
        nR=4;      % 4x4
    elseif Icase==2
        nT=2;
        nR=2;     % 2x2
    elseif Icase==3
        nT=1;
        nR=1;     % 1x1
    elseif Icase==4
        nT=1;
        nR=2;     % 1x2
    else
        nT=2;
        nR=1;      % 2x1
    end
    n=min(nT,nR);
    I = eye(n);
    C(Icase,:) = zeros(1,length(SNR_dB));
    for iter=1:N_iter
        H = sqrt(0.5)*(randn(nR,nT)+1i*randn(nR,nT));
        if nR>=nT
            HH = H'*H;
        else
            HH = H*H';
        end
        for i=1:length(SNR_dB) %random channel generation
            C(Icase,i) = C(Icase,i)+log2(real(det(I+SNR_linear(i)/nT*HH)));
        end
    end
end
C = C/N_iter;
figure
plot(SNR_dB,C(1,:),'-o', SNR_dB,C(2,:),'-<', SNR_dB,C(3,:),'-s',SNR_dB,C(4,:),'->', SNR_dB,C(5,:),'-^');
xlabel('SNR[dB]');
ylabel('bps/Hz');
set(gca,'fontsize',10);
grid on
s1='{\it N_T}=1,{\it N_R}=1';
s2='{\it N_T}=1,{\it N_R}=2';
s3='{\it N_T}=2,{\it N_R}=1';
s4='{\it N_T}=2,{\it N_R}=2';
s5='{\it N_T}=4,{\it N_R}=4';
legend(s1,s2,s3,s4,s5,'Location','best')
title('MIMO channel traversal capacity when the transmitter has unknown CSI')