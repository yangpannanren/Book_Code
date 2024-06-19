% SQNR_with_quantization_clipping.m
% Plot Fig. 7.12
clear; close all; clc;
N=64; %FFT size
b=6; %The number of bits per QAM symbol
L=8; %Oversampling factor
MaxIter=1000; %Maximum number of iterations
TWLs = 6:9; %Total wordlengths
IWL = 1; % Integral WordLengths
mus=2:0.2:8;  % Clipping Ratio vector
sq2=sqrt(2);
sigma=1/sqrt(N); %Variance of x
gss=['ko-';'ks-';'k^-';'kd-']; %graphic symbols
for i = 1:length(TWLs)
    TWL = TWLs(i); %Total WordLength
    FWL = TWL-IWL; %Fractional WordLength
    for m = 1:length(mus)
        mu = mus(m)/sq2; %Implement the real and imaginary parts of x
        Tx = 0;
        Te = 0;
        for k = 1:MaxIter
            X = mapper(b,N);
            x = ifft(X,N);
            x = x/sigma/mu;
            xq=fi(x,1,TWL,FWL,'RoundingMethod','round','OverflowAction','saturate');
            % fi() with TWL=FWL+1 performs limiting and quantization
            xq=double(xq);
            Px = x*x';
            e = x-xq;
            Pe = e*e';
            Tx = Tx + Px; %The total power of the signal
            Te = Te + Pe; %Quantized power
        end
        SQNRdB(i,m) = 10*log10(Tx/Te);
    end
end
[SQNRdBmax,imax] = max(SQNRdB,[],2); % To find the maximum elements in each row of SQNRdB
for i=1:size(gss,1)
    plot(mus,SQNRdB(i,:),gss(i,:))
    hold on;
end
for i=1:size(gss,1)
    str(i,:)=[num2str(TWLs(i)) 'bit quantization'];
    plot(mus(imax(i)),SQNRdBmax(i),gss(i,1:2),'markerfacecolor','r')
end
hold off
title(['Effect of Clipping (N=' num2str(N) ', \sigma=' num2str(sigma) ')']);
xlabel('\mu(clipping level normalized to \sigma)');
ylabel('SQNR[dB]');
legend(str(1,:),str(2,:),str(3,:),str(4,:));
grid on