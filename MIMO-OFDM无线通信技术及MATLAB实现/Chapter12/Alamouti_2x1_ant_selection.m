% Alamouti_2x1_ant_selection.m
% Fig.12.10
clear; close all; clc;
%%%%%% Parameter Setting %%%%%%%%%
N_packet=100;
N_frame=100;
mod_order=2;
M=2^mod_order;
% MIMO Parameters
T_TX=4;
NT=2;
NR=1;
n_bits=NT *mod_order*N_frame;
N_tbits=n_bits*N_packet;
fprintf('====================================================\n');
fprintf('  Ant_selection transmission');
fprintf('\n  %d x %d MIMO\n  %d QAM', NT ,NR,M);
fprintf('\n  Simulation bits : %d',N_tbits);
fprintf('\n====================================================\n');
SNRdBs = 0:2:20;
sq2=sqrt(2);
for i_SNR=1:length(SNRdBs)
    SNRdB= SNRdBs(i_SNR);
    noise_var = NT *0.5*10^(-SNRdB/10);
    sigma = sqrt(noise_var);
    rng(1);
    N_ebits = 0;
    %%%%%%%%%%%%% Transmitter %%%%%%%%%%%%%%%%%%
    for i_packet=1:N_packet
        msg_bit = randi([0,1],n_bits,1); % Bit generation
        s = qammod(msg_bit,M);
        Scale = modnorm(s,'avpow',1); % Normalization factor
        S=reshape(Scale*s,NT ,1,[]);
        Tx_symbol=[S(1,1,:)  -conj(S(2,1,:)); S(2,1,:)   conj(S(1,1,:))];
        %%%%%%%%%%%%% Channel and Noise %%%%%%%%%%%%%
        H = (randn(NR,T_TX)+1i*randn(NR,T_TX))/sq2;
        for TX_index=1:T_TX
            ch(TX_index)=norm(H(:,TX_index),'fro');
        end
        [val,Index] = sort(ch,'descend');
        Hs = H(:,Index([1 2]));
        norm_H2=norm(Hs,'fro')^2; % H selected and its norm2
        for i=1:N_frame*mod_order
            Rx(:,:,i) = Hs*Tx_symbol(:,:,i) + ...
                sigma*(randn(NR,2)+1i*randn(NR,2));
        end
        %%%%%%%%%%%%% Receiver %%%%%%%%%%%%%%%%%%
        for i=1:N_frame*mod_order
            y(1,i) = (Hs(1)'*Rx(:,1,i)+Hs(2)*Rx(:,2,i)')/norm_H2;
            y(2,i) = (Hs(2)'*Rx(:,1,i)-Hs(1)*Rx(:,2,i)')/norm_H2;
        end
        S_hat = reshape(y/Scale,[],1);
        msg_hat = qamdemod(S_hat,M);
        N_ebits = N_ebits + sum(msg_hat~=msg_bit);
    end
    BER(i_SNR) = N_ebits/N_tbits;
end
semilogy(SNRdBs,BER,'-k^', 'LineWidth',2); hold on; grid on;
xlabel('SNR[dB]'), ylabel('BER');
legend('Ant-selection transmission')
title(sprintf('Performance of Alamouti STBC with Antenna Selection,Q=%d,N_{Tx}=%d',NT,T_TX))