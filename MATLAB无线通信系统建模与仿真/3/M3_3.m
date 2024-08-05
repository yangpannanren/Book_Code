len = 2^11;
h = [4  -5  3  -4  5  -4.2   2.1   4.3  -3.1   5.1  -4.2];
t = [0.1  0.13  0.15  0.23  0.25  0.40  0.44  0.65  0.76  0.78  0.81];
h  = abs(h);
w  = 0.01*[0.5 0.5 0.6 1 1 3 1 1 0.5 0.8 0.5];
tt = linspace(0,1,len);
xref = zeros(1,len);
for j=1:11
    xref = xref+(h(j)./(1+((tt-t(j))/w(j)).^4));
end

rng default
x = xref + 0.5*randn(size(xref));
plot(x)
axis tight

dwtmode('per');

xd = wdenoise(x,3,'Wavelet','sym4',...
    'DenoisingMethod','UniversalThreshold','NoiseEstimate','LevelIndependent');
plot(xd)
axis tight
hold on
plot(xref,'r')
legend('降噪','参考')


load tartan;
imagesc(X); colormap(gray);

[C,S] = wavedec2(X,1,'bior2.4');
[H,V,D] = detcoef2('all',C,S,1);
A = appcoef2(C,S,'bior2.4');
subplot(221);
imagesc(A); title('近似系数');
colormap(gray);
subplot(222);
imagesc(H); title('水平系数');
subplot(223);
imagesc(V); title('垂直系数');
subplot(224);
imagesc(D); title('对角系数');


subplot(4,1,1)
plot(noisdopp)
ylabel('原始信号')
subplot(4,1,2);plot(swc(1,:))
ylabel('D1')
set(gca,'ytick',[])
subplot(4,1,3);plot(swc(3,:))
ylabel('D3')
set(gca,'ytick',[])
subplot(4,1,4);plot(swc(5,:))
ylabel('A4')
set(gca,'ytick',[])
load noisdopp
swc = swt(noisdopp,4,'sym8');