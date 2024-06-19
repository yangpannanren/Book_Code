function [symbol_replica_norm]=calculate_norm(symbol_replica,stage)
% Input parameters
%     Y_tilde : Q'*Y
%     R : [Q R] = qr(H)
%     QAM_table :
%     symbol_replica : M candidate vectors
%     stage : stage number
%     M : M parameter in M-algorithm
%     NT : number of Tx antennas
% Output parameter
%     symbol_replica_norm : norm values of M candidate vectors
global QAM_table  R  Y_tilde  NT  M;
if stage == 1
    m = 1;
else m = M;
end
stage_index = (NT+1)-stage;
for i=1:m
    X_temp = zeros(NT,1);
    for a=NT:-1:(NT+2)-stage
        X_temp(a) = QAM_table(symbol_replica((NT+1)-a,i,stage_index+1));
    end
    % reordering
    X_temp((NT+2)-stage:(NT)) = wrev(X_temp((NT+2)-stage:(NT)));
    % Y_tilde used in the current stage
    Y_tilde_now = Y_tilde((NT+1)-stage:(NT));
    % R used in the current stage
    R_now = R((NT+1)-stage:(NT),(NT+1)-stage:(NT));
    for k = 1:length(QAM_table) % norm calculation,
        % the norm values in the previous stages can be used, however,
        % we recalculate them in an effort to simplify the MATLAB code
        X_temp(stage_index) = QAM_table(k);
        X_now = X_temp((NT+1)-stage:(NT));
        symbol_replica_norm(i,k) = norm(Y_tilde_now - R_now*X_now)^2;
    end
end