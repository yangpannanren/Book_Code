function sig_mod = STTC_modulator(data,M,~)
qam16=[1 1; 2 1; 3 1; 4 1; 4 2; 3 2; 2 2; 1 2; 1 3; 2 3; 3 3; 4 3; 4 4; 3 4; 2 4; 1 4];
[~,space_dim,N_packets]=size(data);
j2piM=1i*2*pi/M;
for k = 1:N_packets
    switch M
        case 16         % 16QAM
            for l = 1:space_dim
       		   k1(:,l) = qam16(data(:,l,k)+1,1);
               k2(:,l) = qam16(data(:,l,k)+1,2);
            end
            q(:,:,k) = 2*k1-M-1 - 1i*(2*k2-M-1);
        otherwise
            q(:,:,k) = exp(j2piM*data(:,:,k));
    end
    sig_mod=q;
end