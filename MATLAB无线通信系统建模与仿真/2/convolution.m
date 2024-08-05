x = [2 1 2 1];
y = [1 2 3];
clin = conv(x,y);

xpad = [x zeros(1,6-length(x))];
ypad = [y zeros(1,6-length(y))];
ccirc = ifft(fft(xpad).*fft(ypad));

subplot(2,1,1)
stem(clin,'filled')
ylim([0 11])
title('x和y的线性卷积')
subplot(2,1,2)
stem(ccirc,'filled')
ylim([0 11])
title('xpad和ypad的循环卷积')

N = length(x)+length(y)-1;
xpad = [x zeros(1,12-length(x))];
ypad = [y zeros(1,12-length(y))];
ccirc = ifft(fft(xpad).*fft(ypad));
ccirc = ccirc(1:N);