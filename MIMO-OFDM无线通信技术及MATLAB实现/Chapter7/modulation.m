function [s,time] = modulation(x,Ts,Nos,Fc)
% Ts : Sampling period
% Nos: Oversampling factor
% Fc : Carrier frequency
Nx=length(x); 
offset = 0; 
if nargin<5
    scale = 1; %Scale for Baseband
    T=Ts/Nos; %Oversampling period for Baseband
else
    scale = sqrt(2); %Scale for Passband
    T=1/Fc/2/Nos; %Oversampling period for Passband
end
t_Ts = 0:T:Ts-T; % One sampling interval
time = 0:T:Nx*Ts-T; %Whole interval
tmp = 2*pi*Fc*t_Ts+offset; 
len_Ts=length(t_Ts); 
cos_wct = cos(tmp)*scale;  
sin_wct = sin(tmp)*scale;
for n = 1:Nx
   s((n-1)*len_Ts+1:n*len_Ts) = real(x(n))*cos_wct-imag(x(n))*sin_wct;
end