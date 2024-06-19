function y_STO=add_STO(y,nSTO)
% To add STO
% Input: 
%   y    = Time-domain received signal
%   nSTO = Sampling numbers to STO;

if nSTO>=0
    y_STO = [y(nSTO+1:end) zeros(1,nSTO)]; % forward
else
    y_STO = [zeros(1,-nSTO) y(1:end+nSTO)]; % backward
end 
    