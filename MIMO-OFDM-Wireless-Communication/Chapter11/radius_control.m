function [flag,transition,radius_squared,x_list]=radius_control(radius_squared,transition)
% Input parameters
%     radius_squared : current radius
%     transition : current stage number
% Output parameters
%     radius_squared : doubled radius
%     transition : next stage number
%     flag : next stage number is calculated from flag

global len
radius_squared = radius_squared*2;
transition = transition+1;
flag = 1;
x_list(len,:)=zeros(1,4);