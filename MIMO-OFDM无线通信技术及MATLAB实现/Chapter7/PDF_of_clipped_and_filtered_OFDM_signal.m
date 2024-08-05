% PDF_of_clipped_and_filtered_OFDM_signal.m
% Plot Figs. 7.14 and 7.15
clear; close all; clc;
CR = 1.2; % Clipping Ratio
b=2; %The number of bits per QOSK symbol
N=128; %FFT size
Ncp=32; %CP size
fs=1e6; %Sampling frequency
L=8; %Oversampling factor
Tsym=1/(fs/N); %OFDM symbol period
Ts=1/(fs*L); %Sampling period
fc=2e6;
wc=2*pi*fc; % Carrier frequency
t=(0:Ts:2*Tsym-Ts)/Tsym; %Time vector
t0=t((N/2-Ncp)*L);
f=(0:fs/(N*2):L*fs-fs/(N*2))-L*fs/2; %Frequency vector
Fs=8;
Norder=104;
dens=20; % Sampling frequency, Order, and Density factor of filter
FF=[0 1.4 1.5 2.5 2.6 Fs/2]; % Stopband/Passband/Stopband frequency edge vector
WW=[10 1 10]; % Stopband/Passband/Stopband weight vector
h = firpm(Norder,FF/(Fs/2),[0 0 1 1 0 0],WW,{dens}); % BPF coefficients
X = mapper(b,N);
X(1) = 0; % QPSK modulation
x=IFFT_oversampling(X,N,L); % IFFT and oversampling
x_b=add_CP(x,Ncp*L); % Add CP
x_b_os=[zeros(1,(N/2-Ncp)*L), x_b, zeros(1,N*L/2)]; % Oversampling
x_p = sqrt(2)*real(x_b_os.*exp(1i*2*wc*t)); % From baseband to passband
x_p_c = clipping(x_p,CR); % Eq.(7.18)
X_p_c_f= fft(filter(h,1,x_p_c));
x_p_c_f = ifft(X_p_c_f);
x_b_c_f = sqrt(2)*x_p_c_f.*exp(-1i*2*wc*t); % From passband to baseband

figure(1); % Fig. 7.15(a),(b)
nn=(N/2-Ncp)*L+(1:N*L);
nn1=N/2*L+(-Ncp*L+1:0);
nn2=N/2*L+(0:N*L);
subplot(221)
plot(t(nn1)-t0, abs(x_b_os(nn1)),'b:'); hold on;
plot(t(nn2)-t0, abs(x_b_os(nn2)),'b-');
axis([t([nn1(1) nn2(end)])-t0  0  max(abs(x_b_os))]);
title('Baseband signal, with CP');
xlabel('t (normalized by symbol duration)');
ylabel('|(x\prime[m])|');
subplot(223)
XdB_p_os = 20*log10(abs(fft(x_b_os)));
plot(f,fftshift(XdB_p_os)-max(XdB_p_os),'b');
xlabel('frequency[Hz]');
ylabel('PSD[dB]');
axis([f([1 end]) -100 0]);
subplot(222)
histogram(x_p(nn),50,'Normalization','probability')
xlabel('x'); ylabel('pdf');
title('Unclipped passband signal');
subplot(224)
XdB_p = 20*log10(abs(fft(x_p)));
plot(f,fftshift(XdB_p)-max(XdB_p),'b');
xlabel('frequency[Hz]'); ylabel('PSD[dB]');
axis([f([1 end]) -100 0]);

figure(2) % Fig. 7.15(c), (d)
subplot(221)
histogram(x_p_c(nn),50,'Normalization','probability')
title(['Clipped passband signal, CR=' num2str(CR)]);
xlabel('x'); ylabel('pdf');
subplot(223)
XdB_p_c = 20*log10(abs(fft(x_p_c)));
plot(f,fftshift(XdB_p_c)-max(XdB_p_c),'b');
xlabel('frequency[Hz]'); ylabel('PSD[dB]'); axis([f([1 end]) -100 0]);
subplot(222)
histogram(x_p_c_f(nn),50,'Normalization','probability')
title(['Passband signal after clipping and filtering, CR=' num2str(CR)]);
xlabel('x'); ylabel('pdf');
subplot(224)
XdB_p_c_f = 20*log10(abs(X_p_c_f));
plot(f,fftshift(XdB_p_c_f)-max(XdB_p_c_f),'b');
xlabel('frequency[Hz]'); ylabel('PSD[dB]');
axis([f([1 end]) -100 0]);

figure(3) % Fig. 7.14
subplot(221)
stem(h,'b');
xlabel('tap'); ylabel('Filter coefficient h[n]');
axis([1, length(h), min(h), max(h)]);
subplot(222)
HdB = 20*log10(abs(fft(h,length(X_p_c_f))));
plot(f,fftshift(HdB),'b');
xlabel('frequency[Hz]'); ylabel('Filter freq response H[dB]');
axis([f([1 end]) -100 0]);
subplot(223)
histogram(abs(x_b_c_f(nn)),50,'Normalization','probability')
title(['Baseband signal after clipping and filtering, CR=' num2str(CR)]);
xlabel('|x|'); ylabel('pdf');
subplot(224)
XdB_b_c_f = 20*log10(abs(fft(x_b_c_f)));
plot(f,fftshift(XdB_b_c_f)-max(XdB_b_c_f),'b');
xlabel('frequency[Hz]'); ylabel('PSD[dB]');
axis([f([1 end]) -100 0]);