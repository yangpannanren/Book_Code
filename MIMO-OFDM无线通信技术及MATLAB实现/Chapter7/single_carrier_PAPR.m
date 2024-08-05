%single_carrier_PAPR.m
clear; close all; clc;
Ts = 1; %Sampling period
Nos = 8; %Oversampling factor
Fc = 1; %Carrier frequency
bits = [1 2 4]; %bits=2;
for i_b = 1:length(bits)
    b = bits(i_b);
    M = 2^b;
    [X,Mod] = mapper(b); %Generate M-PSK/QAM symbols
    Nos_=Nos*4; %Oversampling factor, making the signal appear like a continuous time signal
    [xt_pass_,time_] = modulation(X,Ts,Nos_,Fc); %continuous time
    [xt_pass,time] = modulation(X,Ts,Nos,Fc); %L times oversampling
    for i_s = 1:M
        xt_base(Nos*(i_s-1)+1:Nos*i_s) = X(i_s)*ones(1,Nos);
    end
    PAPR_dB_base(i_b) = PAPR(xt_base);
    figure(2*i_b-1);  clf;
    subplot(311)
    stem(time,real(xt_base),'k.');
    hold on;
    ylabel('S_{I}(n)');
    title([Mod ', ' num2str(M) ' symbols, Ts=' num2str(Ts) 's, Fs=' num2str(1/Ts*2*Nos) 'Hz, Nos=' num2str(Nos) ', baseband, g(n)=u(n)-u(n-Ts)']);
    subplot(312)
    stem(time,imag(xt_base),'k.');
    hold on;
    ylabel('S_{Q}(n)');
    subplot(313)
    stem(time,abs(xt_base).^2,'k.');
    hold on;
    title(['PAPR = ' num2str(round(PAPR_dB_base(i_b)*100)/100) 'dB']);
    xlabel ('samples');
    ylabel('|S_{I}(n)|^{2}+|S_{Q}(n)|^{2}');
    figure(2*i_b), clf;
    PAPR_dB_pass(i_b) = PAPR(xt_pass);
    subplot(211)
    stem(time,xt_pass,'k.');
    hold on;
    plot(time_,xt_pass_,'k:');
    title([Mod ', ' num2str(M) ' symbols, Ts=' num2str(Ts) 's, Fs=' num2str(1/Ts*2*Nos) 'Hz, Nos=' num2str(Nos) ', Fc=' num2str(Fc) 'Hz, g(n)=u(n)-u(n-Ts)']);
    ylabel('S(n)');
    subplot(212)
    stem(time,xt_pass.*xt_pass,'r.');
    hold on;
    plot(time_,xt_pass_.*xt_pass_,'k:');
    title(['PAPR = ' num2str(round(PAPR_dB_pass(i_b)*100)/100) 'dB']);
    xlabel('samples');
    ylabel('|S(n)|^{2}');
end
PAPRs_of_baseband_passband_signals=[PAPR_dB_base; PAPR_dB_pass]