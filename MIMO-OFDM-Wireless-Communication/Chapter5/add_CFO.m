function y_CFO=add_CFO(y,CFO,Nfft)
% To add an arbitrary frequency offset
% Input: y    = Time-domain received signal
%        dCFO = FFO (fractional CFO) + IFO (integral CFO)
%        Nfft = FFT size;

nn=0:length(y)-1; 
y_CFO = y.*exp(1i*2*pi*CFO*nn/Nfft);
% plot(real(y_CFO),imag(y_CFO),'.');