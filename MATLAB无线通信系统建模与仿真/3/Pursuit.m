[mpdict,~,~,longs] = wmpdictionary(100,'lstcpt',{{'haar',2}});

for nn = 1:size(mpdict,2)
    if (nn <= longs{1}(1))
        plot(mpdict(:,nn),'k','linewidth',2)
        grid on
        xlabel('转换')
        title('Haar2级缩放')
    elseif (nn>longs{1}(1) && nn<= longs{1}(1)+longs{1}(2))
        plot(mpdict(:,nn),'r','linewidth',2)
        grid on
        xlabel('转换')
        title('Haar 2级小波')
    else
        plot(mpdict(:,nn),'b','linewidth',2)
        grid on
        xlabel('转换')
        title('Haar 1级小波')
    end
        pause(0.2)
end


load elec35_nor
x = signals(32,:);
plot(x)
xlabel('分钟');ylabel('使用')
xlim([500 1200])

dictionary = {{'db1',2},{'db1',3},'dct','sin','RnIdent',{'sym4',4}};
[mpdict,nbvect] = wmpdictionary(length(x),'lstcpt',dictionary);
[y,~,~,iopt] = wmpalg('OMP',x,mpdict);
plot(x)
hold on
plot(y,'-.')
hold off
xlabel('分钟');ylabel('使用')
legend('原始信号','OMP')

basez = cumsum(nbvect);
k = 1;
for nn = 1:length(basez)
    if (nn == 1)
        basezind{nn} = 1:basez(nn);
    else
        basezind{nn} = basez(nn-1)+1:basez(nn);
    end
end
dictvectors = cellfun(@(x)intersect(iopt,x),basezind, ...
    'UniformOutput',false);


dictionary2 = {'dct','sin'};
[mpdict2,nbvect2] = wmpdictionary(length(x),'lstcpt',dictionary2);
y2 = wmpalg('OMP',x,mpdict2,'itermax',35);
plot(x)
hold on
plot(y2,'-.','linewidth',2)
hold off
title('DCT和正弦字典')
xlabel('分钟');ylabel('使用')
xlim([500 1200])

figure
plot(x)
hold on
plot(y,'-.','linewidth',2)
hold off
title('完整字典')
xlabel('分钟');ylabel('使用')
xlim([500 1200])

xdft = fft(x);
[~,I] = sort(xdft(1:length(x)/2+1),'descend');
ind = I(1:35);

indconj = length(xdft)-ind+2;
ind = [ind indconj];
xdftapp = zeros(size(xdft));
xdftapp(ind) = xdft(ind);
xrec = ifft(xdftapp);
plot(x)
hold on
plot(xrec,'-.','LineWidth',2)
hold off
xlabel('分钟');ylabel('使用');
legend('原始信号','非线性DFT近似')

plot(x)
hold on
plot(xrec,'-.','LineWidth',2)
hold off
xlabel('分钟');ylabel('使用');
legend('原始信号','非线性DFT近似')
xlim([500 1200])