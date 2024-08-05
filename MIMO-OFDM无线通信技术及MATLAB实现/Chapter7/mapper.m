function [modulated_symbols,Mod] = mapper(b,N)
% If N is given, it generates a block of N random 2^b-PSK/QAM modulated symbols.
% Otherwise, it generates a block of 2^b-PSK/QAM modulated symbols for [0:2^b-1].

M=2^b; % Modulation order or Alphabet (Symbol) size
if b==1
    Mod='BPSK';
    A=1;
    if nargin==2 %generates a block of N random 2^b-PSK/QAM modulated symbols
        mod_object=pskmod(randi([0,M-1],1,N),M);
    else
        mod_object=pskmod(0:M-1,M);
    end
elseif b==2
    Mod='QPSK';
    A=1;
    if nargin==2 %generates a block of N random 2^b-PSK/QAM modulated symbols
        mod_object=pskmod(randi([0,M-1],1,N),M,pi/4);
    else
        mod_object=pskmod(0:M-1,M,pi/4);
    end
else
    Mod=[num2str(2^b) 'QAM'];
    Es=1;
    A=sqrt(3/2/(M-1)*Es);
    if nargin==2 %generates a block of N random 2^b-PSK/QAM modulated symbols
        mod_object=qammod(randi([0,M-1],1,N),M);
    else
        mod_object=qammod(0:M-1,M);
    end
end
modulated_symbols = A*mod_object;
end