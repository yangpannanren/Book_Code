length = 1e-3;
freq = 1e9;
z0 = 50;
R = 50;
L = 1e-9;
G = .01;
C = 1e-12;
%计算的参数。
s_params = rlgc2s(R,L,G,C,length,freq,z0)