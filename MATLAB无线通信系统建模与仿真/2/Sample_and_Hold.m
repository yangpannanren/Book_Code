fs = 16;
t = 0:1/fs:1-1/fs;
x = .9*sin(2*pi*t);
stem(t,x)
hold on
stairs(t,x)
hold off


ups = 4;
fu = fs*ups;
tu = 0:1/fu:1-1/fu;
y = upsample(x,ups);
stem(tu,y,'--x')
hold on
stairs(t,x)
hold off

h = ones(ups,1);
z = filter(h,1,y);
stem(tu,z,'--.')
hold on
stairs(t,x)
hold off

zi = interp1(t,x,tu,'nearest');
dl = floor(ups/2);
stem(tu(1+dl:end),zi(1:end-dl),'--.')
hold on
stairs(t,x)
hold off

q = resample(x,ups,1,0);

stem(tu(1+dl:end),q(1:end-dl),'--.')
hold on
stairs(t,x)
hold off