% Alamouti_2x1_precoding.m
% Fig.12.4
clear; close all; clc;
%%%%%% Parameter Setting %%%%%%%%%
N_frame=1000; % Number of frames
N_packet=100; % Number of packets
b=2;
M=2^b;
% MIMO Parameters
T_TX=4;
code_length=64;
NT=2;
NR=1; % Numbers of transmit/receive antennas
N_pbits=NT*b*N_frame;
N_tbits=N_pbits*N_packet;
code_book = codebook_generator;
fprintf('====================================================\n');
fprintf('  Precoding transmission');
fprintf('\n  %d x %d MIMO\n  %d QAM', NT,NR,M);
fprintf('\n  Simulation bits : %d', N_tbits);
fprintf('\n====================================================\n');
SNRdBs = 0:2:10;
sq2=sqrt(2);
for i_SNR=1:length(SNRdBs)
    SNRdB = SNRdBs(i_SNR);
    noise_var = NT*0.5*10^(-SNRdB/10);
    sigma = sqrt(noise_var);
    rng(1);
    N_ebits=0;
    for i_packet=1:N_packet
        msg_bit  = randi([0,M-1],N_pbits,1); % Bit generation
        %%%%%%%%%%%%% Transmitter %%%%%%%%%%%%%%%%%%
        s = qammod(msg_bit,M);
        Scale = modnorm(s,'avpow',1); % Normalization
        S = reshape(Scale*s,NT,1,[]); % Transmit symbol
        Tx_symbol = [S(1,1,:) -conj(S(2,1,:)); S(2,1,:) conj(S(1,1,:))];
        %%%%%%%%%%%%% Channel and Noise %%%%%%%%%%%%%
        H = (randn(NR,T_TX)+1i*randn(NR,T_TX))/sq2;
        for i=1:code_length
            cal(i) = norm(H*code_book(:,:,i),'fro');
        end
        [val,Index] = max(cal);
        He = H*code_book(:,:,Index);
        norm_H2 = norm(He)^2; % H selected and its norm2
        for i=1:N_frame*b
            Rx(:,:,i) = He*Tx_symbol(:,:,i)+sigma*(randn(NR,2)+1i*randn(NR,2));
        end
        %%%%%%%%%%%%% Receiver %%%%%%%%%%%%%%%%%%
        for i=1:N_frame*b
            y(1,i) = (He(1)'*Rx(:,1,i)+He(2)*Rx(:,2,i)')/norm_H2;
            y(2,i) = (He(2)'*Rx(:,1,i)-He(1)*Rx(:,2,i)')/norm_H2;
        end
        S_hat = reshape(y/Scale,[],1);
        msg_hat = qamdemod(S_hat,M);
        N_ebits = N_ebits + sum(msg_hat~=msg_bit);
    end
    BER(i_SNR) = N_ebits/N_tbits;
end
semilogy(SNRdBs,BER,'-b^', 'LineWidth',2);
hold on; grid on;
xlabel('SNR[dB]'), ylabel('BER');
legend('Precoded Alamouti');