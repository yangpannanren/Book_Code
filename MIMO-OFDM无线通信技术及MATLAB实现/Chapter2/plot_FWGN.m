clear; close all; clc;
fm=100;   % Maximum Doppler frquency
ts_mu=50;
scale=1e-6;
ts=ts_mu*scale; % Sampling time
fs=1/ts;  % Sampling frequency
Nd=1e6;   % Number of samples
% To get the complex fading channel
[h,Nfft,Nifft,doppler_coeff] = FWGN_model(fm,fs,Nd);
figure
plot((1:Nd/100)*ts,10*log10(abs(h(1:Nd/100))),'b-') %Nd/100
axis([0 0.5 -30 5])
str = sprintf('channel modeled by Clarke/Gan with f_m=%d[Hz], T_s=%d[mus]',fm,ts_mu);
title(str), xlabel('time[s]'), ylabel('Magnitude[dB]')
figure
subplot(211)
histogram(abs(h),50)
xlabel('Magnitude')
ylabel('Occasions')
subplot(212)
histogram(angle(h),50)
xlabel('Phase[rad]')
ylabel('Occasions')