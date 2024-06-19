% plot_CCDF.m
% Plot the CCDF curves of Fig. 7.3.
clear; close all; clc;
Ns = 2.^(6:10); 
b=2; 
M=2^b; 
Nblk = 1e3;
zdBs = 4:0.1:10;
N_zdBs = length(zdBs);
CCDF_formula=@(N,s2,z)(1-((1-exp(-z.^2/(2*s2))).^N)); % Eq.(7.9)
for n = 1:length(Ns)    
    N=Ns(n);
    x = zeros(Nblk,N); 
    sqN=sqrt(N);
    for k = 1:Nblk
       X = mapper(b,N);
       x(k,:) = ifft(X,N)*sqN;
       CFx(k) = PAPR(x(k,:));
    end
    s2 = mean(mean(abs(x)))^2/(pi/2);
    CCDF_theoretical=CCDF_formula(N,s2,10.^(zdBs/20));
    for i = 1:N_zdBs
       CCDF_simulated(i) = sum(CFx>zdBs(i))/Nblk;
    end
    semilogy(zdBs,CCDF_theoretical,'k-');  
    hold on; grid on;
    semilogy(zdBs(1:3:end),CCDF_simulated(1:3:end),'k:*');
end
axis([zdBs([1 end]) 1e-2 1]); 
title('OFDM system with N-point FFT');
xlabel('PAPR0[dB]');
ylabel('CCDF=Probability(PAPR>PAPR0)'); 
legend('Theoretical','Simulated');