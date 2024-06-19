clear; close all; clc;
nSTOs = [-3 -3 2 2];  % Sampling numbers to STO
CFOs = [0 0.5 0 0.5]; % CFO vector
SNRdB = 30;   % SNR
MaxIter = 10;  % The number of iterations
Nfft = 128; % FFT size
Ng = Nfft/4; % GI(CP) length
Nofdm = Nfft+Ng; % OFDM symbol length
Nbps = 2; % 2/4 to QPSK/16QAM 
M = 2^Nbps; 
Es = 1; % signal energy
A = sqrt(3/2/(M-1)*Es); % QAM normalization factor
N = Nfft; 
com_delay = Nofdm/2;
Nsym = 100;
rng(1)
for i=1:length(nSTOs)
   nSTO= nSTOs(i);  
   CFO= CFOs(i);
   x = []; % Initialize the OFDM signal
   for m=1:Nsym % Transmit OFDM signals
      msgint=randi([0 M-1],1,N);
      Xf = A.*qammod(msgint,M,'UnitAveragePower',true);
      xt = ifft(Xf,Nfft);
      x_sym = add_CP(xt,Ng); %加CP
      x = [x x_sym]; 
   end
   y = x;  % without channel impact
   y_CFO= add_CFO(y,CFO,Nfft); % add CFO
   y_CFO_STO= add_STO(y_CFO,-nSTO);  % add STO
   v_ML=zeros(1,Ng); 
   v_Cl=zeros(1,Ng);
   Mag_cor= 0; 
   Mag_dif= 0;
   for iter=1:MaxIter
      y_aw = awgn(y_CFO_STO,SNRdB,'measured'); % AWGN
      %Symbol Timing Acqusition
      [STO_cor,mag_cor]= STO_by_correlation(y_aw,Nfft,Ng,com_delay);
      [STO_dif,mag_dif] = STO_by_difference(y_aw,Nfft,Ng,com_delay);
      v_ML(-STO_cor+Ng/2)= v_ML(-STO_cor+Ng/2)+1;
      v_Cl(-STO_dif+Ng/2)= v_Cl(-STO_dif+Ng/2)+1;
      Mag_cor= Mag_cor + mag_cor; 
      Mag_dif= Mag_dif + mag_dif;
   end
   %Probability
   v_ML_v_Cl= [v_ML; v_Cl]*(100/MaxIter);
   figure(i); 
   bar(-Ng/2+1:Ng/2,v_ML_v_Cl');
   hold on, grid on
   str = sprintf('nSTO Estimation: nSTO=%d, CFO=%1.2f, SNR=%3d[dB]',nSTO,CFO,SNRdB);           
   title(str); 
   xlabel('Sample'), ylabel('Probability');
   legend('Cor','Dif'); 
   axis([-Ng/2-1 Ng/2+1 0 100])
   %Time metric
   [Mag_cor_max,ind_max] = max(Mag_cor); 
   nc= ind_max-1-com_delay;
   [Mag_dif_min,ind_min] = min(Mag_dif); 
   nd= ind_min-1-com_delay;
   nn= -Nofdm/2 + (0:length(Mag_cor)-1); 
   figure(length(nSTOs)+i); 
   plot(nn,Mag_cor,nn,Mag_dif,'r:','markersize',1);
   hold on  
   str1 = sprintf('STO Estimation - Cor(b-)/Dif(r:) for nSTO=%d, CFO=%1.2f',nSTO,CFO); %,SNRdB);
   title(str1); 
   xlabel('Sample'), ylabel('Magnitude'); 
   stem(nc,Mag_cor_max,'b','markersize',5);
   stem(nd,Mag_dif_min,'r','markersize',5);
   stem(nSTO,Mag_dif(nSTO+com_delay+1),'k.','markersize',5); % Estimated/True Minimum value
   legend('by correlation','by difference'); 
end