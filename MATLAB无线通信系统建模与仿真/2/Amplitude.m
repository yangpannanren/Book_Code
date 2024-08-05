Fs = 1e3;
t = 0:0.001:1-0.001;
x = cos(2*pi*100*t)+sin(2*pi*202.5*t);

xdft = fft(x);
xdft = xdft(1:length(x)/2+1);
xdft = xdft/length(x);
xdft(2:end-1) = 2*xdft(2:end-1);
freq = 0:Fs/length(x):Fs/2;
plot(freq,abs(xdft))
hold on
plot(freq,ones(length(x)/2+1,1),'LineWidth',2)
xlabel('Hz')
ylabel('幅值')
hold off

lpad = 2*length(x);
xdft = fft(x,lpad);
xdft = xdft(1:lpad/2+1);
xdft = xdft/length(x);
xdft(2:end-1) = 2*xdft(2:end-1);
freq = 0:Fs/lpad:Fs/2;

plot(freq,abs(xdft))
hold on
plot(freq,ones(2*length(x)/2+1,1),'LineWidth',2)
xlabel('Hz')
ylabel('幅值')
hold off