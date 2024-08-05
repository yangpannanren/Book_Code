function ber=ber_QAM(EbN0dB,M,AWGN_or_Rayleigh)
% Find ananlytical BER of Mary QAM in AWGN or Rayleigh channel
% EbN0dB: Energy per bit-to-noise power[dB] for AWGN channel
%       =rdB: Average SNR(2*sigma Eb/N0)[dB] for Rayleigh channel
% M = Modulation order (Constellation size)  

sqM= sqrt(M); 
a= 2*(1-power(sqM,-1))/log2(sqM);  
b= 6*log2(sqM)/(M-1);
if nargin<3
    AWGN_or_Rayleigh='AWGN'; 
end
if lower(AWGN_or_Rayleigh(1))=='a'
    % ber = berawgn(EbN0dB,'QAM',M); % MATLAB ToolBox
    ber = a*Q(sqrt(b*10.^(EbN0dB/10)));
else
    % diversity_order = 1;
    % ber = berfading(EbN0dB,'QAM',M,diversity_order); % MATLAB ToolBox
    rn= b*10.^(EbN0dB/10)/2; 
    ber = 0.5*a*(1-sqrt(rn./(rn+1)));
end