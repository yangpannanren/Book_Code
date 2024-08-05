% OL_CL_Comparison.m
% Fig.9.7
clear; close all; clc;
SNR_dB=0:5:20;
SNR_linear=10.^(SNR_dB/10.);
rho=0.2;
Rtx=[1      rho     rho^2   rho^3;
    rho     1      rho    rho^2;
    rho^2   rho     1       rho;
    rho^3   rho^2   rho     1];
Rrx=[1      rho     rho^2   rho^3;
    rho     1       rho     rho^2;
    rho^2   rho     1       rho;
    rho^3   rho^2   rho     1];
N_iter=1000;
nT=4;
nR=4; %4x4
n=min(nT,nR);
I = eye(n);
sq2=sqrt(0.5);
C_44_OL=zeros(1,length(SNR_dB));
C_44_CL=zeros(1,length(SNR_dB));
for iter=1:N_iter
    Hw = sq2*(randn(4,4) + 1i*randn(4,4));
    H = Rrx^(1/2)*Hw*Rtx^(1/2);
    tmp = H'*H/nT;
    SV = svd(H'*H);
    for i=1:length(SNR_dB) %random channel generation
        C_44_OL(i) = C_44_OL(i)+...
            log2(det(I+SNR_linear(i)*tmp)); %Eq.(9.41)
        Gamma = Water_Pouring(SV,SNR_linear(i),nT);
        C_44_CL(i) = C_44_CL(i)+...
            log2(det(I+SNR_linear(i)/nT*diag(Gamma)*diag(SV))); %Eq.(9.44)
    end
end
C_44_OL = real(C_44_OL)/N_iter;
C_44_CL = real(C_44_CL)/N_iter;
figure
plot(SNR_dB, C_44_OL,'-o', SNR_dB, C_44_CL,'-<');
xlabel('SNR [dB]');
ylabel('bps/Hz');
set(gca,'fontsize',10);
legend('Channel Unknown','Channel Known');
title('Channel traversal capacity with N_T=N_R=4')
grid on