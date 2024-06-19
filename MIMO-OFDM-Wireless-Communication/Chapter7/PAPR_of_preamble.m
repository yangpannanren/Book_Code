% PAPR_of_preamble.m
% Plot Fig. 7.10(b) (the PAPR of IEEE802.16e preamble)
clear; close all; clc;
N=1024;
L=4;
Npreamble=114;
n=0:Npreamble-1;
PAPRdB = zeros(Npreamble,1);
PAPRdB_os = zeros(Npreamble,1);
for i = 1:Npreamble
    X=load(['/MATLAB Drive/MIMO-OFDM-Wireless-Communication/Chapter7/Wibro-Preamble/Preamble_sym' num2str(i-1) '.dat']);
    X = X(:,1);
    X = sign(X);
    X = fftshift(X);
    x = IFFT_oversampling(X,N);
    PAPRdB(i) = PAPR(x);
    x_os = IFFT_oversampling(X,N,L);
    PAPRdB_os(i) = PAPR(x_os);
end
plot(n,PAPRdB,'-o', n,PAPRdB_os,':*')
if L == 4
    PAPRdB_L4 = PAPRdB;
    PAPRdB_os_L4 = PAPRdB_os;
end
if L == 8
    PAPRdB_L8 = PAPRdB;
    PAPRdB_os_L8 = PAPRdB_os;
end 
if L == 16
    PAPRdB_L16 = PAPRdB;
    PAPRdB_os_L16 = PAPRdB_os;
end
title('PAPRdB without and with oversampling')
xlabel('preamble number[0~113]');
ylabel('PAPR')
legend('L=1','L=4')