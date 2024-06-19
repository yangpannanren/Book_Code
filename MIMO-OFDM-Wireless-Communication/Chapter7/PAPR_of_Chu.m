% PAPR_of_Chu.m
% Plot Fig. 7.10(a)
clear; close all; clc;
N=16;
L=4; 
i=0:N-1; 
k = 3; 
X = exp(1i*k*pi/N*(i.*i)); %Eq.7.17
[x,time] = IFFT_oversampling(X,N);
PAPRdB = PAPR(x);
[x_os,time_os] = IFFT_oversampling(X,N,L); %x_os=x_os*L;
PAPRdB_os = PAPR(x_os);
figure
axis([-0.4 0.4 -0.4 0.4]);
axis('equal');
% plot(0.25*exp(1i*pi/180*(0:359)))
plot(time,abs(x),'o', time_os,abs(x_os),'k:*')
PAPRdB_without_and_with_oversampling=[PAPRdB  PAPRdB_os]
title('IFFT(X_l(k)),k=3,N=16,L=1,4')
xlabel('Time (normalized by symbolic intervals)');
ylabel('|IFFT(u_l(k))|')
legend('L=1','L=4')