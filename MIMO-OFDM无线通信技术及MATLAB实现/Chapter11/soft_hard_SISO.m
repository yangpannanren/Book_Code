% soft_hard_SISO.m
% Fig.11.3
%%%%% Soft decision code has a problem %%%%%
clear; close all; clc;
decision = 0;  % 0/1 for hard/soft decision
G = [1 0 1 1 0 1 1; 1 1 1 1 0 0 1];
K=1;
N=2;
Rc=K/N;
L_packet=1200;
b=4;
N_symbol = (L_packet*N+12)/b;
EbN0dBs = 0:19;
sq05 = sqrt(1/2);
for i=1:length(EbN0dBs)
    EbN0dB=EbN0dBs(i);
    nope=0; % Number of erroneous packets
    for i_packet = 1:1e10
        bit_strm = randi([0,1],1,L_packet);
        coded_bits = convolution_encoder(bit_strm); %2*(7-1)=12 tail bits
        symbol_strm = QAM16_mod(coded_bits); % 16 QAM mapper
        h = sq05*(randn(1,N_symbol) + 1i*randn(1,N_symbol));
        faded_symbol = symbol_strm.*h; % Channel
        P_b = mean(abs(faded_symbol).^2)/b;
        noise_amp = sqrt(P_b/2*10^(-EbN0dB/10));
        faded_noisy_symbol = faded_symbol + noise_amp*...
            (randn(1,N_symbol) + 1i*randn(1,N_symbol)); % Noise
        channel_compensated = faded_noisy_symbol./h;
        if decision==0
            sliced_symbol = QAM16_slicer(channel_compensated);
            hard_bits = QAM16_demapper(sliced_symbol);
            Viterbi_init;
            bit_strm_hat = Viterbi_decode(hard_bits);%coded_bit_hat
        else
            soft_bits = soft_decision_sigma(channel_compensated,h);
            Viterbi_init;
            bit_strm_hat = Viterbi_decode_soft(soft_bits);
        end
        bit_strm_hat = bit_strm_hat(1:L_packet); % for error check
        nope = nope+(sum(bit_strm~=bit_strm_hat)>0); % # of packet errors
        if nope>50
            break;
        end
    end
    PER(i) = nope/i_packet;
    if PER(i)<1e-2
        break;
    end
end
semilogy(EbN0dBs,PER);hold on;
xlabel('Eb/N0[dB]'); ylabel('PER'); grid on
set(gca,'xlim',[0 EbN0dBs(end)],'ylim',[1e-3 1])
title('SISO packet error performance')