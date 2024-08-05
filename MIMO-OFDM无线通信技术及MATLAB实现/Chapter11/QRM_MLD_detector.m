function [X_hat]=QRM_MLD_detector(Y,H)
% Input parameters
%     Y : received signal, nTx1
%     H : Channel matrix, nTxnT
% Output parameter
%   X_hat : estimated signal, nTx1

global QAM_table  Q  R  Y_tilde  NT  M;
% NT : Number of Tx antennas, M : Parameter M in M-algorithm
QAM_table = [-3-3j, -3-j, -3+3j, -3+j, -1-3j, -1-j, -1+3j, -1+j, 3-3j, ...
    3-j, 3+3j, 3+j, 1-3j, 1-j, 1+3j, 1+j]/sqrt(10); % QAM table
[Q, R] = qr(H);   % QR-decomposition
Y_tilde = Q'*Y;
symbol_replica = zeros(NT,M,NT); % QAM table index
for stage = 1:NT
    symbol_replica = stage_processing1(symbol_replica,stage);
end
X_hat =  QAM_table(symbol_replica(:,1));