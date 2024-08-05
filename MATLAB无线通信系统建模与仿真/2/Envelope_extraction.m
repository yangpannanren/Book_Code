t = 0:1e-4:0.1;
x = (1+cos(2*pi*50*t)).*cos(2*pi*1000*t);

plot(t,x)
xlim([0 0.04])

y = hilbert(x);
env = abs(y);
plot_param = {'Color', [0.6 0.1 0.2],'Linewidth',2}; 
plot(t,x)
hold on
plot(t,[-1;1]*env,plot_param{:})
hold off
xlim([0 0.04])
title('希尔伯特包络线')

fl1 = 12;
[up1,lo1] = envelope(x,fl1,'analytic');
fl2 = 30;
[up2,lo2] = envelope(x,fl2,'analytic');
param_small = {'Color',[0.9 0.4 0.1],'Linewidth',2};
param_large = {'Color',[0 0.4 0],'Linewidth',2};
plot(t,x)
hold on
p1 = plot(t,up1,param_small{:});
plot(t,lo1,':',param_small{:});
p2 = plot(t,up2,param_large{:});
plot(t,lo2,'-.',param_large{:});
hold off
legend([p1 p2],'fl = 12','fl = 30')
xlim([0 0.04])
title('修改包络线计算方式')

wl1 = 3;
[up1,lo1] = envelope(x,wl1,'rms');
wl2 = 5;
[up2,lo2] = envelope(x,wl2,'rms');
wl3 = 300;
[up3,lo3] = envelope(x,wl3,'rms');
plot(t,x)
hold on
p1 = plot(t,up1,param_small{:});
plot(t,lo1,'--',param_small{:});
p2 = plot(t,up2,plot_param{:});
plot(t,lo2,'.',plot_param{:});
p3 = plot(t,up3,param_large{:});
plot(t,lo3,'-.',param_large{:})
hold off
legend([p1 p2 p3],'wl = 3','wl = 5','wl = 300')
xlim([0 0.04])
title('RMS包络线')

np1 = 5;
[up1,lo1] = envelope(x,np1,'peak');
np2 = 50;
[up2,lo2] = envelope(x,np2,'peak');
plot(t,x)
hold on
p1 = plot(t,up1,param_small{:});
plot(t,lo1,param_small{:})
p2 = plot(t,up2,param_large{:});
plot(t,lo2,param_large{:})
hold off
legend([p1 p2],'np = 5','np = 50')
xlim([0 0.04])
title('Peak包络线')


rng default
q = x + randn(size(x))/10;
np1 = 5;
[up1,lo1] = envelope(q,np1,'peak');
np2 = 25;
[up2,lo2] = envelope(q,np2,'peak');
plot(t,q)
hold on
p1 = plot(t,up1,param_small{:});
plot(t,lo1,param_small{:})
p2 = plot(t,up2,param_large{:});
plot(t,lo2,param_large{:})
hold off
legend([p1 p2],'np = 5','np = 25')
xlim([0 0.04])
title('Peak包络线')