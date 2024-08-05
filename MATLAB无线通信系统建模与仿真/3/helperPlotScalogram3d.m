function helperPlotScalogram3d(sig,Fs)
%它可能会在未来的版本中更改或删除
figure
[cfs,f] = cwt(sig,Fs);
sigLen = numel(sig);
t = (0:sigLen-1)/Fs;
surface(t,f,abs(cfs));
xlabel('时间(s)')
ylabel('频率(Hz)')
zlabel('幅值')
title('三维表面图')
set(gca,'yscale','log')
shading interp
view([-40 30])
end