function[symbol_replica]=stage_processing1(symbol_replica,stage)
% Input parameters:
% symbol_replica :M candidate vectors
% stage: indicates the stage number
%
% Output parameters:
% symbol_replica :M candidate vectors
global NT; % Number of transmitting antennas
global M; % M algorithm parameter
if stage == 1
    m=l;
else
    m = M;
end
symbol_replica_norm=calculate_norm(symbol_replica,stage);
% sorted by norm value and the data is in matrix form
[symbol_replica_norm_sorted, symbol_replica_sorted]=...
    sort_matrix(symbol_replica_norm);
symbol_replica_norm_sorted = symbol_replica_norm_sorted(1:M);
symbol_replica_sorted = symbol_replica_sorted(:,1:M);
if stage >= 2
    for i= 1:m
        symbol_replica_sorted(2:stage,i)=...
            symbol_replica(1:stage-1,symbol_replica_sorted(2,i),(NT+2)-stage);
    end
end
if stage == 1 % in stage 1, symbol_replica_sorted has a size of 2xM, and the second line is not necessary
    symbol_replica(1:stage,:,(NT+1)-stage)=symbol_replica_sorted(1,:);
else
    symbol_replica(1:stage,:,(NT+1)-stage)= symbol_replica_sorted;
end