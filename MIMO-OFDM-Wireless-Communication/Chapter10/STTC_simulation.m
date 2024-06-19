% STTC_simulation.m
% To simulate the STTC (Space-Time Trellis Coding) scheme
% Fig.10.13
clear; close all; clc;
N_frame=130;
N_Packets=1000;
NT=2;
NR=1;
zf=3;
SNRdBs=5:2:15;
figure
for iter=1:4
    if iter==1
        state='4_State_4PSK';
        gs='-o';
    elseif iter==2
        state='8_State_4PSK';
        gs='-s';
    elseif iter==3
        state='16_State_4PSK';
        gs='-+';
    else
        state='32_State_4PSK';
        gs='-x';
    end
    [dlt,slt,M] = STTC_stage_modulation(state,NR);
    data_source = data_generator(N_frame,N_Packets,M,zf);
    data_encoded = trellis_encoder(data_source,dlt,slt);
    mod_sig = STTC_modulator(data_encoded,M);
    for i_SNR=1:length(SNRdBs)
        [signal,ch_coefs] = channel1(mod_sig,SNRdBs(i_SNR),NR);
        [data_est,state_est] = STTC_detector(signal,dlt,slt,ch_coefs);
        [N_frame1,space_dim,N_packets] = size(data_est);
        FER(i_SNR) = sum(sum(data_source~=data_est)>0)/N_packets;
    end
    semilogy(SNRdBs,FER,gs);hold on;
end
legend('STTC(4State,4PSK,2×1)','STTC(8State,4PSK,2×1)', ...
    'STTC(16State,4PSK,2×1)','STTC(32State,4PSK,2×1)');
title('BER of STTC coding,')