[LoD,HiD,LoR,HiR] = wfilters('bior3.5');
subplot(2,2,1)
stem(LoD,'markerfacecolor',[0 0 1]); title('分解低通滤波器');
subplot(2,2,2)
stem(LoR,'markerfacecolor',[0 0 1]); title('重建低通滤波器');
subplot(2,2,3)
stem(HiD,'markerfacecolor',[0 0 1]); title('分解高通滤波器');
subplot(2,2,4)
stem(HiR,'markerfacecolor',[0 0 1]); title('重建高通滤波器');

figure
[psi,xval] = wavefun('morl');
plot(xval,psi,'linewidth',2)
title('$\psi(x) = e^{-x^2/2} \cos{(5x)}$','Interpreter','latex',...
     'fontsize',14);
 
 [wpws,x] = wpfun('sym4',4,10);
for nn = 1:size(wpws,1)
    subplot(3,2,nn)
    plot(x,wpws(nn,:))
    axis tight
    title(['W',num2str(nn-1)]);
end