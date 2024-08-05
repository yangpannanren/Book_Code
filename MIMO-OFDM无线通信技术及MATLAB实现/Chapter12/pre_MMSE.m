% pre_MMSE.m
% Fig.12.6
clear; close all; clc;
%%%%%% Parameter Setting %%%%%%%%%
N_frame=100;
N_packet=1000;
b=2;
M=2^b;  % Number of bits per symbol and Modulation order
NT=4;
NR=4;
sq2=sqrt(2);
I=eye(NR,NR);
N_pbits = N_frame*NT*b;
N_tbits = N_pbits*N_packet;
fprintf('====================================================\n');
fprintf(' Pre-MMSE transmission');
fprintf('\n  %d x %d MIMO\n  %d QAM', NT,NR,M);
fprintf('\n  Simulation bits : %d',N_tbits);
fprintf('\n====================================================\n');
SNRdBs = 0:2:20;
for i_SNR=1:length(SNRdBs)
    SNRdB = SNRdBs(i_SNR);
    noise_var = NT*0.5*10^(-SNRdB/10);
    sigma = sqrt(noise_var);
    rng(1);
    N_ebits = 0;
    %%%%%%%%%%%%% Transmitter %%%%%%%%%%%%%%%%%%
    for i_packet=1:N_packet
        msg_bit = randi([0,1],N_pbits,1); % bit generation
        symbol = qammod(msg_bit,M).';
        Scale = modnorm(symbol,'avpow',1); % normalization
        Symbol_nomalized = reshape(Scale*symbol,NT,[]);
        H = (randn(NR,NT)+1i*randn(NR,NT))/sq2;
        temp_W = H'*inv(H*H'+noise_var*I);
        beta = sqrt(NT/trace(temp_W*temp_W')); % Eq.(12.17)
        W = beta*temp_W;
        Tx_signal = W*Symbol_nomalized;
        %%%%%%%%%%%%% Channel and Noise %%%%%%%%%%%%%
        Rx_signal = H*Tx_signal+sigma*(randn(NR,N_frame*b)+1i*randn(NR,N_frame*b));
        %%%%%%%%%%%%%% Receiver %%%%%%%%%%%%%%%%%%%%%
        y = Rx_signal/beta; % Eq.(12.18)
        Symbol_hat = reshape(y/Scale,[],1);
        msg_hat = qamdemod(Symbol_hat,M);
        N_ebits = N_ebits + sum(msg_hat~=msg_bit);
    end
    BER(i_SNR) = N_ebits/N_tbits;
end
semilogy(SNRdBs,BER,'-k^','LineWidth',2);
hold on; grid on;
xlabel('SNR[dB]'), ylabel('BER');
legend('Pre-MMSE transmission')