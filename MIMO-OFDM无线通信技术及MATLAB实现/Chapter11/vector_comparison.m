function [check]=vector_comparison(vector_1,vector_2)
% check if the two vectors are the same
% Input parameters
%   pre_x : vector 1
%   now_x : vector 2
% Output parameters
%   check : 1-> same vectors, 0-> different vectors

check = 0;
len1 = length(vector_1);  len2 = length(vector_2);
if len1 ~= len2
    error('vector size is different');
end
for column_num = 1:len1
    if vector_1(column_num,1) == vector_2(column_num,1)
        check = check + 1;
    end
end
if check == len1
    check = 1;
else
    check = 0;
end