meter = 1;
hertz = 1;
ohm = 1;
mm = 1e-3*meter;
GHz = 1e9*hertz;

L1 = 13.5*mm;
W1 = 12.5*mm;
L2 = 15*mm;
W2 = 16*mm;
d1 = 1.524*mm;
d2 = 2.5*mm;
xp = 5.4*mm;
r_0 = 0.325*mm;
Lgnd = 3*L2;
Wgnd = 3*L2;

pU = antenna.Rectangle('Length',L2,'Width',W2);
pL = antenna.Rectangle('Length',L1,'Width',W1);
pGnd = antenna.Rectangle('Length',Lgnd,'Width',Wgnd);
figure
plot(pGnd)
hold on
plot(pU)
plot(pL)
grid on
legend('接地面','上补丁','下补丁','Location','best')

epsr_1 = 2.2;
tandelta_1 = 0.001;
dL = dielectric;
dL.Name = 'Lower sub';
dL.EpsilonR = epsr_1;
dL.LossTangent = tandelta_1;
dL.Thickness = d1;

epsr_2 = 1.07;
tandelta_2 = 0.001;
dU = dielectric;
dU.Name = 'Upper sub';
dU.EpsilonR = epsr_2;
dU.LossTangent = tandelta_2;
dU.Thickness = d2;

p = pcbStack;
p.Name = 'Stacked patch - Waterhouse';
p.BoardShape = pGnd;
p.BoardThickness = d1+d2;
p.Layers = {pU,dU,pL,dL,pGnd};
p.FeedLocations = [xp 0 3 5];
p.FeedDiameter = 2*r_0;
p.FeedViaModel = 'square';
figure
show(p)

fmax = 9*GHz;
fmin = 6*GHz;
deltaf = 0.125*GHz;
freq = fmin:deltaf:fmax;
mesh(p,'MaxEdgeLength',.01,'MinEdgeLength',.003)

 figure
impedance(p,freq)  %效果如图6-54所示


figure
mesh(p,'view','metal')

figure
mesh(p,'view','dielectric surface')

Zref = 50*ohm;
s = sparameters(p,freq,Zref);
figure
rfplot(s,1,1)
title('S_1_1')
xlabel('频率(Hz)')
ylabel('幅度(dB')

figure
smplot = smithplot(s);
smplot.TitleTop = '输入反射系数';
smplot.LineWidth = 3;


patternfreqs = [6.75*GHz, 8.25*GHz];
freqIndx = arrayfun(@(x) find(freq==x),patternfreqs);
figure
pattern(p,freq(freqIndx(1)))

figure
pattern(p,freq(freqIndx(2)))

D = zeros(1,numel(freq));
az = 0;
el = 90;
for i = 1:numel(freq)
    D(i) = pattern(p,freq(i),az,el);
end


h = figure;
plot(freq./GHz,D,'-*','LineWidth',2)
xlabel('频率(Hz)')
ylabel('幅度(dB')
grid on
title('增益随频率变化')

gamma = rfparam(s,1,1);
mismatchFactor = 10*log10(1 - abs(gamma).^2);


Gr = mismatchFactor.' + D;
figure(h)
hold on
plot(freq./GHz,Gr,'r-.')
legend('增益','实际增益','Location','best')
title('增益和实际增益随频率的变化')
hold off