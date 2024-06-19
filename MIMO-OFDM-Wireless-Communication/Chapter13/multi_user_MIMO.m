% multi_user_MIMO.m
% Fig.13.5
clear; close all; clc;
%%%%%% Parameter Setting %%%%%%%%%
N_frame=10;
N_packet=2000; % Number of frames/packet and Number of packets
b=2; % Number of bits per QPSK symbol
NT=4;
N_user=20;
N_act_user=4;
I=eye(N_act_user,NT);
N_pbits = N_frame*NT*b; % Number of bits in a packet
N_tbits = N_pbits*N_packet; % Number of total bits
SNRdBs = 0:2:20;
sq2=sqrt(2);
BER = zeros(2,length(SNRdBs));
rng(1);
for mode = 0:1 % Set mode=0/1 for channel inversion or regularized channel inversion
    for i_SNR=1:length(SNRdBs)
        SNRdB=SNRdBs(i_SNR);
        N_ebits = 0;
        sigma2 = NT*0.5*10^(-SNRdB/10);
        sigma = sqrt(sigma2);
        for i_packet=1:N_packet
            msg_bit = randi([0,1],1,N_pbits); % Bit generation
            %%%%%%%%%%%%% Transmitter %%%%%%%%%%%%%%%%%%
            symbol = QPSK_mapper(msg_bit).';
            x = reshape(symbol,NT,N_frame);
            for i_user=1:N_user
                H(i_user,:) = (randn(1,NT)+1i*randn(1,NT))/sq2;
                Channel_norm(i_user)=norm(H(i_user,:));
            end
            [Ch_norm,Index]=sort(Channel_norm,'descend');
            H_used = H(Index(1:N_act_user),:);
            temp_W = H_used'*inv(H_used*H_used' + (mode==1)*sigma*I);
            beta = sqrt(NT/trace(temp_W*temp_W')); %Eq.(12.17)
            W = beta*temp_W; %Eq.(12.19)
            Tx_signal = W*x; % Pre-equalized signal at Tx
            %%%%%%%%%%%%% Channel and Noise %%%%%%%%%%%%%
            Rx_signal = H_used*Tx_signal + ...
                sigma*(randn(N_act_user,N_frame)+1i*randn(N_act_user,N_frame));
            %%%%%%%%%%%%%% Receiver %%%%%%%%%%%%%%%%%%%%%
            x_hat = Rx_signal/beta; % Eq.(12.18)
            symbol_hat = reshape(x_hat,NT*N_frame,1);
            symbol_sliced = QPSK_slicer(symbol_hat);
            demapped = QPSK_demapper(symbol_sliced);
            N_ebits = N_ebits + sum(msg_bit~=demapped);
        end
        BER(mode+1,i_SNR) = N_ebits/N_tbits;
    end
end
figure
semilogy(SNRdBs,BER(1,:),'-ro',SNRdBs,BER(2,:),'-b+');
grid on;
xlabel('SNR[dB]');ylabel('BER');
legend('channel reversal(N_B=N_{Tx}=4,number of users:20/number of selected users:4)','regular channel reversal(Tx:4,number of users:20/number of selected users:4)');
title('BER performance in channel reversal mode')