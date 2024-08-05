function y=add_CP(x,Ncp)
% Add cyclic prefix
y = [x(:,end-Ncp+1:end) x];