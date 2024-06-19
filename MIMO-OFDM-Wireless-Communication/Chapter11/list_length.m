function [len]=list_length(list)
% Input parameter
%     list : vector type
% Output parameter
%     len : index number

len = 0;
for i=1:4
    if list(i)==0
        break;
    else
        len = len+1;
    end
end