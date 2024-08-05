vp  = physconst('lightspeed');
f   = 850e6;
lambda = vp./f;
%在两端建立一个平面偶极子与电容负载。
L = 0.15;
W = 1.5*L;
stripL = L;
gapx = .015;
gapy = .01;
r1 = antenna.Rectangle('Center',[0,0],'Length',L,'Width',W,'Center',[lambda*0.35,0]);
r2 = antenna.Rectangle('Center',[0,0],'Length',L,'Width',W,'Center',[-lambda*0.35,0]);
r3 = antenna.Rectangle('Length',0.5*lambda,'Width',0.02*lambda,'NumPoints',2);
s = r1 + r2 + r3;
figure
show(s)
%将散热器形状分配给pcbStack，并对板形状和馈电直径属性进行更改。
boardShape = antenna.Rectangle('Length',0.6,'Width',0.3);
p = pcbStack;
p.BoardShape = boardShape;
p.Layers = {s};
p.FeedDiameter = .02*lambda/2;
p.FeedLocations = [0 0 1];
figure
show(p)
%分析天线的阻抗。末端载荷的影响会导致串联共振在频带内被推低。
figure
impedance(p,linspace(200e6,1e9,51))