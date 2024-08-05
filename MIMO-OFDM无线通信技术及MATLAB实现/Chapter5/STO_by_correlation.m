function [STO_est, Mag]=STO_by_correlation(y,Nfft,Ng,com_delay)
% STO estimation by maximizing the correlation between CP and rear part of OFDM symbol
% Input:  y         = Received OFDM signal including CP
%         Ng        = Number of samples in Guard Interval (CP)
%         com_delay = Common delay
% Output: STO_est   = STO estimate
%         Mag       = Correlation function trajectory varying with time
N_ofdm = Nfft+Ng; 
if nargin<4
    com_delay = N_ofdm/2;
end
yy = y(com_delay : com_delay+ Ng-1)*y(Nfft+com_delay : Nfft+com_delay+Ng-1)';
maximum = abs(yy);
for k = 1:N_ofdm
    yy1 = y(k-1+com_delay)*y(k-1+com_delay+Nfft)';
    yy2 = y(k-1+com_delay+Ng)*y(k-1+com_delay+Nfft+Ng)';
    yy = yy-yy1+yy2; %% 公式.(5.13)
    Mag(k) = abs(yy);
    if abs(yy) > maximum
        maximum = abs(yy);
        STO_est = N_ofdm - com_delay - k + 1;
    end
end
end