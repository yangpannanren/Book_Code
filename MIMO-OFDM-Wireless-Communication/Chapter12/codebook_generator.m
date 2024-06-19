function [code_book]=codebook_generator

% N_Nt: number of Tx antennas
% N_M : codeword length
% N_L : codebook size
N_Nt=4;
% N_M=2;
N_L=64;
cloumn_index=[1 2];
rotation_vector=[1 7 52 56];
kk=0:N_Nt-1;
ll=0:N_Nt-1;
w = exp(1i*2*pi/N_Nt*kk.'*ll)/sqrt(N_Nt);
w_1 = w(:,cloumn_index([1 2]));
theta = diag(exp(1i*2*pi/N_L*rotation_vector));
code_book(:,:,1) = w_1;
for i=1:N_L-1
    code_book(:,:,i+1) = theta*code_book(:,:,i);
end