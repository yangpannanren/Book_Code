t = 0:1/1024:1;
x = sin(2*pi*60*t);
y = hilbert(x);
plot(t(1:50),real(y(1:50)),'m-.')
hold on
plot(t(1:50),imag(y(1:50)))
hold off
axis([0 0.05 -1.1 2])
legend('实部','虚部')