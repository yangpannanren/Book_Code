% MIMO_channel_cap_ant_sel_subopt.m
% Fig.12.9
clear; close all; clc;
sel_method=0; % 0/1 for increasingly/decreasingly ordered selection
NT=4;
NR=4; % Number of transmit/receive antennas
I=eye(NR,NR);
sq2=sqrt(2);
SNRdBs = 0:2:20;
MaxIter=1000;
gss=['-o';'-^';'-d';'-s'];
rng(1);
for sel_ant=1:4 % Number of antennas to select
    sel_capacity = zeros(1,length(SNRdBs));
    for i_SNR=1:length(SNRdBs)
        SNRdB = SNRdBs(i_SNR);
        SNR_sel_ant = 10^(SNRdB/10)/sel_ant;
        cum = 0;
        for i=1:MaxIter
            if sel_method==0
                sel_ant_indices=[];
                rem_ant_indices=1:NT;
            else
                sel_ant_indices=1:NT;
                del_ant_indices=[];
            end
            H = (randn(NR,NT)+1i*randn(NR,NT))/sq2;
            if sel_method==0 %increasingly ordered selection method
                for current_sel_ant_number=1:sel_ant
                    clear log_SH;
                    for n=1:length(rem_ant_indices)
                        Hn = H(:,[sel_ant_indices rem_ant_indices(n)]);
                        log_SH(n) = log2(real(det(I+SNR_sel_ant*Hn*(Hn'))));
                    end
                    maximum_capacity = max(log_SH);
                    selected = find(log_SH==maximum_capacity);
                    sel_ant_index = rem_ant_indices(selected);
                    rem_ant_indices = [rem_ant_indices(1:selected-1) rem_ant_indices(selected+1:end)];
                    sel_ant_indices = [sel_ant_indices sel_ant_index];
                end
            else %decreasingly ordered selection method
                for current_del_ant_number=1:NT-sel_ant
                    clear log_SH;
                    for n=1:length(sel_ant_indices)
                        Hn = H(:,[sel_ant_indices(1:n-1) sel_ant_indices(n+1:end)]);
                        log_SH(n) = log2(real(det(I+SNR_sel_ant*Hn*(Hn'))));
                    end
                    maximum_capacity = max(log_SH);
                    selected = find(log_SH==maximum_capacity);
                    sel_ant_indices = [sel_ant_indices(1:selected-1) sel_ant_indices(selected+1:end)];
                end
            end
            cum = cum + maximum_capacity;
        end
        sel_capacity(i_SNR) = cum/MaxIter;
    end
    plot(SNRdBs,sel_capacity,gss(sel_ant,:), 'LineWidth',2);hold on;
end
grid on;
xlabel('SNR[dB]');ylabel('bps/Hz');
legend('Q=1','Q=2','Q=3','Q=4')
switch sel_method
    case 0
        title('Capacity of increasingly ordered selection antennas')

    case 1
        title('Capacity of decreasingly ordered selection antennas')
end