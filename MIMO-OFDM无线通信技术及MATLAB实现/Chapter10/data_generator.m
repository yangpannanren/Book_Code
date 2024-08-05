function data=data_generator(L_frame,N_frames,md,zf)
data = round((md-1)*rand(L_frame,1,N_frames));
% zero forcing appendix
[m,~,o] = size(data);
data(m+1:m+zf,:,1:o) = 0;