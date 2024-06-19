% CCDF_of_clipped_filtered_OFDM_signal.m
% Plot Fig. 7.16
clear; close all; clc;
SNRdBs=0:10; % SNR[dB] vector
N_SNR=length(SNRdBs);
Nblk=100;
CRs=0.8:0.2:1.6;
N_CR=length(CRs);
gss='*^<sd>v';
b = 2; % Number of bits per QAM symbol
M = 2^b;
N = 128; %FFT size
Ncp = 0;  % CP size (GI length)
fs = 1e6; % Sampling frequency
L = 8; % Sampling frequency and Oversampling factor
Tsym=1/(fs/N); % OFDM symbol period
Ts=1/(fs*L); % Sampling period
fc = 2e6;
wc = 2*pi*fc; % Carrier frequency
t = (0:Ts:2*Tsym-Ts)/Tsym;
A = modnorm(qammod(0:M-1,M),'avpow',1); % Normalization factor
Fs=8;
Norder=104;
dens=20; % Sampling frequency, Order, and Density factor of filter
FF=[0 1.4 1.5 2.5 2.6 Fs/2]; % Stopband/Passband/Stopband frequency edge vector
WW=[10 1 10]; % Stopband/Passband/Stopband weight vector
h = firpm(Norder,FF/(Fs/2),[0 0 1 1 0 0],WW,{dens}); % BPF coefficients
Clipped_errCnt = zeros(size(CRs));
ClippedFiltered_errCnt = zeros(size(CRs));
CF = zeros(1,Nblk);
CF_c = zeros(N_CR,Nblk);
CF_cf = zeros(N_CR,Nblk);
% ------------- Iteration with increasing SNRdB --------------------%
ber_analytic = berawgn(SNRdBs-10*log10(b),'qam',M);
kk1=1:(N/2-Ncp)*L;
kk2=kk1(end)+1:N/2*L+N*L;
kk3=kk2(end)+(1:N*L/2);
z = 2:0.1:16;
len_z = length(z);
for i = 1:N_SNR
    SNRdB = SNRdBs(i);
    for ncf = 0:2 % no/clip/clip&filter
        if ncf==2
            m=ceil(length(h)/2);
        else
            m=1;
        end
        for cr = 1:N_CR
            if ncf==0&&cr>1
                break;
            end
            CR = CRs(cr);
            nobe = 0;
            for nblk = 1:Nblk %(i)
                msgbin = randi([0,1],[1,N]);   % binary squences
                X = A*qammod(msgbin,M); % 4QAM (QPSK) mapper
                X(1) = 0+1i*0;    % DC subcarrier not used
                x = IFFT_oversampling(X,N,L);
                x_b = add_CP(x,Ncp*L);
                x_b_os = [zeros(1,(N/2-Ncp)*L), x_b, zeros(1,N*L/2)];
                x_p = sqrt(2)*real(x_b_os.*exp(1i*2*wc*t));
                if ncf>0
                    x_p_c = clipping(x_p,CR);
                    x_p=x_p_c;     % clipping
                    if ncf>1
                        x_p_cf = ifft(fft(h,length(x_p)).*fft(x_p));
                        x_p=x_p_cf;
                    end
                end
                if i==N_SNR
                    CF(nblk) = PAPR(x_p);
                end
                y_p_n = [x_p(kk1) awgn(x_p(kk2),SNRdB,'measured') x_p(kk3)]; % add Noise(AWGN)
                y_b = sqrt(2)*y_p_n.*exp(-1i*2*wc*t);
                Y_b = fft(y_b);
                y_b_z = ifft(zero_pasting(Y_b));
                y_b_t = y_b_z((N/2-Ncp)*L+m+(0:L:(N+Ncp)*L-1));
                Y_b_f = fft(y_b_t(Ncp+1:end),N)*L;
                Y_b_bin = qamdemod(Y_b_f,M);
                nobe = nobe + biterr(msgbin(:,2:end),Y_b_bin(:,2:end));
            end % End of the nblk loop
            if ncf==0
                ber_no(i) = nobe/Nblk/(N-1)/b;
            elseif ncf==1
                ber_c(cr,i) = nobe/Nblk/(N-1)/b;
            else
                ber_cf(cr,i) = nobe/Nblk/(N-1)/b;
            end
            if i==N_SNR
                for iz=1:len_z
                    CCDF(iz) = sum(CF>z(iz))/Nblk;
                end
                if ncf==0
                    CCDF_no = CCDF;
                    break;
                elseif ncf==1
                    CCDF_c(cr,:) = CCDF;
                else
                    CCDF_cf(cr,:) = CCDF;
                end
            end
        end
    end
end
figure(1)
semilogy(z,CCDF_no);
grid on, hold on
for cr = 1:N_CR
    gs = gss(cr);
semilogy(z,CCDF_c(cr,:),[gs 'b-']);
semilogy(z,CCDF_cf(cr,:),[gs 'r:']);
end
legend('Unclipped','Clipping','Clipping and Filtering')
hold off;
xlabel('Z_0(dB)');ylabel('CCDF F_Z(Z_0)')
title('CF的CCDF,CR=0.8,1.0,1.2,1.4,1.6')
figure(2)
semilogy(SNRdBs,ber_no,'o')
hold on;grid on;
semilogy(SNRdBs,ber_analytic,'k')
for cr = 1:N_CR
    gs = gss(cr);
    semilogy(SNRdBs,ber_c(cr,:),[gs '-']);
    semilogy(SNRdBs,ber_cf(cr,:),[gs ':']);
end
legend('Unclipped','analytic','CR=0.8(C)','CR=0.8(C&F)', ...
    'CR=1.0(C)','CR=1.0(C&F)','CR=1.2(C)','CR=1.2(C&F)', ...
    'CR=1.4(C)','CR=1.4(C&F)','CR=1.6(C)','CR=1.6(C&F)', ...
    'Location','best')
xlabel('EbN0(dB)');ylabel('BER');
title('无编码的BER')
