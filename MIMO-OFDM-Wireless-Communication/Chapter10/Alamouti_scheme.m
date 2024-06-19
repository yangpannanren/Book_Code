% Alamouti_scheme.m
% Fig.10.7
clear; close all; clc;
N_frame=130; % Number of frames/packet
N_Packets=4000; % Number of packets
b=2;
SNRdBs=0:2:30;
sq2=sqrt(2);
for iter=1:2
    if iter==1
        NT=2;
        NR=1;
        gs='-^';
    else
        NT=2;
        NR=2;
        gs='-ro';
    end
    sq_NT=sqrt(NT);
    for i_SNR=1:length(SNRdBs)
        SNRdB=SNRdBs(i_SNR);
        sigma=sqrt(0.5/(10^(SNRdB/10)));
        for i_packet=1:N_Packets
            msg_symbol=randi([0,1],N_frame*b,NT);
            tx_bits=msg_symbol.';
            tmp=[];
            tmp1=[];
            for i=1:NT
                [tmp1,sym_tab,P] = modulator(tx_bits(i,:),b);
                tmp=[tmp; tmp1];
            end
            X=tmp.';
            X1=X;
            X2=[-conj(X(:,2)) conj(X(:,1))];
            for n=1:NT
                Hr(n,:,:)=(randn(N_frame,NT)+1i*randn(N_frame,NT))/sq2;
            end
            H=reshape(Hr(n,:,:),N_frame,NT);
            Habs(:,n)=sum(abs(H).^2,2);
            R1 = sum(H.*X1,2)/sq_NT + sigma*(randn(N_frame,1)+1i*randn(N_frame,1));
            R2 = sum(H.*X2,2)/sq_NT + sigma*(randn(N_frame,1)+1i*randn(N_frame,1));
            Z1 = R1.*conj(H(:,1)) + conj(R2).*H(:,2);
            Z2 = R1.*conj(H(:,2)) - conj(R2).*H(:,1);
            for m=1:P
                tmp = (-1+sum(Habs,2))*abs(sym_tab(m))^2;
                d1(:,m) = abs(sum(Z1,2)-sym_tab(m)).^2 + tmp;
                d2(:,m) = abs(sum(Z2,2)-sym_tab(m)).^2 + tmp;
            end
            [y1,i1]=min(d1,[],2);
            S1d=sym_tab(i1).';
            clear d1
            [y2,i2]=min(d2,[],2);
            S2d=sym_tab(i2).';
            clear d2
            Xd = [S1d S2d];
            tmp1=X>0;
            tmp2=Xd>0;
            noeb_p(i_packet) = sum(sum(tmp1~=tmp2));
        end % End of FOR loop for i_packet
        BER(iter,i_SNR) = sum(noeb_p)/(N_Packets*N_frame*b);
    end    % End of FOR loop for i_SNR
    semilogy(SNRdBs,BER(iter,:),gs);
    hold on;
    axis([SNRdBs([1 end]) 1e-6 1])
end
grid on;
xlabel('SNR[dB]');
ylabel('BER');
legend('Alamouti(Tx:2,Rx:1)','Alamouti(Tx:2,Rx:2)')
title('Error performance of Alamouti encoding scheme')
